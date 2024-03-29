% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/internal.R
\name{estimate_raster_size}
\alias{estimate_raster_size}
\title{Estimate download size of DEMs}
\usage{
estimate_raster_size(locations, prj, src, z = NULL)
}
\arguments{
\item{locations}{the locations}

\item{prj}{prj string as set earlier by get_elev_point or get_elev_raster}

\item{src}{the src}

\item{z}{zoom level if source is aws}
}
\description{
Estimate download size of DEMs
}
\keyword{internal}
