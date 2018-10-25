context('S2_query')
S2_initialize_user()

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
})

test_that('S2_query_granule() works', {
  data = S2_query_granule(
    cloudCovMin = 80,
    dateMin = '2016-06-01',
    dateMax = '2016-08-31',
    utm = '33UXP'
  )
  expect_is(data, 'data.frame')
  expect_gt(nrow(data), 0)
  cols = c("granuleId", "productId", "product", "granule", "date", "processDate", "utm", "orbit", "cloudCov", "atmCorr", "broken", "url")
  expect_equal(intersect(names(data), cols), cols)
  expect_true(all(data$cloudCov >= 80))
  expect_true(all(data$date >= '2016-06-01'))
  expect_true(all(data$date <= '2016-08-31'))
  expect_true(all(data$utm == '33UXP'))
})

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
})

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
  expect_true(all(data$orbit == 'DESCENDING'))
  expect_true(all(data$date >= '2016-06-01 00:00:00.000'))
  expect_true(all(data$date <= '2016-08-31 23:59:59.999'))
})

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
  expect_true(all(data$cloudCov >= 80))
  expect_true(all(data$date >= '2016-06-01 00:00:00.000'))
  expect_true(all(data$date <= '2016-06-15 23:59:59.999'))
  expect_true(all(data$utm == '33UXP'))
  expect_true(all(data$qiType == 'satura'))
})

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
})

test_that('S2_query_granule(spatial = TRUE) works', {
  data = S2_query_granule(
    cloudCovMin = 80,
    dateMin = '2016-06-01',
    dateMax = '2016-06-15',
    utm = '33UXP',
    spatial = TRUE
  )
  expect_is(data, 'data.frame')
  expect_gt(nrow(data), 0)
  cols = c("granuleId", "productId", "product", "granule", "date", "processDate", "utm", "orbit", "cloudCov", "atmCorr", "broken", "url")
  expect_equal(intersect(names(data), cols), cols)
  expect_true(all(data$cloudCov >= 80))
  expect_true(all(data$date >= '2016-06-01 00:00:00.000'))
  expect_true(all(data$date <= '2016-06-15 23:59:59.999'))
  expect_true(all(data$utm == '33UXP'))
  expect_true(all(unlist(lapply(data$geometry, function(x){'SpatialPolygonsDataFrame' %in% class(x)}))))
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
  tryCatch(
    {
      S2_download('https://test%40s2.boku.eodc.eu:test@s2.boku.eodc.eu/granule/2920000', destfile = 'testDir', zip = TRUE, skipExisting = FALSE)
      expect_true(file.exists('testDir/MTD_TL.xml'))
    },
    finally = {
      if (file.exists('testDir.zip')) {
        unlink('testDir.zip')
      }
      if (dir.exists('testDir')) {
        system('rm -fR testDir')
      }
    }
  )
})
