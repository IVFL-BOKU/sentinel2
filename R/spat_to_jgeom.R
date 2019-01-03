#' Convert any sp package geometry to a json geometry
#'
#' @note Objects consisting of many one feature are covnerted to GeoJSON
#' Polygons while objects consisting of many features to MultiPolygons.
#'
#' @param spat an sp package spatial object or list of sp package spatial
#'   objects
#' @return vector of corresponding JSON geometries
spat_to_jgeom = function(spat){
  if (!is.list(spat)) {
    spat = list(spat)
  }

  tmpFile = tempfile()
  on.exit({
    unlink(tmpFile)
  })

  rtrn = character(length(spat))
  for (i in seq_along(spat)) {
    rgdal::writeOGR(spat[[i]], tmpFile, '', driver = 'GeoJSON', verbose = FALSE)
    features = jsonlite::fromJSON(readLines(tmpFile), simplifyDataFrame = FALSE)$features
    if (length('features') == 1) {
      rtrn[i] = jsonlite::toJSON(features[[1]]$geometry, auto_unbox = TRUE)
    } else {

    }
  }
  return(rtrn)
}
