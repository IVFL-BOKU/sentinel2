% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/S2_query_roi.R
\name{S2_query_roi}
\alias{S2_query_roi}
\title{Prepare a list to query database for 'roi'}
\usage{
S2_query_roi(dateMax = Sys.Date(), dateMin = as.Date(dateMax) - 365,
  geometry = NULL, regionId = NULL, utm = NULL, dateSingle = NULL, ...)
}
\arguments{
\item{dateMax}{see wiki}

\item{dateMin}{see wiki}

\item{geometry}{see wiki}

\item{regionId}{see wiki}

\item{utm}{see wiki}

\item{dateSingle}{see wiki}

\item{...}{further arguments, none implemented}
}
\value{
list of query arguments
}
\description{
Implements the query options for roi found in the wiki
}
