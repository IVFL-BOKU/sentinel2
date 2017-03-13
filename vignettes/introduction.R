## ----eval=FALSE----------------------------------------------------------
#  # If you don't have it yet, install 'devtools':
#  # install.packages('devtools')
#  library(devtools)
#  install_github('IVFL-BOKU/sentinel2')

## ------------------------------------------------------------------------
library(sentinel2)

S2_initialize_user(user = 'test@s2.boku.eodc.eu', password = 'test')
S2_check_access()

## ------------------------------------------------------------------------
S2_query_granule(atmCorr  = TRUE, 
                 geometry = c(x = 16.20, y = 48.15), 
                 dateMin  = '2016-09-15', 
                 dateMax  = '2016-09-30')

## ----eval = FALSE--------------------------------------------------------
#  S2_buy_granule(granuleId = 1080943)

## ------------------------------------------------------------------------
S2_query_image(band        = 'LAI', 
               utm         = '33U', 
               dateMin     = '2016-09-15', 
               dateMax     = '2016-09-30')

## ----eval = FALSE--------------------------------------------------------
#  S2_put_ROI(geometry    = c(x=16, y=48),
#             regionId    = 'testROI',
#             cloudCovMax = 20,
#             dateMin     = '2016-06-01',
#             dateMax     = '2016-07-01')

## ------------------------------------------------------------------------
S2_user_info()

## ------------------------------------------------------------------------
granules_owned <- S2_query_granule(owned = TRUE)
granules_owned


## ------------------------------------------------------------------------
save_names <- S2_generate_names(x = granules_owned)
save_names

## ----eval=FALSE----------------------------------------------------------
#  S2_download(url = granules_owned$url, destfile = save_names)

## ------------------------------------------------------------------------
S2_query_image(owned = TRUE, band = 'B08', cloudCovMax = 85)

