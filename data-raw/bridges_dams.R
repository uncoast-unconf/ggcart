library(sf)

bridges <- read_sf("data-raw/bridges.csv",
                   options = c("X_POSSIBLE_NAMES=latitude",
                               "Y_POSSIBLE_NAMES=longitude"))
bridges <- st_set_crs(bridges, 5070)

dams <- read_sf("data-raw/dams.csv",
                options = c("X_POSSIBLE_NAMES=latitude",
                            "Y_POSSIBLE_NAMES=longitude"))
dams <- st_set_crs(dams, 5070)

save(bridges, file = "data/bridges.rda")
save(dams, file = "data/dams.rda")
