# Adapted from Laura DeCicco's article Mapping Points
# (which in turn was based on Bob Rudis's code)
# http://usgs-r.github.io/dataRetrieval/articles/usMaps.html

#' Title
#'
#' @param sf
#' @param ref
#' @param scale
#' @param shift
#' @param rotate
#'
#' @return
#' @export
#'
#' @examples
move_sf <- function(sf, ref, scale=1, shift=c(0,0), rotate=0) {
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

move_sf <- function(sf, scale, shift, rotate = 0, ref = sp) {
  out <- sf
  out <- scale_sf(out, scale)
  out <- shift_sf(out, shift)
  out <- rotate_sf(out, rotate)
  out
}

scale_sf <- function(sf, scale, ref) {
  geo <- sf::st_geometry(sf)
  centroid <- sf::st_centroid(sf::st_transform(sf::st_geometry(ref), sf::st_crs(sf)))
  geo <- ((geo - centroid) * scale) + centroid
  sf::st_crs(geo) <- sf::st_crs(sf)
  sf::st_geometry(sf) <- geo
  sf
}

shift_sf <- function(sf, shift, ref) {
  geo <- sf::st_geometry(sf)
  centroid <- sf::st_centroid(sf::st_transform(sf::st_geometry(ref), sf::st_crs(sf)))
  geo <- ((geo - centroid) + shift*10000) + centroid
  sf::st_crs(geo) <- sf::st_crs(sf)
  sf::st_geometry(sf) <- geo
  sf
}

rotate_sf <- function(sf, rotate, ref) {
  geo <- sf::st_geometry(sf)
  centroid <- sf::st_centroid(sf::st_transform(sf::st_geometry(ref), sf::st_crs(sf)))

  rotation_matrix <- matrix(
    c(cos(rotate), sin(rotate), -sin(rotate), cos(rotate)),
    2,
    2
  )
  geo <- ((geo - centroid) * rotation_matrix) + centroid
  sf::st_crs(geo) <- sf::st_crs(sf)
  sf::st_geometry(sf) <- geo
  sf
}


