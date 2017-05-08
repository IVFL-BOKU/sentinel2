#' Prepare a list to query database for 'angle'
#'
#' Implements the query options for 'angle' found in the wiki
#' @param angleType see wiki
#' @param band see wiki
#' @param broken see wiki
#' @param dateMin see wiki
#' @param dateMax see wiki
#' @param geometry see wiki
#' @param granule see wiki
#' @param granuleId see wiki
#' @param orbitNo see wiki
#' @param product see wiki
#' @param productId see wiki
#' @param retGeometry logical should product geometry be included in the response?
#' @param utm see wiki
#' @param dateSingle character date of format "YYYY-MM-DD", specifies a single
#'   date and will override \code{dateMin} and \code{dateMax}.
#' @param ... further arguments, none implemented
#' @return list of query arguments
#' @export

S2_query_angle <- function(angleType    = NULL,
                           band         = NULL,
                           broken       = FALSE,
                           dateMax      = Sys.Date(),
                           dateMin      = '2000-01-01',
                           geometry     = NULL,
                           granule      = NULL,
                           granuleId    = NULL,
                           orbitNo      = NULL,
                           product      = NULL,
                           productId    = NULL,
                           retGeometry  = FALSE,
                           utm          = NULL,
                           dateSingle   = NULL,
                           ...){

  # check inputs ---------------------------------------------------------------
  if (!is.null(dateSingle)){
    check_date(dateSingle)
    dateMin    <- dateSingle
    dateMax    <- dateSingle
    dateSingle <- NULL
  }

  if(check_date(dateMin) > check_date(dateMax)){
    stop("'dateMin' (", dateMin, ") larger than 'dateMax' (", dateMax, ")")
  }

  # prepare json geometry ------------------------------------------------------
  if (!is.null(geometry)) geometry <- roi_to_jgeom(geometry)

  # make named query list ------------------------------------------------------
  query <- c(as.list(environment()), list(...))
  query <- query[!sapply(query, is.null)]

  # return query list ----------------------------------------------------------
  rtrn  <- S2_do_query(query = query, path = 'angle')
  return(rtrn)
}

