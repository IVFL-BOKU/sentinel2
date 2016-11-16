#' Query database for 'roi'
#'
#' Implements the query options for roi described in the wiki.
#'
#' @param dateMax character end date of format "YYYY-MM-DD".
#' @param dateMin character start date of format "YYYY-MM-DD".
#' @param geometry geometry which should intersect with granules. Can be a
#'   geoJSON geometry string (e.g. {"type":"Point","coordinates":[16.5,48.5]}),
#'   the path to a Point/Polygon shapefile, a SpatialPoints object or a
#'   SpatialPolygons object.
#' @param regionId chracter name of the 'roi'
#' @param utm character UTM zone, e.g. 33U, 01C.
#' @param dateSingle character date of format "YYYY-MM-DD", specifies a single
#'   date and will override \code{dateMin} and \code{dateMax}.
#' @param ... further arguments, none implemented.
#' @return data.frame return of the database.
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
  rtrn  <- S2_do_query(query = query, path = 'roi')
  return(rtrn)
}

