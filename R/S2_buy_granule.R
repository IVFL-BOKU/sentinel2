#' Buy a granule at 'https://s2.boku.eodc.eu'
#'
#' Buy granule using granuleId
#'
#' @param granuleId character vector of one or more granuleId's to buy
#' @param mode one of 'ask', 'always' or 'force'. If 'ask', the user is prompted
#'   for confirmation before spending coins ( - in interactive sessions only!).
#'   If 'always', granules are bought without prompting but granule bought
#'   already are skipped. If 'force', granules are bought without prompting and
#'   also withoug checking if they are already bought.
#' @return boolean logical vector indicating which granules were actually bought
#'   (note that if \code{mode = 'force'}, there will be no \code{FALSE} values
#'   in the returned vector). If the underlaying HTTP request failed, the value
#'   is \code{NA}.
#' @export
S2_buy_granule = function(granuleId, mode = c('ask', 'always', 'force')) {
  buy_mode = match.arg(mode)

  # Check how many coins are required and available ----------------------------
  to_buy     = buy_check(granuleId = granuleId)
  user_coins = S2_user_info()$'coinsRemain'

  # Check if number of granules to buy exceeds coin budget ---------------------
  if (user_coins < sum(to_buy) & sum(to_buy) > 0) {
    stop(
      "You try to buy ", sum(to_buy), " granules, but you seem to have only ", user_coins, " coins left.\n",
      "Please check coin budget or reduce number of granules to buy."
    )
  } else if (sum(to_buy) == 0 & buy_mode != 'force') {
    if (interactive()) {
      cat("Nothing to buy.")
    }
    return(invisible(rep(FALSE, length(granuleId))))
  }

  # Promt user for confirmation ------------------------------------------------
  # Check if session is running in interactive mode ----------------------------
  if (buy_mode == "ask") {
    if (!interactive()) {
      stop("'mode = 'ask'' can only be run in interactive mode!")
    } else {
      cat(sprintf("You are about to buy %s granules.", sum(to_buy)))
      quest   = "This action will cost you coins! Type 'YES' to proceed:\t"
      if (!readline(prompt = quest) %in% c("YES", "'YES'")) {
        cat("Action canceled.")
        return(invisible(NULL))
      }
    }
  }

  # Finally buy granule's if buy_all is TRUE -----------------------------------
  credentials = get_credentials()
  auth        = httr::authenticate(credentials['user'], credentials['password'])

  rtrn = rep(FALSE, length(granuleId))
  for (i in seq_along(granuleId)) {
    if (to_buy[i] | buy_mode == 'force') {
      resp = httr::PUT(
        'https://s2.boku.eodc.eu',
        config = auth,
        path   = list('granule', granuleId[i])
      )
      rtrn[i] = ifelse(httr::status_code(resp) == 200, TRUE, NA)
    }
  }
  return(invisible(rtrn))
}
