# 0.3.1 (2018-12-18)

* It is now possible to abort the `S2_download()` function.
* A `spatial` parameter of the `S2_query_granule()` and `S2_query_image()` is now
  a string and allows to choose between the `sp` package and the `sf` package spatial
  object representation.
* All `S2_query_...()` functions always return a data frame even when query fetches no
  results. Returned data frame is guaranteed to have at least an `{objectType}Id` 
  column (e.g. `granuleId` for granules, `regionId` for regions of interest, etc.).
* The `S2_download()` can now display a progress bar.

# 0.2.1 (2018-10-25)

* A `regionId` parameter added to all `S2_query_...()` functions for which it's valid.
  While since 0.1.0 it was possible to use it using the `...` parameter, the explicit
  form allows to document it nicely.
* Default values for `dateMin`, `dateMax`, `cloudCovMin` and `cloudCovMax` parameters
  dropped from all `S2_query_...()` functions. They were useless (simply followed 
  default values assumed by the underlaing REST API) and they messed up proper `regionId`
  parameter handling (they interfered with picking up default `dateMin`, `dateMax` and
  `cloudCovMax` values from the region of interest settings)
* Tests coverage slightly improved

# 0.1.1 (2018-06-21)

* `S2_put_ROI()` now also works for admin users.

# 0.1.0 (2017-07-31)

* `S2_download()` was extended with `...` allowing to pass any additional
  parameters to the HTTP API.  
  See the *Advanced image download* chapter in the *introduction* vignette.
* `S2_query_granule()` always returns a data.frame.
  The `spatial` parameter now affects only the type of the `geometry` column
  in the returned data.frame (GeoJSON strings when `FALSE`, 
  `SpatialPolygonsDataFrame` objects when `TRUE`).
* `S2_query_image()` accepts the `spatial` parameter which is triggering conversion
  of returned GeoJSON geometry strings into `SpatialPolygonsDataFrame` objects.
* `spat_to_jgeom()` is now exported and uses `rgdal::readOGR()` in the back.  
  This allows to simply convert any vector file into a GeoJSON geometry string
  accepted by the HTTP API calls.
