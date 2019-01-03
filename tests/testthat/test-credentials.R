context('credentials')

test_that('S2_user_info() works', {
  ui = S2_user_info()
  expect_equal(ui$userId, 'test@s2.boku.eodc.eu')
  expect_lt(ui$coinsRemain, 0)
})

test_that('S2_initialize_user() works', {
  S2_initialize_user('aaa', 'bbb')
  ui = S2_user_info()
  expect_equal(ui, list(userId = 'public', coins = 0, coinsUsed = 0, coinsRemain = 0))

  S2_initialize_user('test@s2.boku.eodc.eu', 'test')
})

test_that('S2_check_access() works', {
  S2_initialize_user('aaa', 'bbb')
  expect_false(suppressWarnings(S2_check_access()))

  S2_initialize_user('test@s2.boku.eodc.eu', 'test')
  expect_true(S2_check_access())
})
