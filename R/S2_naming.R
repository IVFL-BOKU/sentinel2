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
#' @param order character vector representing the desired naming order. Allowed
#'   values are '"date", "utm", "orbit", "granuleId", "productId", "cloudCov",
#'   "atmCorr", "resolution", "band"'.
#'   If an element in 'order' is named, the name of the element is used
#'   as prefix for its value (without any separator). (The 'time' portion of 'date'
#'   will be truncated to avoid spaces and colons in the filename.)
#' @param prefix character 'GRANULE' by default
#' @param suffix character by default turns to 'L1C', if '\code{atmCorr = 0.0}'.
#'  If '\code{atmCorr != 0.0}' in x, 'suffix' will become 'L2A'.
#' @param extension character optional filename extension
#' @return character name


S2_naming <- function(x,
                      order  = list("date", "utm", "orbit", Id="granuleId"),
                      prefix = "GRANULE",
                      suffix = ifelse(as.numeric(x$atmCorr) == 0, "L1C", "L2A"),
                      extension = NULL){



  # remove 'time' from 'date' --------------------------------------------------
  if ("date" %in% order) x$date <- format_date(x$date)

  # add 'm' to resolution
  if ("resolution" %in% order) x$resolution <- paste0(x$resolution, "m")

  # bind names to order elements -----------------------------------------------
  rtrn <- vector(mode = 'list', length = length(order))

  for (i in seq_along(order)){
    rtrn[[i]] <- paste0(rep(names(order)[i], length(x[order[[i]]])), unlist(x[order[[i]]]))
  }

  # paste together and output name ---------------------------------------------
  rtrn <- do.call(cbind, c(list(prefix), rtrn, list(suffix)))
  rtrn <- apply(rtrn, 1, paste, collapse="_")
  rtrn <- paste0(rtrn, extension)
  return(rtrn)

}
