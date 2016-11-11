#' Check user supplied date string
#'
#' Will check if date string is well formated and throw and error if not
#'
#' @param x a character string expected to have format 'YYYY-MM-DD'
#' @return NULL if x has a valid date of format 'YYYY-MM-DD'

check_date <- function(x){
  if (is.na(strptime(x, format = "%Y-%m-%d"))){
    stop("Invalid date '", x, "', please use 'YYYY-MM-DD' format!")
  } else {
    return(invisible(NULL))
  }
}
