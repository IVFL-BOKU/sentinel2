#' Set login credentials for 's2.boku.eodc.eu'
#'
#' Set 'user' and 'password' login credentials for the current
#'   R session
#'
#' \code{S2_initialize_user} store 'user' and 'password' in \code{options}.
#'  If needed, functions in package 'sentinel2' will retrieve the credentials
#'  using 'getOption()'. This will avoid passing login credentials multiple
#'  times in a single session and allows users to permanentely configure their
#'  login in a '.Rprofile' file.
#'
#' @note Requires a valid registration to 'https://s2.boku.eodc.eu' to gain
#'    access to database functionality where authentication is mandatory.
#' @param user character user login you have registered with at
#'   'https://s2.boku.eodc.eu'
#' @param password character password for 'https://s2.boku.eodc.eu'
#' @export

S2_initialize_user <- function(user = "test@s2.boku.eodc.eu", password = "test"){
  options("S2user" = user)
  options("S2password" = password)
}
