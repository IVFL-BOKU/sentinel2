context('put roi')

test_that('S2_put_roi() works', {
  ret = S2_put_roi('{"type": "Polygon", "coordinates": [[[16.5, 48.0], [16.6, 48.1], [16.6, 48.0], [16.5, 48.0]]]}', '__test__', 0, 'LAI', '1900-01-01', '1900-01-02')
  expect_equal(ret, list(userId = 'test@s2.boku.eodc.eu', regionId = '__test__'))
  d = S2_query_roi(regionId = '__test__')
  expect_equal(nrow(d), 1)
  expect_equal(d$dateMax, '1900-01-02')

  ret = S2_put_roi('{"type": "Polygon", "coordinates": [[[16.5, 48.0], [16.6, 48.1], [16.6, 48.0], [16.5, 48.0]]]}', '__test__', 0, 'LAI', '1900-01-01', '1900-02-02')
  expect_equal(ret, list(userId = 'test@s2.boku.eodc.eu', regionId = '__test__'))
  d = S2_query_roi(regionId = '__test__')
  expect_equal(nrow(d), 1)
  expect_equal(d$dateMax, '1900-02-02')
})

test_that('S2_put_roi() exceptions', {
  expect_error(
    S2_put_roi('{"type": "Polygon", "coordinates": [[[16.5, 48.0], [16.6, 48.1], [16.6, 48.0], [16.5, 48.0]]]}', '__test__', 0, 'LAI', '1900-01-01'),
    "Please supply 'dateMin' and 'dateMax'"
  )

  expect_error(
    S2_put_roi('{"type": "Polygon", "coordinates": [[[16.5, 48.0], [16.6, 48.1], [16.6, 48.0], [16.5, 48.0]]]}', '__test__', 0, 'LAI', '2000-01-01', '1900-01-01'),
    "'dateMin' .* larger than 'dateMax'"
  )

  expect_error(
    S2_put_roi('{"type": "Polygon", "coordinates": [[[16.5, 48.0], [16.6, 48.1], [16.6, 48.0], [16.5, 48.0]]]}', cloudCovMax = 0, indicators = 'LAI', dateMin = '2000-01-01', dateMax = '3000-01-01'),
    "'regionId' not specified"
  )
})
