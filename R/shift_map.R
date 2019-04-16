# Adapted from Laura DeCicco's article Mapping Points
# (which in turn was based on Bob Rudis's code)
# http://usgs-r.github.io/dataRetrieval/articles/usMaps.html
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

shift_sf <- function(sf, shift) {
  identity(sf)
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


