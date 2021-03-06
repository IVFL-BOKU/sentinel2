% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/S2_put_roi.R
\name{S2_put_roi}
\alias{S2_put_roi}
\title{Creates new or update existing regions of interest}
\usage{
S2_put_roi(geometry, regionId = NULL, cloudCovMax = 50,
  indicators = NULL, dateMin = NULL, dateMax = NULL, srid = 4326)
}
\arguments{
\item{geometry}{SpatialPoints, SpatialPolygons or path to a shapefile on disk}

\item{regionId}{character a new or existing region name}

\item{cloudCovMax}{integer cloud coverage treshold for a given region}

\item{indicators}{character vector of indicator names to be computed for a
given region (e.g. \code{c("LAI", "FAPAR")})}

\item{dateMin}{character, date 'YYYY-MM-DD' beginning of the region's time span}

\item{dateMax}{character, date 'YYYY-MM-DD' end of the region's time span}

\item{srid}{integer geometry projection SRID (e.g. 4326 for WGS-84)}
}
\value{
object describing the created ROI (as returned by the REST API)
}
\description{
Place/Update roi for processing Sentinel-2 data
}
