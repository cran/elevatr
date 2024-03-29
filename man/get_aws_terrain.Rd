% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_elev_raster.R
\name{get_aws_terrain}
\alias{get_aws_terrain}
\title{Get a digital elevation model from the AWS Terrain Tiles}
\source{
Attribution: Mapzen terrain tiles contain 3DEP, SRTM, and GMTED2010 
        content courtesy of the U.S. Geological Survey and ETOPO1 content 
        courtesy of U.S. National Oceanic and Atmospheric Administration. 
        \url{https://github.com/tilezen/joerd/tree/master/docs}
}
\usage{
get_aws_terrain(
  locations,
  z,
  prj,
  expand = NULL,
  ncpu = future::availableCores() - 1,
  serial = NULL,
  ...
)
}
\arguments{
\item{locations}{Either a \code{data.frame} of x (long) and y (lat), an 
\code{sp}, \code{sf}, or \code{raster} object as input.}

\item{z}{The zoom level to return.  The zoom ranges from 1 to 14.  Resolution
of the resultant raster is determined by the zoom and latitude.  For 
details on zoom and resolution see the documentation from Mapzen at 
\url{https://github.com/tilezen/joerd/blob/master/docs/data-sources.md#what-is-the-ground-resolution}}

\item{prj}{A valid input to \code{\link{st_crs}} If a \code{sf} 
object or a \code{terra} object is provided as the \code{locations}, 
the prj is optional and will be taken from \code{locations}.  This 
argument is required for a \code{data.frame} of locations.}

\item{expand}{A numeric value of a distance, in map units, used to expand the
bounding box that is used to fetch the terrain tiles. This can 
be used for features that fall close to the edge of a tile and 
additional area around the feature is desired. Default is NULL.}

\item{ncpu}{Number of CPU's to use when downloading aws tiles.}

\item{serial}{Logical to determine if API should be hit in serial or in 
parallel.  TRUE will use purrr, FALSE will use furrr.}

\item{...}{Extra configuration parameters to be passed to httr::GET.  Common 
usage is to adjust timeout.  This is done as 
\code{config=timeout(x)} where \code{x} is a numeric value in 
seconds.  Multiple configuration functions may be passed as a 
vector.}
}
\description{
This function uses the AWS Terrain Tile service to retrieve an elevation
raster from the geotiff service.  It accepts a \code{sf::st_bbox} object as 
input and returns a single raster object covering that extent.
}
\keyword{internal}
