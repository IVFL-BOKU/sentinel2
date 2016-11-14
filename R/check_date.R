#' Check user supplied date string
#'
#' Will check if date string is well formated and throw an error if not
#'
#' @param x a character string expected to have format 'YYYY-MM-DD'
#' @return object of class 'POSIXlt POSIXt', if x has a valid date of format
#' 'YYYY-MM-DD', otherwise an error is thrown

check_date <- function(x){
  rtrn <- strptime(x, format = "%Y-%m-%d")
  if (is.na(rtrn) | !grepl("^[0-9]{4}-[0-9]{2}-[0-9]{2}$", x)){
    stop("Invalid date '", x, "', please use 'YYYY-MM-DD' format!")
  } else {
    return(invisible(rtrn))
  }
}



