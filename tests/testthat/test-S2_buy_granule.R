context('buying')

test_that('S2_buy_granule() works', {
  granules = S2_query_granule(owned = TRUE)

  expect_equal(S2_buy_granule(granules$granuleId[1:2], 'always'), c(FALSE, FALSE))

  expect_equal(S2_buy_granule(granules$granuleId[1:2], 'force'), c(TRUE, TRUE))

  expect_error(S2_buy_granule(1, 'always'), 'Please check coin budget')
})
