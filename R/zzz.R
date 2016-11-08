#' .onLoad setup credentials
#'
#' Setup login credentials on package start, if not retrieved already (e.g. from
#'  .Rprofile).

.onLoad <- function(libname, pkgname){
  if (is.null(getOption("S2user")))     options("S2user" = "default")
  if (is.null(getOption("S2password"))) options("S2password" = "default")
}
