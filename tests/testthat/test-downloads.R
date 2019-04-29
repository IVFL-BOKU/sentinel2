context('downloads')

test_that('S2 downloads images', {
  if (file.exists('test.jp2')) {
    unlink('test.jp2')
  }
  on.exit({
    if (file.exists('test.jp2')) {
      unlink('test.jp2')
    }
  })

  data = S2_query_image(imageId = 29392766, granuleId = 1380347)
  S2_download(data$url, 'test.jp2')
  expect_true(file.exists('test.jp2'))
  expect_equal(file.size('test.jp2'), 3190469)

  writeLines('foo', 'test.jp2')
  S2_download(data$url, 'test.jp2', skipExisting = 'always')
  expect_equal(file.size('test.jp2'), 4)

  writeLines('foo', 'test.jp2')
  S2_download(data$url, 'test.jp2', skipExisting = 'samesize')
  expect_equal(file.size('test.jp2'), 3190469)
})

test_that('S2 downloads timeout works', {
  on.exit({
    if (file.exists('test.jp2')) {
      unlink('test.jp2')
    }
  })

  data = S2_query_image(imageId = 30135471, granuleId = 1437243)

  results = S2_download(data$url, 'test.jp2', timeout = 1, skipExisting = 'never')
  expect_false(results)

  results = S2_download(data$url, 'test.jp2', timeout = 1, tries = 3, skipExisting = 'never')
  expect_false(results)
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
      S2_download('https://test%40s2.boku.eodc.eu:test@s2.boku.eodc.eu/granule/2920000', destfile = 'testDir', zip = TRUE, skipExisting = 'never')
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
