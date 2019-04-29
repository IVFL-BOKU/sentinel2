context('put roi')

test_that('S2_generate_names() works', {
  data = S2_query_image(imageId = 29392766, granuleId = 1380347)
  nms = S2_generate_names(data, 'someDir')
  expect_true(grepl('^someDir/IMAGE_2016-08-21_33UXP_79_B10_60m_Id29392766_L1C.jp2$', nms))

  data = S2_query_granule(granuleId = 1380347)
  nms = S2_generate_names(data, 'someDir')
  expect_true(grepl('^someDir/GRANULE_2016-08-21_33UXP_79_Id1380347_L2A$', nms))
})

test_that('S2_granule_naming() works', {
  data = S2_query_granule(granuleId = 1380347)
  nms = S2_granule_naming(data)
  expect_true(grepl('^GRANULE_2016-08-21_33UXP_79_Id1380347_L2A$', nms))

  expect_error(
    S2_granule_naming(data, order = 'aaa'),
    "Invalid 'granule' naming."
  )
})

test_that('S2_naming() works', {
  data = S2_query_granule(granuleId = 1380347)
  nms = S2_naming(data)
  expect_true(grepl('^GRANULE_2016-08-21_33UXP_79_Id1380347_L2A$', nms))
})

test_that('check_date() works', {
  expect_error(
    check_date('2019/01/01'),
    'Invalid date'
  )
})
