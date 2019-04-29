context('S2_query_product')

test_that('S2_query_product() works', {
  data = S2_query_product(
    dateMin = '2016-06-01',
    dateMax = '2016-08-31',
    regionId = 'testROI'
  )
  expect_is(data, 'data.frame')
  expect_gt(nrow(data), 0)
  cols = c("productId", "product", "date", "dateEnd", "processDate", "orbitNo", "orbitDir", "granulesCount")
  expect_equal(intersect(names(data), cols), cols)
  expect_true(all(data$orbitDir == 'DESCENDING'))
  expect_true(all(data$date >= '2016-06-01 00:00:00.000'))
  expect_true(all(data$date <= '2016-08-31 23:59:59.999'))

  data = S2_query_product(
    dateSingle = '2016-06-02',
    regionId = 'testROI'
  )
  expect_is(data, 'data.frame')
  expect_gt(nrow(data), 0)
  cols = c("productId", "product", "date", "dateEnd", "processDate", "orbitNo", "orbitDir", "granulesCount")
  expect_equal(intersect(names(data), cols), cols)
  expect_true(all(data$orbitDir == 'DESCENDING'))
  expect_true(all(data$date >= '2016-06-02 00:00:00.000'))
  expect_true(all(data$date <= '2016-06-02 23:59:59.999'))
})
