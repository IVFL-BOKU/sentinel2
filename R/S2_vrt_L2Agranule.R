#' Create a virtual raster from a (Level 2A) Sentinel-2 Granule
#'
#' Creates a '.vrt' raster from a granule directory
#' @note Requires a valid 'GDAL' install (and properly configured '$PATH' variable).
#'   Suppose a granule is complete (containing L2A files at 10m, 20m and 60m resolution),
#'   the resulting '.vrt' stack will contain bands in the following order:
#'   B01 (60m), B02 (10m), B03 (10m), B04 (10m), B05 (20m), B06 (20m), B07 (20m),
#'   B08 (10m), B09 (60m), B11 (20m) and B12 (20m).
#'   For details, please consult the ESA Sentinel-2 product specifications documentation.
#' @param granule character path to a 'granule'
#' @param verbose logical if \code{TRUE} show warnings
#' @return NULL, side effect of creating a '.vrt' file.


S2_vrt_L2Agranule <- function(granule, verbose = FALSE){
  if (nchar(Sys.which("gdalbuildvrt")) == 0){

    if (isTRUE(verbose)){
      warning("Unable to find 'gdalbuildvrt' -> virtual raster creation skipped!")
    }
    return(invisible(NULL))

  } else {

    jp2_10m <- list.files(granule, pattern = "_B[0-9]{2}_10m.jp2$",
                          recursive = TRUE, full.names = TRUE)
    jp2_20m <- list.files(granule, pattern = "_B[0-9]{2}_20m.jp2$",
                          recursive = TRUE, full.names = TRUE)
    jp2_60m <- list.files(granule, pattern = "_B[0-9]{2}_60m.jp2$",
                          recursive = TRUE, full.names = TRUE)


    bnd_10m <- regmatches(jp2_10m, m = regexpr(pattern = "_B[0-9]{2}_", jp2_10m))
    bnd_20m <- regmatches(jp2_20m, m = regexpr(pattern = "_B[0-9]{2}_", jp2_20m))
    bnd_60m <- regmatches(jp2_60m, m = regexpr(pattern = "_B[0-9]{2}_", jp2_60m))

    bnd_stk <- c(jp2_10m,
                 jp2_20m[!bnd_20m %in% bnd_10m],
                 jp2_60m[!bnd_60m %in% c(bnd_10m, bnd_20m)])

    # create the virtual raster ----------------------------------------------
    bnd_stk <- bnd_stk[order(basename(bnd_stk))]

    system(sprintf('gdalbuildvrt -resolution "highest" -separate %s.vrt %s',
                   file.path(granule, basename(granule)),
                   paste(bnd_stk, sep = " ", collapse = " "), sep = " "))

  }
  return(invisible(NULL))
}
