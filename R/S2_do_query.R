#' Send a query to 'https://s2.boku.eodc.eu'
#'
#' Query database and return response as data.frame
#'
#' @param query list of named arguments 'known' to the database. Typically
#'   created using e.g. 'S2_query_granule'
#' @param path character altering the query url with respect to the desired
#'   output. One of "product", "granule", "image", "qiData", "angle", "roi",
#'   "job", "rgb".


S2_do_query <- function(query, path){
  user     <- getOption("S2user")
  password <- getOption("S2password")
  rtrn     <- httr::GET('https://s2.boku.eodc.eu',
                         config = httr::authenticate(user, password),
                         path   = path,
                         query  = query)
  rtrn     <- jsonlite::fromJSON(httr::content(rtrn, as = 'text'))
  return(rtrn)
}


# query <- S2_query_granule(utm = "33UWP", atmCorr = 1)
# S2_do_query(query, path='granule')
