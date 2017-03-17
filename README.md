# sentinel2

[![Build Status](https://travis-ci.org/IVFL-BOKU/sentinel2.svg?branch=master)](https://travis-ci.org/IVFL-BOKU/sentinel2)
[![Coverage Status](https://coveralls.io/repos/github/IVFL-BOKU/sentinel2/badge.svg?branch=master)](https://coveralls.io/github/IVFL-BOKU/sentinel2?branch=master)

Accessing https://s2.boku.eodc.eu Sentinel-2 API made easy.

## Getting Started

This document aims to provide basic guidance on the use of the `sentinel2` 
package for R. The short introduction will cover the following steps:

   1. **Installation**
   2. **User login** to get **access** to the data portal
   3. **Query the database** for available **Sentinel-2 data products**
   4. **Request processing** of Sentinel-2 data products for a **region of interest**
   5. **Download** data products


## Installation

Using the `devtools` package allows to easily install `sentinel2` directly from GitHub, so make sure you have 
`devtools` installed.

```r
# If you don't have it yet, install 'devtools':
# install.packages('devtools')
library(devtools)
install_github('IVFL-BOKU/sentinel2')
```

## User Login

In order to **get access** to the data portal, you have to login as a user. If you 
are not yet a **registered user**, please visit [s2.boku.eodc.eu](https://s2.boku.eodc.eu/) 
first.

Interaction with the data portal typically requires passing user credentials.
Use `S2_initialize_user()` to store your user credentials for the active session, 
and subsequently use `S2_check_access()` to verify access to the data portal.
The first lines of your code make look like this:

```r
library(sentinel2)

S2_initialize_user(user = 'test@s2.boku.eodc.eu', password = 'test')
S2_check_access()
```

Now we have access to the data portal! We might want to query for available data 
now.

## Query the database for Sentinel-2 data products

The data portal ([s2.boku.eodc.eu](https://s2.boku.eodc.eu/)) allows to obtain 
atmospherically corrected Sentinel-2 data and value added products 
(e.g. *LAI*, *AOT*, *FAPAR*, ...) on request. The processed data can be obtain 
in several ways, e.g. as *granules* or *single band images*.

### Query for *granules*

Suppose you are interested in atmospherically corrected data available at a 
specific location (e.g. *LONG 48.15, LAT 16.20*) for a given period of time 
(e.g. *'2016-09-01' to '2016-09-30'*). We will use `S2_query_granule()` to see, 
if there are already some processed data available:

```r
S2_query_granule(atmCorr  = TRUE, 
                 geometry = c(x = 16.20, y = 48.15), 
                 dateMin  = '2016-09-15', 
                 dateMax  = '2016-09-30')
```

The `data.frame` returned contains information about the granules found in the 
database, matching the requested criteria. There are several atmospherically 
corrected granules available, however, none are owned by the user, as the `NA`'s 
in the `url` column reveal.

*Coins* are used to gain access to individual granules using its *regionId* in 
`S2_buy_granule()`:

```r
S2_buy_granule(granuleId = 1080943)
```

*(Please take a look at [s2.boku.eodc.eu](https://s2.boku.eodc.eu/wiki/#!granule.md),
if you are unclear about the meaning of the columns and for a complete list of 
available query options).*

### Query for individual *images*

If we are interested in *indivdual bands* of Sentinel-2 or readily processed 
products such as *LAI*, we can use `S2_query_image()`:

```r
S2_query_image(band        = 'LAI', 
               utm         = '33U', 
               dateMin     = '2016-09-15', 
               dateMax     = '2016-09-30')
```

Although we found processed data in this case (, because another user has 
previously requested processing of the desired area), we expect the returned 
`data.frame` to be empty. Data processing is done on request, so we will need to 
place an order first.

## **Request processing** of Sentinel-2 data products for a **region of interest**

Data processing can be requested via `S2_put_roi()` for a specific location 
(provided e.g. as LAT/LONG point coordinates, a JSON geometry string or objects 
of class `SpatialPoints` or `SpatialPolygons`) and a given period of time. 

To issue a processing request it might be more convenient for you use the web 
interface at [s2.boku.eodc.eu](https://s2.boku.eodc.eu/). Be aware that this 
step requires some consciousness regarding the amount of data that is going to 
be processed!

Placing an order via `S2_put_ROI()` could look like this:

```r
S2_put_ROI(geometry    = c(x=16, y=48),
           regionId    = 'testROI', 
           cloudCovMax = 20, 
           dateMin     = '2016-06-01', 
           dateMax     = '2016-07-01')
```

Since data processing over large areas is somewhat costly, you need to pay 
coins if you issue processing for a region of interest.

`S2_user_info()` allows to check the budget of the user currently logged in:

```r
S2_user_info()
```

In this case, we used the 'test@s2.boku.eodc.eu' user. As we can see, all the 
coins have already been used!

## Download data

Downloading data from the portal can be done using `S2_download()`. You simply 
to pass the `url` found in the `data.frame` returned by `S2_query_granule()` or 
`S2_query_image()` to `S2_download()` and specify filenames / filepaths to save 
the data to.

### *Downloading granules*

Suppose you want to download granules you already own. We can find all granules 
owned by a user via `S2_query_granule(owned = TRUE)`:
```r
granules_owned <- S2_query_granule(owned = TRUE)
granules_owned

```

The column 'granules_owned$url' contains the path to the data we are aboeut to 
download. For each element we download we will have to specify a filename. You 
can either use your own naming scheme or use the convinience function 
`S2_generate_names()` to automatically create names from the 'data.frame' 
returned by the query:

```r
save_names <- S2_generate_names(x = granules_owned)
save_names
```

Now we can simply download the data (in this case to the current working 
directory) like so:

```r
S2_download(url = granules_owned$url, destfile = save_names)
```


### *Downloading images*

Downloading individual images can be done similarly. First we have to find some 
images we own. Let's assume we are only interested in Band 8 and restrict the 
cloud coverage to be at most 85 percent:

```r
S2_query_image(owned = TRUE, band = 'B08', cloudCovMax = 85)
```


