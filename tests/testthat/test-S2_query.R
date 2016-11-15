context('S2_query')
S2_initialize_user()
apiUrl = 'https://test%40s2.boku.eodc.eu:test@s2.boku.eodc.eu/'

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
})

test_that('S2 downloads images', {
  if (file.exists('test.jp2')) {
    unlink('test.jp2')
  }
  on.exit({
    if (file.exists('test.jp2')) {
      unlink('test.jp2')
    }
  })

  data = S2_query_image(imageId = 29392766)
  S2_download(data$url, 'test.jp2')
  expect_true(file.exists('test.jp2'))
  expect_equal(file.info('test.jp2')$size, 3190469)
})

test_that('S2 downloads granules', {
  if (file.exists('testDir.zip')) {
    unlink('testDir.zip')
  }
  if (dir.exists('testDir')) {
    system('rm -fR testDir')
  }
  on.exit({
    if (file.exists('testDir.zip')) {
      unlink('testDir.zip')
    }
    if (dir.exists('testDir')) {
      system('rm -fR testDir')
    }
  })

  S2_download(paste0(apiUrl, 'granule/1437243'), 'testDir')
  expect_true(file.exists('testDir.zip'))
  expect_equal(file.info('testDir.zip')$size, 6399441)
  expect_true(dir.exists('testDir'))
  dirSize = as.numeric(sub('[^0-9]*$', '', system('du -s testDir', intern = TRUE)))
  expect_equal(dirSize, 9388)
})
