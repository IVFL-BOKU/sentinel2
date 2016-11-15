#' Generate RGB image and download
#'
#' Generates 8-bit/channel composite image (see 'https://s2.boku.eodc.eu/wiki/'
#'   for details)
#'
#' @param granuleId integer the granuleId for which to create the RGB composite
#' @param destfile character path to the output file. If destfile is a path to
#'   an existing directory, a filename will be automatically generated. If NULL,
#'   the file will be saved to the current working directory. If a filename is
#'   supplied, it will have to have a '.tif' extension.
#' @param resolution integer desired (minimum) resolution, typically 10, 20 or 60.
#' @param atmCorr 0 (default) or 1, if atmospherically corrected bands should be
#'   used
#' @param r character red band, e.g. "B08"
#' @param g character green band, e.g. "B04"
#' @param b character blue band, e.g. "B03"
#' @param ra see wiki
#' @param ga see wiki
#' @param ba see wiki
#' @param rb see wiki
#' @param gb see wiki
#' @param bb see wiki
#' @param overwrite logical, should existing files be overwritten?
#' @return NULL
#' @export

S2_generate_RGB <- function(granuleId,
                            destfile = NULL,
                            resolution = 10,
                            atmCorr = 0,
                            r = "B08",
                            g = "B04",
                            b = "B03",
                            ra = 20,
                            ga = 20,
                            ba = 20,
                            rb = 20,
                            gb = 20,
                            bb = 20,
                            overwrite = FALSE){

  query <- S2_query_image(granuleId = granuleId, atmCorr = atmCorr)
  # query <- S2_do_query(query, path = "image")

  if (length(query) == 0 && atmCorr == 0){

    warning("Unable to process 'granuleId ", granuleId, "'. Not found in database!")
    return(invisible(NULL))

  } else if (length(query) == 0 && atmCorr == 1){

    warning("Unable to process 'granuleId ", granuleId, "'. Maybe its not (yet) ",
         "atmospherically corrected!\n")
    return(invisible(NULL))

  }

  imageIds <- integer(3)
  for (i in seq_len(3)){
    # sel           <- query[query$band == c(r, g, b)[i] & query$resolution <= resolution, , drop=FALSE]
    sel           <- query[query$band == c(r, g, b)[i], , drop=FALSE]
    sel           <- sel[order(sel$resolution)[1], , drop=FALSE]

    if (is.na(sel$url)){
      warning("Access to image denied. You seem to lack permission to download file!")
      return(invisible(NULL))
    }

    imageIds[i]   <- sel[, "imageId"]
  }

  query <- list(r = imageIds[1],
                g = imageIds[2],
                b = imageIds[3],
                ra = ra,
                ga = ga,
                ba = ba,
                rb = rb,
                gb = gb,
                bb = bb)

  user     <- getOption("S2user")
  password <- getOption("S2password")
  rtrn     <- httr::modify_url('https://s2.boku.eodc.eu',
                               username = utils::URLencode(user, reserved = TRUE),
                               password = utils::URLencode(password, reserved = TRUE),
                               path     = "rgb",
                               query    = query)


  if (is.null(destfile)){
    destfile <- sprintf("granuleId_%s_r_%s_g_%s_b_%s_atmCorr_%s.tif",
                        granuleId, r, g, b, atmCorr)
  }

  if (dir.exists(destfile)){
    destfile <- sprintf("%s/granuleId_%s_r_%s_g_%s_b_%s_atmCorr_%s.tif",
                        destfile, granuleId, r, g, b, atmCorr)
  }

  if (file.exists(destfile) && !isTRUE(overwrite)){
    warning(destfile, " already exists! Use 'overwrite = TRUE' to overwrite")
    return(invisible(NULL))
  }

  curl::curl_download(url = rtrn, destfile = destfile)
  return(invisible(NULL))
}


