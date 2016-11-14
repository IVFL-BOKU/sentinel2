#' Convert SpatialPoints/PatialPolygons to json geometry
#'
#' Turn a SpatialPoints/PatialPolygons object into a json geometry string
#'
#' @param spat a spatial object of class SpatialPolygons or SpatialPoints
#' @param round number of digits to round coordinates to
#' @return character string, a single json geometry
#'

spat_to_jgeom <- function(spat, round = Inf){

  rtrn <- vector(mode = 'list', length = length(spat))

  if (any(grepl("SpatialPolygon", class(spat)))){
    g_type <- "MultiPolygon"
  } else if (any(grepl("SpatialPoints", class(spat)))){
    g_type <- "MultiPoint"
  }

  for (i in seq_along(spat)){

    poi_xy <- raster::geom(spat[i, ])[, c("x", "y"), drop = FALSE]

    if (g_type == "MultiPoint"){

      poi_xy <- data.frame(round(poi_xy, round))
      poi_xy <- with(poi_xy, paste(x, y, sep = ","))
      poi_xy <- sprintf("[%s]", poi_xy)

    } else if (g_type == "MultiPolygon"){

      poi_xy <- data.frame(apply(round(poi_xy, round), 2, as.character))
      poi_xy <- with(poi_xy, paste(sprintf("[%s,%s]", x, y), collapse=","))
      poi_xy <- sprintf("[[%s]]", poi_xy)
    }

    rtrn[[i]] <- poi_xy

  }

  rtrn <- paste(unlist(rtrn), collapse=",")
  rtrn <- sprintf('{"type":"%s","coordinates":[%s]}', g_type, rtrn)
  return(rtrn)
}


