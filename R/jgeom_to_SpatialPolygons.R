#' Converts json geometry to SpatialPolygons
#'
#' Turn a json geometry as returned by a database query using 'retGeometry = 1'
#'   into a SpatialPolygons object
#'
#' @note The geometry is first replaced by its convex hull for simplification!
#' @param x character json geometry as returned by a database query with
#'   'retGeometry = 1'
#' @param utm two-digit utm zone used for an optional reprojection
#' @return SpatialPolygons object of the geometry supplied via x

jgeom_to_SpatialPolygons <- function(x, utm=NULL){
  # require(raster)
  # require(sp)
  y    <- unlist(strsplit(x, split = '"coordinates":'))

  stopifnot(grepl(pattern = "MultiPolygon|Polygon", y[[1]]))
  y0    <- y[[2]]

  y0    <- gsub("}", "", y0)
  y0    <- gsub("\\[{4,}", "[[[", y0)
  y0    <- gsub("\\]{4,}", "]]]", y0)
  y0    <- gsub("[[:space:]]", "", y0)
  y0    <- gsub("\\]{3},\\[{3}", "]]] [[[", y0)
  y0    <- unlist(strsplit(y0, split = " "))


  rtrn  <- vector(mode = 'list', length = length(y0))
  for (ii in seq_along(y0)){
    y1    <- unlist(strsplit(y0[ii], split = "]]"))
    y1    <- strsplit(x = y1, split = "\\]|\\[|,")
    empty1 <- logical(length(y1))
    for(i in seq_along(y1)){

      y_ <- matrix(stats::na.omit(as.numeric(y1[[i]])), ncol = 2, byrow = TRUE)
      if(nrow(y_) == 0){
        empty1[i] <- TRUE
      } else if (i == 1){
        y1[[i]] <- sp::Polygon(y_, hole = FALSE)
      } else {
        y1[[i]] <- sp::Polygon(y_, hole = TRUE)
      }
    }
    y1         <- y1[!empty1]
    rtrn[[ii]] <- sp::Polygons(y1, ID = ii)

  }
  rtrn <- sp::SpatialPolygons(rtrn, proj4string = raster::crs(raster::raster()))

  if (!is.null(utm)){

    epsg0 <- sprintf("+init=epsg:32%s%s",
                     ifelse(sp::coordinates(rtrn)[2] < 0, 7, 6),
                     substring(utm, first = 1, last = 2))
    rtrn <- sp::spTransform(rtrn, CRSobj = sp::CRS(epsg0))

  }
  return(rtrn)
}

# jgeom_to_SpatialPolygons <- function(x){
#   rtrn <- vector(mode = "list", length = length(x))
#   for (i in seq_along(x)){
#     ptrn <- "\\[-?[0-9]+[.]?[0-9]*,-?[0-9]+[.]?[0-9]*\\]"
#     y    <- unlist(strsplit(x[i], split = '"coordinates":'))[2]
#     y    <- unlist(regmatches(y, m = gregexpr(pattern = ptrn, text = y)))
#     y    <- substr(y, start = 2, stop = nchar(y) - 1)
#     y    <- strsplit(y, split = ",")
#     y    <- do.call(rbind, y)
#     y    <- apply(y, 2, as.numeric)
#     hull <- grDevices::chull(y)
#     y    <- y[c(hull, hull[1]), ]
#     y    <- sp::Polygon(y)
#     y    <- sp::Polygons(list(y), ID=i)
#
#     rtrn[[i]] <- y
#   }
#   rtrn    <- sp::SpatialPolygons(rtrn, proj4string = raster::crs(raster::raster()))
#
#   return(rtrn)
# }
