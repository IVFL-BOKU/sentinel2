test_that('data frame is always returned', {
  data = S2_query_product(productId = -1)
  expect_is(data, 'data.frame')
  expect_true('productId' %in% names(data))

  data = S2_query_granule(productId = -1)
  expect_is(data, 'data.frame')
  expect_true('granuleId' %in% names(data))

  data = S2_query_image(productId = -1)
  expect_is(data, 'data.frame')
  expect_true('imageId' %in% names(data))

  data = S2_query_angle(productId = -1)
  expect_is(data, 'data.frame')
  expect_true('angleId' %in% names(data))

  data = S2_query_job(productId = -1)
  expect_is(data, 'data.frame')
  expect_true('jobId' %in% names(data))

  data = S2_query_qiData(productId = -1)
  expect_is(data, 'data.frame')
  expect_true('qiDataId' %in% names(data))

  data = S2_query_roi(regionId = '__hopefuly no such region exists__')
  expect_is(data, 'data.frame')
  expect_true('regionId' %in% names(data))
})

test_that('S2_query_*(date) throw errors', {
  expect_error(
    S2_query_product(dateMin = '2016-06-15',dateMax = '2016-06-14'),
    "'dateMin' .* larger than 'dateMax'"
  )

  expect_error(
    S2_query_granule(dateMin = '2016-06-15',dateMax = '2016-06-14', utm = '33UXP'),
    "'dateMin' .* larger than 'dateMax'"
  )

  expect_error(
    S2_query_image(dateMin = '2016-06-15',dateMax = '2016-06-14', utm = '33UXP'),
    "'dateMin' .* larger than 'dateMax'"
  )
  expect_error(
    S2_query_qiData(dateMin = '2016-06-15',dateMax = '2016-06-14', utm = '33UXP'),
    "'dateMin' .* larger than 'dateMax'"
  )

  expect_error(
    S2_query_job(dateMin = '2016-06-15',dateMax = '2016-06-14'),
    "'dateMin' .* larger than 'dateMax'"
  )

  expect_error(
    S2_query_roi(dateMin = '2016-06-15',dateMax = '2016-06-14'),
    "'dateMin' .* larger than 'dateMax'"
  )
})
