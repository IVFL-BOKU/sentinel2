# 0.2.0 (2018-10-25)

* A `regionId` parameter added to all `S2_query_...()` functions for which it's valid.
  While since 0.1.0 it was possible to use it using the `...` parameter, the explicit
  form allows to document it nicely.
* Default values for `dateMin`, `dateMax`, `cloudCovMin` and `cloudCovMax` parameters
  dropped from all `S2_query_...()` functions. They were useless (simply followed 
  default values assumed by the underlaing REST API) and they messed up proper `regionId`
  parameter handling (they interfered with picking up default `dateMin`, `dateMax` and
  `cloudCovMax` values from the region of interest settings)

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
