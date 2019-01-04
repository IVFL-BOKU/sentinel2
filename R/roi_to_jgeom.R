#' Convert a region of interest to a json geometry
#'
#' @param roi a region of interest supplied as a vector/matrix of named ('x',
#'   'y') coordinates or any sp package spatial
#'   object or a path to a file \code{\link[rgdal]{readOGR}} can open or a json
#'   geometry character string
#' @param projection sp's package CRS object providing points projection.
#'   Applicable only when the \code{roi} parameter is a vector/matrix of
#'   coordinates
#' @note Coordinates are assumed to be projected (WGS-84, 4326). Spatial objects
#'   will be reprojected as necessary
#' @return character, a json geometry string
#' @export
roi_to_jgeom = function(roi, projection = sp::CRS('+init=epsg:4326')){
  if (is.character(roi) && file.exists(roi)) {
    roi = gsub(pattern = '[\\]', replacement = '/', roi)

    if (grepl('.[.][sS][hH][pP]$', roi)) {
      dsn = sub('/[^/]+$', '', roi)
      layer = sub('^.*/(.+)[.][sS][hH][pP]$', '\\1', roi)
      roi = rgdal::readOGR(dsn, layer, verbose = FALSE)
    } else {
      roi = rgdal::readOGR(roi, verbose = FALSE)
    }
  } else if (is.character(roi)) {
    roi = rgdal::readOGR(roi, 'OGRGeoJSON', verbose = FALSE)
  } else if (all(c("x", "y") %in% colnames(rbind(roi)))) {
    if (is.vector(roi)) {
      roi = matrix(roi, ncol = 2, byrow = TRUE)
    }
    roi = sp::SpatialPointsDataFrame(roi, data.frame(id = seq_along(roi[, 1])), proj4string = projection)
  }

  if (is.na(sp::proj4string(roi))) {
    sp::proj4string(roi) = sp::CRS('+init=epsg:4326')
  }
  roi = sp::spTransform(roi, CRSobj = sp::CRS('+init=epsg:4326'))
  roi_geom = spat_to_jgeom(spat = roi)

  return(roi_geom)
}
