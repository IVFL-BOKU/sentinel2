#' Query database for 'product'
#'
#' Implements the query options for 'product' described in the wiki.
#' @param atmCorr logical if TRUE only results for atmospherically corrected
#'   data are returned.
#' @param dateMax character end date of format "YYYY-MM-DD".
#' @param dateMin character start date of format "YYYY-MM-DD".
#' @param geometry geometry which should intersect with granules. Can be a
#'   geoJSON geometry string (e.g. {"type":"Point","coordinates":[16.5,48.5]}),
#'   the path to a Point/Polygon shapefile, a SpatialPoints object or a
#'   SpatialPolygons object.
#' @param orbitDir character NULL or one of c("DESCENDING", "ASCENDING").
#' @param orbitNo integer from 1 to 143.
#' @param product charactrer ESA product id.
#' @param productId internal metadata database product id.
#' @param regionId region of interest id (overrides the \code{geometry} parameter,
#'   if \code{dateMin} or \code{dateMax}} are not specified, they are taken from the region of interest settings)
#' @param retGeometry logical should product geometry be included in the response?
#' @param dateSingle character date of format "YYYY-MM-DD", specifies a single
#'   date and will override \code{dateMin} and \code{dateMax}.
#' @param ... further arguments, none implemented.
#' @return data.frame return of the database.
#' @export

S2_query_product <- function(atmCorr      = NULL,
                             dateMax      = NULL,
                             dateMin      = NULL,
                             geometry     = NULL,
                             orbitDir     = NULL,
                             orbitNo      = NULL,
                             product      = NULL,
                             productId    = NULL,
                             retGeometry  = FALSE,
                             dateSingle   = NULL,
                             ...){


  # check inputs ---------------------------------------------------------------
  if (!is.null(orbitDir)) {
    orbitDir <- match.arg(orbitDir)
  }

  if (!is.null(dateSingle)) {
    check_date(dateSingle)
    dateMin    <- dateSingle
    dateMax    <- dateSingle
    dateSingle <- NULL
  }

  if (check_date(dateMin) > check_date(dateMax)){
    stop("'dateMin' (", dateMin, ") larger than 'dateMax' (", dateMax, ")")
  }

  # prepare json geometry ------------------------------------------------------
  if (!is.null(geometry)) geometry <- roi_to_jgeom(geometry)

  # make named query list ------------------------------------------------------
  query <- c(as.list(environment()), list(...))
  query <- query[!sapply(query, is.null)]

  # return query list ----------------------------------------------------------
  rtrn  <- S2_do_query(query = query, path = 'product')
  return(rtrn)
}

