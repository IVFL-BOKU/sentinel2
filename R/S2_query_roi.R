#' Prepare a list to query database for 'roi'
#'
#' Implements the query options for roi found in the wiki
#'
#' @param dateMax see wiki
#' @param dateMin see wiki
#' @param geometry see wiki
#' @param regionId see wiki
#' @param utm see wiki
#' @param dateSingle see wiki
#' @param ... further arguments, none implemented
#' @return list of query arguments
#' @export

S2_query_roi <- function(dateMax      = Sys.Date(),
                         dateMin      = as.Date(dateMax) - 365,
                         geometry     = NULL,
                         regionId     = NULL,
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
  rtrn  <- S2_do_query(query = query, path = 'roi')
  return(rtrn)
}

