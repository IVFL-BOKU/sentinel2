#' S2_download helper function
#'
#' Simple helper function to zip download and unzip i.e. a 'granule' in a single
#'   step
#'
#' @param url character (valid) url to download file from.
#' @param destfile character download destination. If \code{zip = TRUE}, the
#'   ending '.zip' will be attached to destfile (, if it is not already).
#' @param zip logical if \code{TRUE}, the url will be downloaded as zip archive
#'   and (automatically) unzipped in the parent directory of 'destfile'
#' @return NULL

S2_download <- function(url, destfile, zip = TRUE){

  if (isTRUE(zip)){
    url <- paste0(url, "?format=application/zip")
    if (!grepl("[.]zip$", destfile)) destfile <- paste0(destfile, ".zip")
  }

  curl::curl_download(url = url, destfile = destfile, quiet = TRUE)

  if (isTRUE(zip)) unzip(zipfile = destfile, exdir = dirname(destfile))

  return(invisible(NULL))
}




