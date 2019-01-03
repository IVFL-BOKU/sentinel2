cfgUser = 'test@s2.boku.eodc.eu'
cfgPswd = 'test'

#' Set login credentials for 's2.boku.eodc.eu'
#'
#' Set 'user' and 'password' login credentials for the current
#'   R session
#'
#' \code{S2_initialize_user} remembers user credentials allowing other package
#' functions to retrieve them when needed.
#'
#' @note Requires a valid registration to 'https://s2.boku.eodc.eu' to gain
#'    access to database functionality where authentication is mandatory.
#' @param user character user login you have registered with at
#'   'https://s2.boku.eodc.eu'
#' @param password character password for 'https://s2.boku.eodc.eu'
#' @export
S2_initialize_user = function(user, password, permanent = TRUE) {
  cfgUser <<- user
  cfgPswd <<- password
}

#' Internal function getting user credentials
#'
get_credentials = function() {
  return(c(user = cfgUser, password = cfgPswd))
}
