context('S2_query')

test_that('S2_generate_RGB() works', {
  imgs = S2_query_image(owned = TRUE, atmCorr = TRUE, resolution = 60, cloudCovMax = 10) %>%
    dplyr::filter(band %in% c('B02', 'B03', 'B04')) %>%
    dplyr::arrange(date, band)
  file = S2_generate_RGB(imgs$granuleId[1], atmCorr = TRUE, resolution = 'lowest', overwrite = TRUE)
  on.exit({
    if (file.exists(file)) {
      unlink(file)
    }
  })
  expect_true(file.exists(file))
  expect_gt(file.size(file), 1000000)
})

test_that('S2_generate_RGB() exceptions', {
  imgs = S2_query_image(owned = TRUE, atmCorr = TRUE, resolution = 60, cloudCovMax = 10) %>%
    dplyr::filter(band %in% c('B02')) %>%
    dplyr::arrange(date, band)
  expect_error(
    S2_generate_RGB(imgs$granuleId, atmCorr = TRUE, resolution = 'lowest', destfile = file, overwrite = TRUE),
    'granuleId has to be a vector of length one'
  )

  expect_null(suppressWarnings(S2_generate_RGB(-1, atmCorr = TRUE, resolution = 'lowest', destfile = file, overwrite = TRUE)))
  expect_null(suppressWarnings(S2_generate_RGB(-1, atmCorr = FALSE, resolution = 'lowest', destfile = file, overwrite = TRUE)))

  expect_error(
    S2_generate_RGB(imgs, atmCorr = TRUE, resolution = 'lowest', destfile = file, overwrite = TRUE),
    'granuleId has to be a vector of length one'
  )
})
