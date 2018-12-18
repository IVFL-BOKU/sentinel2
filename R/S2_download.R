#' S2_download helper function
#'
#' Simple helper function to download data (granules, images, QI data)
#'
#' @param url character (valid) url to download file from.
#' @param destfile character download destination.
#' @param skipExisting logical skip if file already exists.
#' @param zip logical if \code{TRUE}, the url will be downloaded as zip archive
#'   and (automatically) unzipped in the parent directory of 'destfile'
#'   (plays any role only when downloading granules).
#' @param progressBar should a progress bar be displayed?
#' @param ... further arguments not implemented directly - see
#'   the \href{https://s2.boku.eodc.eu/wiki/#!granule.md#GET_https://s2.boku.eodc.eu/granule/{granuleId}}{granule API doc}
#'   and the \href{https://s2.boku.eodc.eu/wiki/#!image.md#GET_https://s2.boku.eodc.eu/image/{imageId}}{image API doc}.
#' @return logical vector indicating which downloads where successful
#' @export
#' @examples
#' \dontrun{
#'   # find, download and unzip a full granule
#'   granules = S2_query_granule(
#'     utm = '33UXP',
#'     dateMin = '2016-06-01',
#'     dateMax = '2016-06-30'
#'   )
#'   S2_download(granules$url, granules$date)
#'
#'   # find and download a bunch of images
#'   images = S2_query_image(
#'     utm = '33UXP',
#'     dateMin = '2016-06-01',
#'     dateMax = '2016-06-30',
#'     band = 'B03'
#'   )
#'   S2_download(images$url, paste0(images$date, '.', images$format))
#'
#'   # reproject downloaded images by passing additional API parameter
#'   S2_download(images$url, paste0(images$date, '.', images$format), srid = 4326)
#'
#'   # download particular URL
#'   S2_download(
#'     'https://test%40s2%2Eboku%2Eeodc%2Eeu:test@s2.boku.eodc.eu/image/33148479',
#'     'test.jp2'
#'   )
#' }

S2_download = function(url, destfile, zip = TRUE, skipExisting = TRUE, progressBar = TRUE, ...){
  url = as.character(url)
  destfile = as.character(destfile)
  stopifnot(
    is.vector(url), length(url) > 0, is.vector(destfile),
    is.logical(skipExisting),
    is.vector(zip), is.logical(zip), length(zip) == 1, all(!is.na(zip)),
    is.vector(progressBar), is.logical(progressBar), length(progressBar) == 1, all(!is.na(progressBar)),
    length(url) == length(destfile)
  )
  filter = !is.na(url)
  url = url[filter]
  destfile = destfile[filter]
  stopifnot(all(!is.na(destfile)))

  addParam = list(...)
  if (zip) {
    addParam[['format']] = "application/zip"
  }
  if (length(addParam) > 0) {
    stopifnot(
      all(names(addParam) != ''),
      length(unique(names(addParam))) == length(addParam)
    )
    addParamNames = sapply(names(addParam), utils::URLencode)
    addParamValues = sapply(as.character(addParam), utils::URLencode)
    addParam = paste0(addParamNames, '=', addParamValues, collapse = '&')
    url = paste0(url, '?', addParam)
  }

  success = rep(FALSE, length(url))
  if (progressBar) {
    pb = utils::txtProgressBar(0, length(url), style = 3)
  }
  for (i in seq_along(url)) {
    if (isTRUE(skipExisting) && file.exists(destfile[i])) {
      next
    }

    if (progressBar) {
      utils::setTxtProgressBar(pb, i)
    }

    breakLoop = FALSE
    tryCatch(
      {
        curl::curl_download(url = url[i], destfile = destfile[i], quiet = TRUE)

        signature = readBin(destfile[i], 'raw', 4)
        if (all(signature == as.raw(c(80L, 75L, 3L, 4L))) & zip) {
          destfile[i] = sub('[.]zip$', '', destfile[i])
          zipfile = paste0(destfile[i], '.zip')
          file.rename(destfile[i], zipfile)
          utils::unzip(zipfile = zipfile, exdir = destfile[i])
        }

        success[i] = TRUE
      },
      warning = function(w) {
        if (all(w$message == 'Operation was aborted by an application callback')) {
          breakLoop <<- TRUE
        }
      }
    )
    if (breakLoop) {
      break
    }
  }

  return(invisible(success))
}




