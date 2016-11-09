#' Convert SpatialPoints/PatialPolygons to json geometry
#'
#' Turn a SpatialPoints/PatialPolygons object into a json geometry string
#'
#' @param spat a spatial object of class SpatialPolygons or SpatialPoints
#' @param round number of digits to round coordinates to
#' @return list of json geometries, where length of the list is the number of
#'  points or polygons in spat
#'

spat_to_jgeom <- function(spat, round = Inf){

  rtrn <- vector(mode = 'list', length = length(spat))

  for (i in seq_along(spat)){

    poi_xy <- raster::geom(spat[i, ])[, c("x", "y"), drop = FALSE]

    if (nrow(poi_xy) == 1 && "SpatialPoints" %in% methods::is(spat)){

      poi_xy <- data.frame(round(poi_xy, round))
      g_type <- "Point"
      poi_xy <- with(poi_xy, paste(x, y, sep = ","))

    } else if (nrow(poi_xy) > 1){

      g_type <- "Polygon"

      poi_xy <- data.frame(apply(round(poi_xy, round), 2, as.character))
      poi_xy <- with(poi_xy, paste(sprintf("[%s,%s]", x, y), collapse=","))
      poi_xy <- sprintf("[%s]", poi_xy)
    }

    rtrn[[i]] <- sprintf('{"type":"%s","coordinates":[%s]}',
                         g_type, poi_xy)
  }
  return(rtrn)
}
