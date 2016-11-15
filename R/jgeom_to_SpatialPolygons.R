#' Converts json geometry to SpatialPolygons
#'
#' Turn a json geometry as returned by a database query using 'retGeometry = 1'
#'   into a SpatialPolygons object
#'
#' @note The geometry is first replaced by its convex hull for simplification!
#' @param x character json geometry as returned by a database query with
#'   'retGeometry = 1'
#' @return SpatialPolygons object of the geometry supplied via x


jgeom_to_SpatialPolygons <- function(x){
  rtrn <- vector(mode = "list", length = length(x))
  for (i in seq_along(x)){
    ptrn <- "\\[-?[0-9]+[.]?[0-9]*,-?[0-9]+[.]?[0-9]*\\]"
    y    <- unlist(strsplit(x[i], split = '"coordinates":'))[2]
    y    <- unlist(regmatches(y, m = gregexpr(pattern = ptrn, text = y)))
    y    <- substr(y, start = 2, stop = nchar(y) - 1)
    y    <- strsplit(y, split = ",")
    y    <- do.call(rbind, y)
    y    <- apply(y, 2, as.numeric)
    hull <- grDevices::chull(y)
    y    <- y[c(hull, hull[1]), ]
    y    <- sp::Polygon(y)
    y    <- sp::Polygons(list(y), ID=1)
    y    <- sp::SpatialPolygons(list(y), proj4string = raster::crs(raster::raster()))

    rtrn[[i]] <- y
  }
  if (length(rtrn) == 1){
    rtrn <- unlist(rtrn)
  } else {
    rtrn <- do.call(raster::bind, rtrn)
  }

  return(rtrn)
}
