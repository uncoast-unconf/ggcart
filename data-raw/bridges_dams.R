library(sf)

bridges <- read_sf("data-raw/bridges.csv",
                   options = c("X_POSSIBLE_NAMES=latmap",
                               "Y_POSSIBLE_NAMES=longmap"))

dams <- read_sf("data-raw/dams.csv",
                options = c("X_POSSIBLE_NAMES=latmap",
                            "Y_POSSIBLE_NAMES=longmap"))

save(bridges, file = "data/bridges.rda")
save(dams, file = "data/dams.rda")
