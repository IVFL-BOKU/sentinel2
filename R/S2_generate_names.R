#' S2_granule_naming
#'
#' Creates a filename to store a downloaded 'granule', based on query response
#' for a single 'granuleId'
#' @details This function allows to alter the automatic naming behavior for
#'   downloaded granules. Useful, when it is desired to add a custom prefix /
#'   suffix or make files be easier sortable by utm zone Id instead of
#'   acquision date.
#'
#' @param x is the returned data \code{S2_query_granule} or \code{S2_query_image}
#' @param ... arguments passed to S2_naming()
#' @return character names
#' @export


S2_generate_names <- function(x, ...){

  g_cols  <- c("granuleId", "productId", "product", "granule", "date", "processDate",
               "utm", "orbit", "cloudCov", "atmCorr", "broken", "url")

  i_cols  <- c("imageId", "productId", "granuleId", "product", "granule",
               "utm", "orbit", "band", "resolution", "cloudCov", "atmCorr",
               "date", "format", "processDate", "url")

  if (all(colnames(x) %in% g_cols)){

    rtrn  <- S2_naming(x,
                       prefix = "GRANULE",
                       order  = list("date", "utm", "orbit", Id="granuleId"),
                       ...)
    return(rtrn)

  } else if (all(colnames(x) %in% i_cols)){

    rtrn  <- S2_naming(x,
                       prefix = "IMAGE",
                       order  = list("date", "utm", "orbit", "band", "resolution", Id="imageId"),
                       extension = paste0(".", x$format),
                       ...)
    return(rtrn)

  }

}

