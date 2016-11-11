#' Buy check
#'
#' Checks, if granule's are already available or need to be bought
#'
#' @param granuleId a character vector of one or more granuleId's
#' @return logical of the same length as granuleId, where \code{TRUE} means a
#'   granule needs to be bougth to gain access


buy_check <- function(granuleId){

  to_buy <- rep(FALSE, length(granuleId))

  for (i in seq_along(granuleId)){
    to_buy[i] <- is.na(S2_query_granule(granuleId = granuleId[i])['url'])
  }

  names(to_buy) <- granuleId
  return(to_buy)
}
