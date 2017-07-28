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
