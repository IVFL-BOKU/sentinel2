#' S2_granule_naming
#'
#' Creates a filename to store a downloaded 'granule', based on query response
#' for a single 'granuleId'
#' @details This function allows to alter the automatic naming behavior for
#'   downloaded granules. Useful, when it is desired to add a custom prefix /
#'   suffix or make files be easier sortable by utm zone Id instead of
#'   acquision date.
#'
#' @param x is the returned data \code{S2_query_granule} for a single 'granuleId'
#' @param order character vector representing the desired naming order. Allowed
#'   values are '"date", "utm", "orbit", "granuleId", "productId", "cloudCov",
#'   "atmCorr"'. If an element in 'order' is named, the name of the element is used
#'   as prefix for its value (without any separator). (The 'time' portion of 'date'
#'   will be truncated to avoid spaces and colons in the filename.)
#' @param prefix character 'GRANULE' by default
#' @param suffix character by default turns to 'L1C', if '\code{atmCorr = 0.0}'.
#'  If '\code{atmCorr != 0.0}' in x, 'suffix' will become 'L2A'.
#' @return character name


S2_granule_naming <- function(x,
                              order  = c("date", "utm", "orbit", Id="granuleId"),
                              prefix = "GRANULE",
                              suffix = ifelse(as.numeric(x$atmCorr) == 0, "L1C", "L2A")){

  # check for unknown properties -----------------------------------------------
  allowed <- c("date", "utm", "orbit", "granuleId",
               "productId", "cloudCov", "atmCorr")

  if (!all(order %in% allowed)){
    stop("Invalid 'granule' naming. Allowed elements in 'order' are:\n'",
         paste(allowed, collapse= ", "))
  }

  # remove 'time' from 'date' --------------------------------------------------
  if ("date" %in% order) x$date <- format_date(x$date)

  # bind names to order elements -----------------------------------------------
  for (i in seq_along(order)){
    order[i] <- paste0(names(order)[i], x[order[i]])
  }

  # paste together and output name ---------------------------------------------
  paste(c(prefix, order, suffix), collapse="_")

}
