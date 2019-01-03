#' Converts a geoJSON string into spatial objects used by R packages
#' @param geojson character vector of geoJSON objects
#' @param package name of an R package to to the format used by which
#'   \code{geojson} geometries should be coverted. Currently \code{sp} and
#'   \code{sf} packages are supported
#' @return a list of spatial objects
geojson_to_geometry = function(geojson, package) {
  stopifnot(
    is.vector(geojson), is.character(geojson), all(!is.na(geojson)),
    is.vector(package), is.character(package), length(package) == 1, all(!is.na(package))
  )
  geometry = vector('list', length(geojson))
  if (package == 'sp') {
    for (i in seq_along(geojson)) {
      geometry[[i]] = rgdal::readOGR(geojson[i], 'OGRGeoJSON', verbose = FALSE)
    }
  } else if (package == 'sf') {
    for (i in seq_along(geojson)) {
      geometry[[i]] = sf::read_sf(geojson[i])
    }
  } else {
    stop('do not know how to convert to the ', package, ' package spatial object')
  }
  return(geometry)
}
