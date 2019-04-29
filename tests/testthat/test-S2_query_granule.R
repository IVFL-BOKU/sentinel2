context('S2_query_granule')

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

  data = S2_query_granule(
    cloudCovMin = 80,
    dateSingle = '2016-06-15',
    utm = '33UXP'
  )
  expect_is(data, 'data.frame')
  expect_gt(nrow(data), 0)
  cols = c("granuleId", "productId", "product", "granule", "date", "processDate", "utm", "orbit", "cloudCov", "atmCorr", "broken", "url")
  expect_equal(intersect(names(data), cols), cols)
  expect_true(all(data$cloudCov >= 80))
  expect_true(all(data$date >= '2016-06-15'))
  expect_true(all(data$date <= '2016-06-15 23:59:59'))
  expect_true(all(data$utm == '33UXP'))
})

test_that('S2_query_granule() geometry filters work', {
  data = S2_query_granule(
    cloudCovMin = 80,
    dateMin = '2016-06-01',
    dateMax = '2016-06-15',
    utm = '33UXP'
  )

  data2 = S2_query_granule(
    cloudCovMin = 80,
    dateMin = '2016-06-01',
    dateMax = '2016-06-15',
    geometry = c(x = 16.5, y = 48.0)
  )
  expect_equal(data2, data)

  data2 = S2_query_granule(
    cloudCovMin = 80,
    dateMin = '2016-06-01',
    dateMax = '2016-06-15',
    geometry = '{"type": "Point", "coordinates": [16.5, 48.0]}'
  )
  expect_equal(data2, data)

  file = tempfile(fileext = '.geojson')
  writeLines('{"type": "Point", "coordinates": [16.5, 48.0]}', file)
  data2 = S2_query_granule(
    cloudCovMin = 80,
    dateMin = '2016-06-01',
    dateMax = '2016-06-15',
    geometry = file
  )
  unlink(file)
  expect_equal(data2, data)

  data2 = S2_query_granule(
    cloudCovMin = 80,
    dateMin = '2016-06-01',
    dateMax = '2016-06-15',
    geometry = sp::SpatialPointsDataFrame(matrix(c(16.5, 48.0), ncol = 2), data.frame(id = 1), proj4string = sp::CRS('+init=epsg:4326'))
  )
  expect_equal(data2, data)

  data2 = S2_query_granule(
    cloudCovMin = 80,
    dateMin = '2016-06-01',
    dateMax = '2016-06-15',
    geometry = sp::SpatialPointsDataFrame(matrix(c(16.5, 48.0), ncol = 2), data.frame(id = 1))
  )
  expect_equal(data2, data)
})

test_that('S2_query_granule(spatial) works', {
  data = S2_query_granule(
    cloudCovMin = 80,
    dateMin = '2016-06-01',
    dateMax = '2016-06-15',
    utm = '33UXP',
    spatial = 'sp'
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

  data = S2_query_granule(
    cloudCovMin = 80,
    dateMin = '2016-06-01',
    dateMax = '2016-06-15',
    utm = '33UXP',
    spatial = 'sf'
  )
  expect_is(data, 'data.frame')
  expect_gt(nrow(data), 0)
  cols = c("granuleId", "productId", "product", "granule", "date", "processDate", "utm", "orbit", "cloudCov", "atmCorr", "broken", "url")
  expect_equal(intersect(names(data), cols), cols)
  expect_true(all(data$cloudCov >= 80))
  expect_true(all(data$date >= '2016-06-01 00:00:00.000'))
  expect_true(all(data$date <= '2016-06-15 23:59:59.999'))
  expect_true(all(data$utm == '33UXP'))
  expect_true(all(unlist(lapply(data$geometry, function(x){'sf' %in% class(x)}))))
})
