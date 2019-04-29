context('S2_query_job')

test_that('S2_query_job() works', {
  data = S2_query_job(
    regionId = 'testROI'
  )
  expect_is(data, 'data.frame')
  expect_gt(nrow(data), 0)
  cols = c("jobId", "jobType", "productId", "granuleId", "product", "granule", "date", "priority", "created", "started", "ended", "failed")
  expect_equal(intersect(names(data), cols), cols)
  expect_true(all(!is.na(data$jobId)))
  expect_true(all(data$date >= '2016-01-01 00:00:00.000'))
  expect_true(all(data$date <= '2016-07-01 23:59:59.999'))

  data = S2_query_job(
    dateSingle = '2016-12-29',
    regionId = 'testROI'
  )
  expect_is(data, 'data.frame')
  expect_gt(nrow(data), 0)
  cols = c("jobId", "jobType", "productId", "granuleId", "product", "granule", "date", "priority", "created", "started", "ended", "failed")
  expect_equal(intersect(names(data), cols), cols)
  expect_true(all(!is.na(data$jobId)))
  expect_true(all(data$date >= '2016-12-29 00:00:00.000'))
  expect_true(all(data$date <= '2016-12-29 23:59:59.999'))
})
