#' Get Point Elevation
#' 
#' This function provides access to point elevations using either the USGS 
#' Elevation Point Query Service (US Only) or by extracting point elevations 
#' from the AWS Terrain Tiles.  The function accepts a \code{data.frame} of x 
#' (long) and y (lat) or a \code{SpatialPoints}/\code{SpatialPointsDataFame} as 
#' input.  A SpatialPointsDataFrame is returned with elevation as an added 
#' \code{data.frame}.
#' 
#' @param locations Either a \code{data.frame} with x (e.g. longitude) as the 
#'                  first column and y (e.g. latitude) as the second column, a 
#'                  \code{SpatialPoints}/\code{SpatialPointsDataFrame}, or a 
#'                  \code{sf} \code{POINT} or \code{MULTIPOINT} object.   
#'                  Elevation for these points will be returned in the 
#'                  originally supplied class.
#' @param prj A PROJ.4 string defining the projection of the locations argument. 
#'            If a \code{SpatialPoints} or \code{SpatialPointsDataFrame} is 
#'            provided, the PROJ.4 string will be taken from that.  This 
#'            argument is required for a \code{data.frame} of locations.
#' @param src A character indicating which API to use, either "epqs" or "aws" 
#'            accepted. The "epqs" source is relatively slow for larger numbers 
#'            of points (e.g. > 500).  The "aws" source may be quicker in these 
#'            cases provided the points are in a similar geographic area.  The 
#'            "aws" source downloads a DEM using \code{get_elev_raster} and then
#'            extracts the elevation for each point. 
#' @param ... Additional arguments passed to get_epqs or get_aws_points.  When 
#'            using "aws" as the source, pay attention to the `z` argument.  A 
#'            defualt of 5 is used, but this uses a raster with a large ~4-5 km 
#'            pixel.  Additionally, the source data changes as zoom levels 
#'            increase.  
#'            Read \url{https://github.com/tilezen/joerd/blob/master/docs/data-sources.md#what-is-the-ground-resolution} 
#'            for details.  
#' @return Function returns a \code{SpatialPointsDataFrame} or \code{sf} object 
#'         in the projection specified by the \code{prj} argument.
#' @export
#' @importFrom sp wkt
#' @examples
#' \dontrun{
#' mt_wash <- data.frame(x = -71.3036, y = 44.2700)
#' mt_mans <- data.frame(x = -72.8145, y = 44.5438)
#' mts <- rbind(mt_wash,mt_mans)
#' ll_prj <- "EPSG:4326"
#' mts_sp <- sp::SpatialPoints(sp::coordinates(mts), 
#'                             proj4string = sp::CRS(ll_prj)) 
#' get_elev_point(locations = mt_wash, prj = ll_prj)
#' get_elev_point(locations = mt_wash, units="feet", prj = ll_prj)
#' get_elev_point(locations = mt_wash, units="meters", prj = ll_prj)
#' get_elev_point(locations = mts_sp)
#' 
#' # Code to split into a loop and grab point at a time.
#' # This is usually faster for points that are spread apart 
#'  
#' library(dplyr)
#' 
#' elev <- vector("numeric", length = nrow(mts))
#' pb <- progress_estimated(length(elev))
#' for(i in seq_along(mts)){
#' pb$tick()$print()
#' elev[i]<-suppressMessages(get_elev_point(locations = mts[i,], prj = ll_prj, 
#'                                         src = "aws", z = 14)$elevation)
#'                                         }
#' mts_elev <- cbind(mts, elev)
#' mts_elev
#' }
get_elev_point <- function(locations, prj = NULL, src = c("epqs", "aws"), ...){
  
  src <- match.arg(src)
  sf_check <- "sf" %in% class(locations)
  # Check location type and if sp or raster, set prj.  If no prj (for either) then error
  
  locations <- loc_check(locations,prj)
  prj <- sp::wkt(locations)
  
  # Pass of reprojected to epqs or mapzen to get data as spatialpointsdataframe
  if (src == "epqs"){
    locations_prj <- get_epqs(locations, ...)
    units <- locations_prj[[2]]
    locations_prj <- locations_prj[[1]]
  } 
  
  if(src == "aws"){
    locations_prj <- get_aws_points(locations, ...)
    units <- locations_prj[[2]]
    locations_prj <- locations_prj[[1]]
  }

  # Re-project back to original, add in units, and return
  locations <- sp::spTransform(locations_prj,sp::CRS(prj))
  if(any(names(list(...)) %in% "units")){
    if(list(...)$units == "feet"){
      locations$elev_units <- rep("feet", nrow(locations))
    } else {
      locations$elev_units <- rep("meters", nrow(locations))
    }
  } else {
    locations$elev_units <- rep("meters", nrow(locations))
  }
  if(sf_check){locations <- sf::st_as_sf(locations)}
  message(paste("Note: Elevation units are in", units, 
                "\nNote:. The coordinate reference system is:\n", prj))
  locations
}

#' Get point elevation data from the USGS Elevation Point Query Service
#' 
#' Function for accessing elevation data from the USGS epqs
#' 
#' @param locations A SpatialPointsDataFrame of the location(s) for which you 
#'                  wish to return elevation. The first column is Longitude and 
#'                  the second column is Latitude.  
#' @param units Character string of either meters or feet. Conversions for 
#'              'epqs' are handled by the API itself.
#' @return a list with a SpatialPointsDataFrame or sf POINT or MULTIPOINT object with 
#'         elevation added to the data slot and a character of the elevation units
#' @export
#' @keywords internal
get_epqs <- function(locations, units = c("meters","feet")){
  
  ll_prj <- "GEOGCRS[\"unknown\",\n    DATUM[\"World Geodetic System 1984\",\n        ELLIPSOID[\"WGS 84\",6378137,298.257223563,\n            LENGTHUNIT[\"metre\",1]],\n        ID[\"EPSG\",6326]],\n    PRIMEM[\"Greenwich\",0,\n        ANGLEUNIT[\"degree\",0.0174532925199433],\n        ID[\"EPSG\",8901]],\n    CS[ellipsoidal,2],\n        AXIS[\"longitude\",east,\n            ORDER[1],\n            ANGLEUNIT[\"degree\",0.0174532925199433,\n                ID[\"EPSG\",9122]]],\n        AXIS[\"latitude\",north,\n            ORDER[2],\n            ANGLEUNIT[\"degree\",0.0174532925199433,\n                ID[\"EPSG\",9122]]]]"
  
  base_url <- "https://nationalmap.gov/epqs/pqs.php?"
  if(match.arg(units) == "meters"){
    units <- "Meters"
  } else if(match.arg(units) == "feet"){
    units <- "Feet"
  }
  
  locations <- sp::spTransform(locations,
                                   sp::CRS(ll_prj))
  units <- paste0("&units=",units)
  pb <- progress::progress_bar$new(format = " Accessing point elevations [:bar] :percent",
                                   total = nrow(locations), clear = FALSE, 
                                   width= 60)
  for(i in seq_along(locations[,1])){
    x <- sp::coordinates(locations)[i,1]
    y <- sp::coordinates(locations)[i,2]
    loc <- paste0("x=",x, "&y=", y)
    url <- paste0(base_url,loc,units,"&output=json")
    resp <- httr::GET(url)
    if (httr::http_type(resp) != "application/json") {
      stop("API did not return json", call. = FALSE)
    } 
    resp <- jsonlite::fromJSON(httr::content(resp, "text", encoding = "UTF-8"), 
                               simplifyVector = FALSE
                                )
    locations$elevation[i] <- as.numeric(resp[[1]][[1]]$Elevation)
    pb$tick()
    Sys.sleep(1 / 100)
  }
  
  # For areas without epqs values that return -1000000, switch to NA
  locations[locations$elevation == -1000000] <- NA
  location_list <- list(locations, units)
  location_list
}

#' Get point elevation data from the AWS Terrain Tiles
#' 
#' Function for accessing elevation data from AWS and extracting the elevations 
#' 
#' @param locations Either a \code{data.frame} with x (e.g. longitude) as the 
#'                  first column and y (e.g. latitude) as the second column, a 
#'                  \code{SpatialPoints}/\code{SpatialPointsDataFrame}, or a 
#'                  \code{sf} \code{POINT} or \code{MULTIPOINT} object.   
#'                  Elevation for these points will be returned in the 
#'                  originally supplied class.
#' @param z The zoom level to return.  The zoom ranges from 1 to 14.  Resolution
#'           of the resultant raster is determined by the zoom and latitude.  For 
#'           details on zoom and resolution see the documentation from Mapzen at 
#'           \url{https://github.com/tilezen/joerd/blob/master/docs/data-sources.md#what-is-the-ground-resolution}.  
#'           default value is 5 is supplied.   
#' @param units Character string of either meters or feet. Conversions for 
#'              'aws' are handled in R as the AWS terrain tiles are served in 
#'              meters.               
#' @param ... Arguments to be passed to \code{get_elev_raster}
#' @return a list with a SpatialPointsDataFrame or sf POINT or MULTIPOINT object with 
#'         elevation added to the data slot and a character of the elevation units
#' @export
#' @keywords internal
get_aws_points <- function(locations, z=5, units = c("meters", "feet"), ...){
  units <- match.arg(units)
  dem <- suppressMessages(get_elev_raster(locations, z, ...))
  elevation <- raster::extract(dem, locations)
  if(units == "feet") {elevation <- elevation * 3.28084}
  locations$elevation <- round(elevation, 2)
  location_list <- list(locations, units)
  location_list
}






































