#' Convert a region of interest to a json geometry
#'
#' @param roi a region of interest supplied as a vector/matrix of named ('x', 'y')
#'   coordinates or a SpatialPoints object or a SpatialPolygons object or a path
#'   to a file \code{\link[rgdal]{readOGR}} can open or a json geometry character string
#' @param round number of digits to round coordinates to
#' @note Coordinates are assumed to be projected (WGS-84, 4326). Spatial objects
#'   will be reprojected as necessary
#' @return character, a json geometry string
#' @export

roi_to_jgeom <- function(roi, round = Inf){

  if (is.character(roi) && file.exists(roi)) {
    roi <- normalizePath(roi)

    if (grepl('.[.][sS][hH][pP]$', roi)) {
      dsn <- sub('/[^/]+$', '', roi)
      layer <- sub('^.*/(.+)[.][sS][hH][pP]$', '\\1', roi)
      roi <- rgdal::readOGR(dsn, layer, verbose = FALSE)
    } else {
      roi <- rgdal::readOGR(roi)
    }
  }

  if ("Spatial" %in% methods::is(roi)) {
    if (!raster::compareCRS(roi, raster::raster())) {
      roi <- sp::spTransform(roi, CRSobj = raster::crs(raster::raster()))
    }
    roi_geom <- spat_to_jgeom(spat = roi, round = round)
  } else if (all(c("x", "y") %in% colnames(rbind(roi)))) {
    roi_geom <- xy_to_jgeom(xy = roi, round = round)
  } else if (length(grep("^\\{[[:print:]]*\\}$", roi)) != 0) {
    roi_geom <- roi
  } else {
    stop("'roi' not recognized!")
  }

  return(roi_geom)

}
