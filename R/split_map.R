bbox_as_sf_poly <- function(bbox) {
  bbox_df <- data.frame(
    x = c(bbox$xmin, bbox$xmin, bbox$xmax, bbox$xmax, bbox$xmin),
    y = c(bbox$ymin, bbox$ymax, bbox$ymax, bbox$ymin, bbox$ymin)
  )

  bbox_mat <- as.matrix(bbox_df)
  bbox_sf <- sf::st_sfc(sf::st_polygon(list(bbox_mat)))
  bbox_sf <- sf::st_set_crs(bbox_sf, sf::st_crs(bbox))

  bbox_sf
}

split_map_usa <- function(full_map) {
  full_map[["__UNIQUE_ID__"]] <- seq_len(nrow(full_map))
  out <- lapply(
    albers_extra_bboxes,
    function(x) {
      x <- bbox_as_sf_poly(x)

      # TODO: suppressWarnings isn't a super great way to
      # avoid warnings, but can't use st_geometry because
      # that gets rid of sf attributes
      suppressWarnings(sf::st_intersection(
        sf::st_transform(full_map, sf::st_crs(x)),
        x
      ))
    }
  )
  names(out) <- names(albers_extra_bboxes)

  found_ids <- lapply(out, function(x) {
    x[["__UNIQUE_ID__"]]
  })
  found_ids <- unlist(found_ids)

  unknown <- full_map[!(full_map[["__UNIQUE_ID__"]] %in% found_ids), ]
  unknown <- sf::st_transform(unknown, sf::st_crs(out[[1]]))
  out[["unknown"]] <- unknown

  out
}
