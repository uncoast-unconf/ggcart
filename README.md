
<!-- README.md is generated from README.Rmd. Please edit that file -->

# albersextra

<!-- badges: start -->

<!-- badges: end -->

The goal of albersextra is to include Puerto Rico, the Virgin Islands
and Guam in the traditional Albers maps. Also, albersextra will make it
easier to map line, point and other data in the Albers projection.

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("uncoast-unconf/albersextra")
```

## Examples

Sample datasets include information from the National Inventory of Dams
and the National Bridge Inventory.

``` r
library(albersextra)
## Pull in sample data for mapping
head(bridges) ## Data slice from National Bridge Inventory
#>   st_abbv rectype rtnum           strcture latitude longitude year
#> 1      AK       1 10808    NO DATA ENTERED  0.00000    0.0000 2008
#> 2      AK       1 00391    CHINIAK HIGHWAY 57.60400 -152.4055 1974
#> 3      AK       1 80007            8000700 55.79634 -131.6278 1999
#> 4      AK       1 00966 MENDENHALL LOOP RD 58.40417 -134.5847 1985
#> 5      AK       1 06590    NO DATA ENTERED 56.34885 -132.7188 2004
#> 6      AK       1 NSPCY       DIMOND DRIVE 61.17722 -149.8447 1978
#>   bridgecond          geometry
#> 1          F          NaN, NaN
#> 2          F -3422682, 4855940
#> 3          G -2309931, 4058852
#> 4          F -2384415, 4382488
#> 5          G -2355319, 4139464
#> 6          G -3090509, 5070914
```

The standard Albers conic projection isn’t great for points in Alaska,
Hawaii, Puerto Rico, Guam and the U.S. Virgin Islands. (AK and HI are
taken care of with AlbersUSA. )

``` r
# Map the dams sample data.
library(ggplot2)
ggplot() + geom_sf(data = dams) + coord_sf()
```

<img src="man/figures/README-example2-1.png" width="100%" />

``` r
# Map the bridges sample data.
library(ggplot2)
ggplot() + geom_sf(data = bridges) + coord_sf()
```

<img src="man/figures/README-example3-1.png" width="100%" />

To convert your own set of point data with a latitude and longitude to
an sf object, try the following:

``` r
# To convert your own point data for use with albersextra
bridges <- read_sf("data-raw/bridges.csv", ## Replace with your own csv file
                   options = c("X_POSSIBLE_NAMES=longitude",
                               "Y_POSSIBLE_NAMES=latitude"))
```
