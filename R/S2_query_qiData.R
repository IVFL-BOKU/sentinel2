#' Prepare a list to query database for 'qiData'
#'
#' Implements the query options for qiData found in the wiki
#' @param atmCorr see wiki
#' @param band see wiki
#' @param broken see wiki
#' @param cloudCovMin see wiki
#' @param cloudCovMax see wiki
#' @param dateMax see wiki
#' @param dateMin see wiki
#' @param geometry see wiki
#' @param granule see wiki
#' @param granuleId see wiki
#' @param orbitNo see wiki
#' @param product see wiki
#' @param productId see wiki
#' @param retGeometry see wiki
#' @param utm see wiki
#' @param dateSingle see wiki
#' @param ... further arguments, none implemented
#' @return list of query arguments
#' @export

S2_query_qiData <- function(atmCorr      = NULL,
                            band         = NULL,
                            broken       = 0,
                            cloudCovMin  = 0,
                            cloudCovMax  = 100,
                            dateMax      = Sys.Date(),
                            dateMin      = as.Date(dateMax) - 365,
                            geometry     = NULL,
                            granule      = NULL,
                            granuleId    = NULL,
                            orbitNo      = NULL,
                            product      = NULL,
                            productId    = NULL,
                            retGeometry  = 0,
                            utm          = NULL,
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
  rtrn  <- S2_do_query(query = query, path = 'qiData')
  return(rtrn)
}

