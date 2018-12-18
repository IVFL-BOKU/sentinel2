#' Query database for 'job'
#'
#' Implements the query options for 'job' described in the wiki.
#' @param dateMax character end date of format "YYYY-MM-DD".
#' @param dateMin character start date of format "YYYY-MM-DD".
#' @param started logical, TRUE if job has started.
#' @param ended logical, TRUE if job has ended.
#' @param failed logical, TRUE if job has failed.
#' @param geometry geometry which should intersect with granules. Can be a
#'   geoJSON geometry string (e.g. {"type":"Point","coordinates":[16.5,48.5]}),
#'   the path to a Point/Polygon shapefile, a SpatialPoints object or a
#'   SpatialPolygons object.
#' @param jobId character internal metadata database job id.
#' @param granule character ESA granule id.
#' @param granuleId integer internal metadata database granule id.
#' @param product chracter ESA product id.
#' @param productId integer internal metadata database product id.
#' @param regionId region of interest id (overrides the \code{geometry} parameter,
#'   if \code{dateMin} or \code{dateMax} are not specified, they are taken from the region of interest settings)
#' @param retGeometry logical should product geometry be included in the response?
#' @param dateSingle character date of format "YYYY-MM-DD", specifies a single
#'   date and will override \code{dateMin} and \code{dateMax}.
#' @param ... further arguments, none implemented.
#' @return data.frame return of the database.
#' @export

S2_query_job = function(
  dateMax      = NULL,
  dateMin      = NULL,
  started      = NULL,
  ended        = NULL,
  failed       = NULL,
  geometry     = NULL,
  jobId        = NULL,
  granule      = NULL,
  granuleId    = NULL,
  product      = NULL,
  productId    = NULL,
  regionId     = NULL,
  retGeometry  = FALSE,
  dateSingle   = NULL,
  ...
){
  # check inputs ---------------------------------------------------------------
  if (!is.null(dateSingle)) {
    check_date(dateSingle)
    dateMin    = dateSingle
    dateMax    = dateSingle
    dateSingle = NULL
  }

  if (!is.null(dateMin) && !is.null(dateMax) && check_date(dateMin) > check_date(dateMax)) {
    stop("'dateMin' (", dateMin, ") larger than 'dateMax' (", dateMax, ")")
  }

  # prepare json geometry ------------------------------------------------------
  if (!is.null(geometry)) geometry = roi_to_jgeom(geometry)

  # make named query list ------------------------------------------------------
  query = c(as.list(environment()), list(...))
  query = query[!sapply(query, is.null)]

  # return query list ----------------------------------------------------------
  rtrn  = S2_do_query(query = query, path = 'job')
  if (nrow(rtrn) == 0) {
    rtrn$jobId = integer()
  }
  return(rtrn)
}

