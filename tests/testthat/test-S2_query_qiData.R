context('S2_query_qiData')

test_that('S2_query_qiData() works', {
  data = S2_query_qiData(
    cloudCovMin = 80,
    dateMin = '2016-06-01',
    dateMax = '2016-06-15',
    utm = '33UXP',
    qiType = 'satura'
  )
  expect_is(data, 'data.frame')
  expect_gt(nrow(data), 0)
  cols = c("qiDataId", "productId", "granuleId", "product", "granule", "date", "processDate", "utm", "orbit", "qiType", "band", "url")
  expect_equal(intersect(names(data), cols), cols)
  expect_true(all(data$date >= '2016-06-01 00:00:00.000'))
  expect_true(all(data$date <= '2016-06-15 23:59:59.999'))
  expect_true(all(data$utm == '33UXP'))
  expect_true(all(data$qiType == 'satura'))

  data = S2_query_qiData(
    cloudCovMin = 80,
    dateSingle = '2016-06-15',
    utm = '33UXP',
    qiType = 'satura'
  )
  expect_is(data, 'data.frame')
  expect_gt(nrow(data), 0)
  cols = c("qiDataId", "productId", "granuleId", "product", "granule", "date", "processDate", "utm", "orbit", "qiType", "band", "url")
  expect_equal(intersect(names(data), cols), cols)
  expect_true(all(data$date >= '2016-06-15 00:00:00.000'))
  expect_true(all(data$date <= '2016-06-15 23:59:59.999'))
  expect_true(all(data$utm == '33UXP'))
  expect_true(all(data$qiType == 'satura'))
})
