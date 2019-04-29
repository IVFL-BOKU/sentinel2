context('S2_query_roi')

test_that('S2_query_roi() works', {
  data = S2_query_roi(
    regionId = 'test%'
  )
  expect_is(data, 'data.frame')
  expect_gt(nrow(data), 0)
  cols = c("userId", "regionId", "dateMin", "dateMax", "priority", "cloudCovMax", "jobTypes", "geometry", "url")
  expect_equal(intersect(names(data), cols), cols)
  expect_true(all(grepl('^test', data$regionId)))
  expect_true(all(data$userId == 'test@s2.boku.eodc.eu'))

  data = S2_query_roi(
    dateSingle = '2016-06-30'
  )
  expect_is(data, 'data.frame')
  expect_gt(nrow(data), 0)
  cols = c("userId", "regionId", "dateMin", "dateMax", "priority", "cloudCovMax", "jobTypes", "geometry", "url")
  expect_equal(intersect(names(data), cols), cols)
  expect_true(all(grepl('^test', data$regionId)))
  expect_true(all(data$userId == 'test@s2.boku.eodc.eu'))
})
