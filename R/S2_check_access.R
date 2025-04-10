#' (Very basic) check if server/database can be accessed
#'
#' Checks accessibility of server / database and does basic checking of
#'   user credentials
#'
#' @param verbose logical
#' @return logical \code{TRUE} if access to server was successfull and user
#'   credentials seem to be valid, FALSE if 'anything' went wrong
#' @export
S2_check_access = function(verbose = TRUE){
  return(warning('This repository has been deprecated.\nPlease use alternatives like EO-Browser or AWS.'))
  credentials = get_credentials()
  srvrsp =  httr::GET(
    'https://s2.boku.eodc.eu/user/current',
    config = httr::authenticate(credentials['user'], credentials['password'])
  )

  if (httr::status_code(srvrsp) == 200) {
    if (httr::content(srvrsp)$userId == credentials['user']) {
      if (isTRUE(verbose)) {
        cat(sprintf("Logged in to 'https://s2.boku.eodc.eu' as %s\n", credentials['user']))
      }
      return(TRUE)
    } else {
      if (isTRUE(verbose)) {
        warning(
          "Not logged in to s2.boku.eodc.eu -> access to database limited:\n",
          "please check credentials and use 'S2_initialize_user()' to\n",
          "supply a valid 'user' and 'password'\n",
          "see '?S2_intialize_user' or visit 'https://s2.boku.eodc.eu' for details!"
        )
      }
      return(FALSE)
    }
  } else {
    if (isTRUE(verbose)) {
      warning(
        sprintf("Unable to access server! Status code %s returned",
        httr::status_code(srvrsp))
      )
    }
    return(FALSE)
  }
}
