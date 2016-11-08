#' Function used to set 'user' and 'password' login credentials for the current
#'   R session
#'
#' S2_initialize_user stores 'user' and 'password' usign \code{options()}.
#'  Functions in package 'S2boku' (that require authentication) will retrieve
#'  the credentials using 'getOption()'. This will avoid passing login
#'  credentials multiple times in a single session and allows the user
#'  for permanent configuration in '.Rprofile'.
#'
#' @note Requires a valid registration to 'https://s2.boku.eodc.eu' to gain
#'    access to database functionality where authentication is mandatory.
#' @param user character user login you have registered with at
#'   'https://s2.boku.eodc.eu'
#' @param password character password for 'https://s2.boku.eodc.eu'
#' @export

S2_initialize_user <- function(user = "default@foo.bar", password = "default"){
  options("S2user" = user)
  options("S2password" = password)
}
