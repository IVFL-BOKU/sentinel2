#' Reformats date
#'
#' Simplifies the 'date' from 'YYYY-MM-DD HH:MM:SS' to 'YYYYMMDD' for filenaming
#'
#' @param x a character string representing date/time as 'YYYY-MM-DD HH:MM:SS'
#' @return character of format 'YYYYMMDD'


format_date <- function(x){
  x <- strptime(x = x, format = "%Y-%m-%d %T")
  x <- format(x, format = "%Y-%m-%d")
  return(as.character(x))
}
