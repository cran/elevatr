
[![Travis](https://api.travis-ci.org/jhollist/elevatr.png?branch=master)](https://travis-ci.org/jhollist/elevatr)
[![Appveyor](https://ci.appveyor.com/api/projects/status/github/jhollist/elevatr?svg=true)](https://ci.appveyor.com/project/jhollist/elevatr)
[![](http://www.r-pkg.org/badges/version/elevatr)](http://www.r-pkg.org/pkg/elevatr)
[![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/elevatr)](http://www.r-pkg.org/pkg/elevatr)
[![Coverage Status](https://coveralls.io/repos/github/jhollist/elevatr/badge.svg?branch=master)](https://coveralls.io/github/jhollist/elevatr?branch=master)
[![DOI](https://zenodo.org/badge/65325400.svg)](https://zenodo.org/badge/latestdoi/65325400)

# elevatr
An R package for accessing elevation data from various sources

The `elevatr` package currently provides access to elevation data from AWS Open Data [Terrain Tiles](https://registry.opendata.aws/terrain-tiles/) for raster digital elevation models.  For point elevation data,the [USGS Elevation Point Query Service](http://ned.usgs.gov/epqs/)) may be used or the point elevations may be derived from the AWS Tiles. Additional elevation data sources may be added.

Currently this package includes just two primary functions to access elevation web services:

- `get_elev_point()`:  Get point elevations using the USGS Elevation Point Query Service (for the US Only) or using the AWS Terrian Tiles (global).  This will accept a data frame of x (long) and y (lat), a SpatialPoints/SpatialPointsDataFame, or a Simple Features object as input.  A SpatialPointsDataFrame or Simple Features object is returned, depending on the class of the input locations.
- `get_elev_raster()`: Get elevation data as a raster (e.g. a Digital Elevation Model) from the AWS Open Data Terrain Tiles.  Other sources may be added later.  This will accept a data frame of of x (long) and y (lat) or any `sp` or `raster` object as input and will return a `raster` object of the elevation tiles that cover the bounding box of the input spatial data. 

## Installation

Version 0.2.0 of this package is currently available from CRAN and may be installed by:


```r
install.packages("elevatr")
```

The development version (this repo) may installed with `devtools`:


```r
library(devtools)
install_github("jhollist/elevatr")
```


## Attribution
Mapzen terrain tiles (which supply the AWS source) contain 3DEP, SRTM, and GMTED2010 content courtesy of the U.S. Geological Survey and ETOPO1 content courtesy of U.S. National Oceanic and Atmospheric Administration.

## Repositories
The source code for this repository is maintained at https://github.com/jhollist/elevatr which is also mirrored at https://github.com/usepa/elevatr

## EPA Disclaimer
The United States Environmental Protection Agency (EPA) GitHub project code is provided on an "as is" basis and the user assumes responsibility for its use. EPA has relinquished control of the information and no longer has responsibility to protect the integrity , confidentiality, or availability of the information. Any reference to specific commercial products, processes, or services by service mark, trademark, manufacturer, or otherwise, does not constitute or imply their endorsement, recommendation or favoring by EPA. The EPA seal and logo shall not be used in any manner to imply endorsement of any commercial product or activity by EPA or the United States Government.
