## Use tigris package to create separate
## shape files for lower 48 and all other states
## plus get their bboxes

library(tigris)
library(rmapshaper)
library(sf)
library(dplyr)
library(usethis)


map <- states(resolution = "20m") %>%
  st_as_sf(map) %>%
  ms_simplify(keep = .01) %>% # needed because my computer is slow
  # In current projection, Alaska spans the whole globe
  # So convert to another projection
  sf::st_transform(
    "+proj=laea +lat_0=45 +lon_0=-100 +x_0=0 +y_0=0 +a=6370997 +b=6370997 +units=m +no_defs"
)

lower48 <- map %>%
  filter(as.numeric(STATEFP) < 60 & !(STATEFP %in% c("15", "02")))

alaska <- map %>%
  filter(STATEFP == "02")

hawaii <- map %>%
  filter(STATEFP == "15")

samoa <- map %>%
  filter(STATEFP == "60")

guam <- map %>%
  filter(STATEFP == "66")

north_marina <- map %>%
  filter(STATEFP == "69")

puerto_rico <- map %>%
  filter(STATEFP == "72")

virgin_islands <- map %>%
  filter(STATEFP == "78")


albers_extra_bboxes <- list(
  alaska = st_bbox(alaska),
  hawaii = st_bbox(hawaii),
  samoa = st_bbox(samoa),
  north_marina = st_bbox(north_marina),
  guam = st_bbox(guam),
  puerto_rico = st_bbox(puerto_rico),
  virgin_islands = st_bbox(virgin_islands)
)

use_data(
  lower48,
  alaska,
  hawaii,
  samoa,
  north_marina,
  guam,
  puerto_rico,
  virgin_islands,
  albers_extra_bboxes,
  internal = TRUE,
  overwrite = TRUE
)
