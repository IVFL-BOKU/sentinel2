#' Prepare a list to query database for 'job'
#'
#' Implements the query options for 'job' found in the wiki
#' @param dateMax see wiki
#' @param dateMin see wiki
#' @param ended see wiki
#' @param failed see wiki
#' @param geometry see wiki
#' @param jobId see wiki
#' @param granule see wiki
#' @param granuleId see wiki
#' @param product see wiki
#' @param productId see wiki
#' @param retGeometry see wiki
#' @param started see wiki
#' @param dateSingle see wiki
#' @param ... further arguments, none implemented
#' @return list of query arguments
#' @export

S2_query_job <- function(dateMax      = Sys.Date(),
                         dateMin      = as.Date(dateMax) - 365,
                         ended        = 1,
                         failed       = 0,
                         geometry     = NULL,
                         jobId        = NULL,
                         granule      = NULL,
                         granuleId    = NULL,
                         product      = NULL,
                         productId    = NULL,
                         retGeometry  = 0,
                         started      = NULL,
                         dateSingle   = NULL,
                         ...){

  # check inputs ---------------------------------------------------------------
  if (!is.null(dateSingle)){
    dateMin    <- dateSingle
    dateMax    <- dateSingle
    dateSingle <- NULL
  }

  if (!is.null(geometry)) geometry <- roi_to_jgeom(geometry)

  # make named query list ------------------------------------------------------
  query <- c(as.list(environment()), list(...))
  query <- query[!sapply(query, is.null)]

  # return query list ----------------------------------------------------------
  rtrn  <- S2_do_query(query = query, path = 'job')
  return(rtrn)
}

