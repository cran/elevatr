
[![Travis](https://travis-ci.org/jhollist/elevatr.svg?branch=master)](https://travis-ci.org/jhollist/elevatr)
[![Appveyor](https://ci.appveyor.com/api/projects/status/github/jhollist/elevatr?svg=true)](https://ci.appveyor.com/project/jhollist/elevatr)
[![](http://www.r-pkg.org/badges/version/elevatr)](http://www.r-pkg.org/pkg/elevatr)
[![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/elevatr)](http://www.r-pkg.org/pkg/elevatr)
[![Coverage Status](https://coveralls.io/repos/github/jhollist/elevatr/badge.svg?branch=master)](https://coveralls.io/github/jhollist/elevatr?branch=master)

# elevatr
An R package for accessing elevation data from various sources

The `elevatr` package currently provides access to elevation data from from Mapzen ([Mapzen Tile Service](https://mapzen.com/documentation/terrain-tiles/) for raster digital elevation models.  For point elevation data, either the [Mapzen Elevation Service](https://mapzen.com/documentation/elevation/elevation-service/) or the [USGS Elevation Point Query Service](http://ned.usgs.gov/epqs/)) may be used. Additional elevation data sources may be added.

Current plan for this package includes just two functions to access elevation web services:

- `get_elev_point()`:  Get point elevations using the Mapzen Elevation Service or the USGS Elevation Point Query Service (for the US Only) .  This will accept a data frame of x (long) and y (lat) or a SpatialPoints/SpatialPointsDataFame as input.  A SpatialPointsDataFrame is returned.
- `get_elev_raster()`: Get elevation data as a raster (e.g. a Digital Elevation Model) from the Mapzen Terrain GeoTIFF Service.  Other sources may be added later.  This will accept a data frame of of x (long) and y (lat) or any `sp` or `raster` object as input and will return a `raster` object of the elevation tiles that cover the bounding box of the input spatial data. 

## Installation

This package is currently in development and should not be considered stable.  The functions and API may change drastically and rapidly and it may not work at any given moment...  That being said, install with `devtools`


```r
library(devtools)
install_github("jhollist/elevatr")
```

## API Keys

The `elevatr` packages will look for API keys stored as environment variables.  Currently the only API key required is from Mapzen.  Go to <https://mapzen.com/developers> and create a new key.  Copy this key and add to your `.Renviron` file.  This can be done using the method suggested [here](http://happygitwithr.com/api-tokens.html).  For example:

```
cat("mapzen_key=mapzen-XXXXXXX\n",
    file=file.path(normalizePath("~/"), ".Renviron"),
    append=TRUE)
```

You will need to restart R, but once the key is there you are good to go on that machine.  `elevatr` will access the key via `Sys.getenv("mapzen_key")`

## Attribution
Mapzen terrain tiles contain 3DEP, SRTM, and GMTED2010 content courtesy of the U.S. Geological Survey and ETOPO1 content courtesy of U.S. National Oceanic and Atmospheric Administration.

## EPA Disclaimer
The United States Environmental Protection Agency (EPA) GitHub project code is provided on an "as is" basis and the user assumes responsibility for its use. EPA has relinquished control of the information and no longer has responsibility to protect the integrity , confidentiality, or availability of the information. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by EPA. The EPA seal and logo shall not be used in any manner to imply endorsement of any commercial product or activity by EPA or the United States Government.
