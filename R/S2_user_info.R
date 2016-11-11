#' S2_user_info
#'
#' Returns information on a users coins budget
#'
#' @return list where 'userId' is the Id of the current user, 'coins' is the
#'   total number of coins acquired by the user, 'coinsUsed' the number of coins
#'   used so far and 'coinsRemain' the number of coins available to acquire
#'   database products
#' @export

S2_user_info <- function(){
  user     <- getOption("S2user")
  password <- getOption("S2password")
  srvrsp   <- httr::GET('https://s2.boku.eodc.eu/user/current',
                        config = httr::authenticate(user, password))

  srvrsp             <- httr::content(srvrsp)
  srvrsp$coinsRemain <- srvrsp$coins - srvrsp$coinsUsed
  srvrsp$admin       <- NULL

  return(srvrsp)
}

