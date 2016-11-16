#' Prepare a list to query database for 'image'
#'
#' Implements the query options for 'images' described in the wiki.
#'
#' @param atmCorr  logical if TRUE only results for atmospherically corrected
#'   data are returned.
#' @param broken logical, TRUE if the granule is marked as broken
#'   (almost for sure you want to use FALSE, the default).
#' @param band chracter spectral band: B01/B02/B03/B04/B05/B06/B07/B08/B8A/B09/
#'   B10/B11/B12/all/SCL/LAI/albedo - see sentinel2 documentation.
#' @param cloudCovMin integer minimum cloud coverage from 0 to 100.
#' @param cloudCovMax integer maximum cloud coverage from 0 to 100.
#' @param dateMax character end date of format "YYYY-MM-DD".
#' @param dateMin character start date of format "YYYY-MM-DD".
#' @param geometry geometry which should intersect with granules. Can be a
#'   geoJSON geometry string (e.g. {"type":"Point","coordinates":[16.5,48.5]}),
#'   the path to a Point/Polygon shapefile, a SpatialPoints object or a
#'   SpatialPolygons object.
#' @param granule character ESA granule id.
#' @param granuleId integer internal metadata database granule id.
#' @param imageId integer internal metadata database image id.
#' @param orbitNo integer from 1 to 143.
#' @param product chracter ESA product id.
#' @param productId integer internal metadata database product id.
#' @param resolution integer spatial resolution [m]: 60/20/10
#'   (resolution depends on the spectral band).
#' @param retGeometry logical should product geometry be included in the response?
#' @param utm character UTM zone, e.g. 33U, 01C.
#' @param dateSingle character date of format "YYYY-MM-DD", specifies a single
#'   date and will override \code{dateMin} and \code{dateMax}.
#' @param ... further arguments, none implemented.
#' @return data.frame return of the database.
#' @export

S2_query_image <- function(atmCorr      = NULL,
                           band         = NULL,
                           broken       = FALSE,
                           cloudCovMin  = 0,
                           cloudCovMax  = 100,
                           dateMax      = Sys.Date(),
                           dateMin      = as.Date(dateMax) - 365,
                           geometry     = NULL,
                           granule      = NULL,
                           granuleId    = NULL,
                           imageId      = NULL,
                           orbitNo      = NULL,
                           product      = NULL,
                           productId    = NULL,
                           resolution   = NULL,
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
  rtrn  <- S2_do_query(query = query, path = 'image')
  return(rtrn)
}

