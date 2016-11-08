#' Convert xy coordinates to json geometry
#'
#' Turn a xy coordinates vector (1 point) or matrix (multiple points) into a
#'   json geometry string
#' @note Elements of vector/columns of matrix must be named 'x' and 'y'
#' @param xy named vector matrix of 'x' and 'y' coordinates assumed to be projected
#'   (4326, WGS-84)
#' @param round number of digits to round coordinates to
#' @return a json geometry string of type 'Point', if only one xy pair is
#'  supplied, of type 'Polygon' otherwise
#'

xy_to_jgeom <- function(xy, round = Inf){

  poi_xy <- data.frame(rbind(xy))

  stopifnot(all(c("x", "y") %in% colnames(poi_xy)))

  if (nrow(poi_xy) == 1){

    poi_xy <- data.frame(round(poi_xy, round))
    g_type <- "Point"
    poi_xy <- with(poi_xy, paste(x, y, sep = ","))

  } else if (nrow(poi_xy) > 1){

    g_type <- "Polygon"

    poi_xy <- data.frame(apply(round(poi_xy, round), 2, as.character))
    poi_xy <- with(poi_xy, paste(sprintf("[%s,%s]", x, y), collapse=","))
    poi_xy <- sprintf("[%s]", poi_xy)

  }

  rtrn <- sprintf('{"type":"%s","coordinates":[%s]}', g_type, poi_xy)
  return(rtrn)

}
