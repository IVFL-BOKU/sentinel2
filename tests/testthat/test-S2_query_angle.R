context('S2_query_angle')

test_that('S2_query_angle() works', {
  data = S2_query_angle(
    cloudCovMin = 80,
    dateMin = '2016-01-01',
    dateMax = '2016-01-10',
    utm = '33UXP',
    angleType = 'sun'
  )
  expect_is(data, 'data.frame')
  expect_gt(nrow(data), 0)
  cols = c("angleId", "productId", "granuleId", "product", "granule", "date", "processDate", "utm", "orbit", "angleType", "band", "zenithAngle", "azimuthAngle", "url")
  expect_equal(intersect(names(data), cols), cols)
  expect_true(all(data$date >= '2016-01-01 00:00:00.000'))
  expect_true(all(data$date <= '2016-01-10 23:59:59.999 '))
  expect_true(all(data$utm == '33UXP'))
  expect_true(all(data$angleType == 'sun'))
  expect_true(all(data$band == 'all'))

  data = S2_query_angle(
    cloudCovMin = 80,
    dateSingle = '2016-01-07',
    utm = '33UXP',
    angleType = 'sun'
  )
  expect_is(data, 'data.frame')
  expect_gt(nrow(data), 0)
  cols = c("angleId", "productId", "granuleId", "product", "granule", "date", "processDate", "utm", "orbit", "angleType", "band", "zenithAngle", "azimuthAngle", "url")
  expect_equal(intersect(names(data), cols), cols)
  expect_true(all(data$date >= '2016-01-07 00:00:00.000'))
  expect_true(all(data$date <= '2016-01-07 23:59:59.999 '))
  expect_true(all(data$utm == '33UXP'))
  expect_true(all(data$angleType == 'sun'))
  expect_true(all(data$band == 'all'))
})
