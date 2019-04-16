# Adapted from Laura DeCicco's article Mapping Points
# (which in turn was based on Bob Rudis's code)
# http://usgs-r.github.io/dataRetrieval/articles/usMaps.html


#' Transport (shift, rotate and scale) an sf object
#'
#' Takes an sf object and a reference sf object and transports
#' it by scaling, shifting it and rotating it.
#'
#' @param sf The sf object to transport
#' @param ref The reference sf object
#' @param scale A scaling factor (defaults to 1, meaning no change in scale)
#' @param shift Distance to shift (TKTKTK what units is it?)
#' @param rotate Radians to rotate the sf object
#'
#' @return An sf object
#' @export
#'
#' @examples
#' # Transports Puerto Rico off the coast of Georgia, rotate 90 degrees
#' # made 4 times bigger (original Puerto Rico in red, moved in blue)
#' library(ggplot2)
#' ggplot()+
#' geom_sf(data=albersextra:::lower48)+
#'   geom_sf(data=albersextra:::puerto_rico, color = "red")+
#'   geom_sf(data=transport_sf(sf=albersextra:::puerto_rico,
#'                        ref=albersextra:::puerto_rico,
#'                        scale=4,
#'                        shift = c(-130,90),
#'                        rotate=pi/2), color="blue")
transport_sf <- function(sf, ref, scale=1, shift=c(0,0), rotate=0) {
  geo <- sf::st_geometry(sf)
  centroid <- sf::st_centroid(sf::st_transform(sf::st_geometry(ref), sf::st_crs(sf)))
  rotation_matrix <- matrix(
    c(cos(rotate), sin(rotate), -sin(rotate), cos(rotate)),
    nrow=2,ncol=2
  )
  geo <- ((((geo - centroid) * scale) * rotation_matrix)+ shift*10000) + centroid
  sf::st_crs(geo) <- sf::st_crs(sf)
  sf::st_geometry(sf) <- geo
  sf
}


