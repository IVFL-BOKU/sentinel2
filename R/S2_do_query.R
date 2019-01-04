#' Send a query to 'https://s2.boku.eodc.eu'
#'
#' Query database and return response as data.frame
#'
#' @param query list of named arguments 'known' to the database. Typically
#'   created using e.g. 'S2_query_granule'
#' @param path name of the rest API endpoint like "product", "granule", "image",
#'   "qiData", "angle", "roi", "job" or "rgb".
#' @param baseUrl base REST API URL
S2_do_query = function(query, path, baseUrl = 'https://s2.boku.eodc.eu'){
  credentials = get_credentials()

  filter        = sapply(query, is.logical)
  query[filter] = as.numeric(query[filter])

  rtrn = httr::GET(
    baseUrl,
    config = httr::authenticate(credentials['user'], credentials['password']),
    path   = path,
    query  = query
  )
  if (!httr::status_code(rtrn) %in% c(200, 204)) {
    stop(
      httr::modify_url(baseUrl, path = path, query = query),
      ' failed with code ', httr::status_code(rtrn)
    )
  }
  rtrn = tryCatch(
    as.data.frame(jsonlite::fromJSON(httr::content(rtrn, as = 'text'))),
    error = function(e) {
      stop(
        'failed to parse as JOSN results of ',
        httr::modify_url(baseUrl, path = path, query = query)
      )
    }
  )

  return(rtrn)
}

