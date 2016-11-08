#' Buy a granule at 'https://s2.boku.eodc.eu'
#'
#' Buy granule using granuleId
#'
#' @param granuleId character the granuleId
#' @export


S2_buy_granule <- function(granuleId){
  user     <- getOption("S2user")
  password <- getOption("S2password")
  rtrn     <- httr::PUT('https://s2.boku.eodc.eu',
                        config = httr::authenticate(user, password),
                        path   = list('granule', granuleId))
  jsonlite::fromJSON(httr::content(rtrn, as = 'text'))
  return(invisible(rtrn))
}

