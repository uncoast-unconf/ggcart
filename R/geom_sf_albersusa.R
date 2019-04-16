GeomSfAlbersusa <- ggplot2::ggproto("GeomSfAlbersusa", ggplot2::Geom,
                  required_aes = "geometry",
                  default_aes = ggplot2::aes(
                    shape = NULL,
                    colour = NULL,
                    fill = NULL,
                    size = NULL,
                    linetype = 1,
                    alpha = NA,
                    stroke = 0.5
                  ),

                  draw_panel = function(self, data, panel_params, coord, legend = NULL) {
                    bbox <- sf::st_bbox(sf::st_as_sf(data))
                    # TODO: This is kind of a hack to reset the x and y ranges for new
                    # data.
                    panel_params$x_range <- c(bbox$xmin - 100000, bbox$xmax + 100000)
                    panel_params$y_range <- c(bbox$ymin - 100000, bbox$ymax + 100000)
                    print(nrow(data))
                    print(class(data))
                    continental_usa <- data
                    # continental_usa <- data[!(data$STUSPS %in% c("AK","HI","PR","GU")), ]
                    #extra_usa <- data[data$STUSPS %in% c("AK","HI","PR","GU"), ]
                    print(nrow(continental_usa))
                    #print(class(continental_usa))
                    #print(nrow(extra_usa))
                    continental_panel <- ggproto_parent(GeomSf, self)$draw_panel(continental_usa, panel_params, coord, legend)
                    continental_panel

                    #test what happens if i put them in a grobTree together

                    # grobTree(continental_panel,
                    #          continental_panel)
                  },


                  draw_key =  function(self, data, params) {
                    data <- ggproto_parent(GeomSf, self)$draw_key(self, data, params)
                    data
                  },

                  setup_data = function(data, params) {
                    split <- split_map_usa(sf::st_as_sf(data))

                    pr_vi <- sf::st_union(puerto_rico, virgin_islands, by_feature = TRUE)

                    split$puerto_rico <- transport_sf(split$puerto_rico, ref = pr_vi, shift = c(-2500000,20000), scale = 4)
                    split$virgin_islands <- transport_sf(split$virgin_islands, ref = pr_vi, shift = c(-2500000,20000), scale = 4)
                    split$hawaii <- transport_sf(split$hawaii, ref = hawaii, shift = c(4680000, -1100000), scale = 1.5, rotate = -0.610865)
                    split$alaska <- transport_sf(split$alaska, ref = alaska, shift = c(3510000, -3000000), scale = 0.47, rotate = -0.873)

                    # TODO: Figure out how to deal with GUAM
                    split$guam <- transport_sf(split$guam %>% st_transform(32655), ref = guam %>% st_transform(32655), scale = 25, rotate = 4.25, shift = c(9000000,9000000))

                    # TODO: Should there be a warning message when we drop points that
                    # fall outside our bboxes?
                    split$unknown <- NULL

                    data <- do.call(rbind, split)

                    data <- sf::st_transform(data, sf::st_crs(bridges))
                    data <- as.data.frame(data)

                    if (is.null(params$crs))
                      return(data)

                    lapply(data, function(layer_data) {
                      if (! is_sf(layer_data)) {
                        return(layer_data)
                      }

                      sf::st_transform(layer_data, params$crs)
                    })
                  }

)


geom_sf_albersusa <- function(mapping = aes(), data = NULL, stat = "sf",
                    position = "identity", na.rm = FALSE, show.legend = NA,
                    inherit.aes = TRUE, ...) {

  c(
    ggplot2::layer(
      geom = GeomSfAlbersusa,
      data = data,
      mapping = mapping,
      stat = stat,
      position = position,
      show.legend = if (is.character(show.legend)) TRUE else show.legend,
      inherit.aes = inherit.aes,
      params = list(
        na.rm = na.rm,
        legend = if (is.character(show.legend)) show.legend else "polygon",
        ...
      )#,
      #layer_class = LayerSf
    ),
    coord_sf(default = TRUE)
  )

}
