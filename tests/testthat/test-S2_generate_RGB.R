context('S2_query')

test_that('S2_generate_RGB() works', {
  imgs = S2_query_image(owned = TRUE, atmCorr = TRUE, resolution = 60, cloudCovMax = 10) %>%
    dplyr::filter(band %in% c('B02', 'B03', 'B04')) %>%
    dplyr::arrange(date, band)
  file = tempfile()
  S2_generate_RGB(imgs$granuleId[1], destfile = file, overwrite = TRUE)
  expect_true(file.exists(file))
  expect_gt(file.size(file), 1000000)
  unlink(file)
})
