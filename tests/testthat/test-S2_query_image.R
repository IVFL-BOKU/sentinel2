context('S2_query_image')

test_that('S2_query_image() works', {
  data = S2_query_image(
    atmCorr = FALSE,
    band = 'B10',
    cloudCovMin = 80,
    dateMin = '2016-06-01',
    dateMax = '2016-08-31',
    utm = '33UXP'
  )
  expect_is(data, 'data.frame')
  expect_gt(nrow(data), 0)
  cols = c("imageId", "productId", "granuleId", "product", "granule", "utm", "orbit", "band", "resolution", "cloudCov", "atmCorr", "date", "format", "processDate", "url")
  expect_equal(intersect(names(data), cols), cols)
  expect_true(all(as.numeric(data$atmCorr) == 0))
  expect_true(all(data$band == 'B10'))
  expect_true(all(data$cloudCov >= 80))
  expect_true(all(data$date >= '2016-06-01'))
  expect_true(all(data$date <= '2016-08-31'))
  expect_true(all(data$utm == '33UXP'))

  data = S2_query_image(
    atmCorr = FALSE,
    band = 'B10',
    cloudCovMin = 80,
    dateSingle = '2016-08-21',
    utm = '33UXP'
  )
  expect_is(data, 'data.frame')
  expect_gt(nrow(data), 0)
  cols = c("imageId", "productId", "granuleId", "product", "granule", "utm", "orbit", "band", "resolution", "cloudCov", "atmCorr", "date", "format", "processDate", "url")
  expect_equal(intersect(names(data), cols), cols)
  expect_true(all(as.numeric(data$atmCorr) == 0))
  expect_true(all(data$band == 'B10'))
  expect_true(all(data$cloudCov >= 80))
  expect_true(all(data$date >= '2016-08-21'))
  expect_true(all(data$date <= '2016-08-21 23:59:59'))
  expect_true(all(data$utm == '33UXP'))
})
