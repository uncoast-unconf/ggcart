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

                    print(nrow(data))
                    print(class(data))
                    continental_usa <- data
                    #continental_usa <- data[!(data$STUSPS %in% c("AK","HI","PR","GU")), ]
                    #extra_usa <- data[data$STUSPS %in% c("AK","HI","PR","GU"), ]
                    print(nrow(continental_usa))
                    #print(class(continental_usa))
                    #print(nrow(extra_usa))
                    continental_panel <- ggproto_parent(GeomSf, self)$draw_panel(continental_usa, panel_params, coord, legend)
                    continental_panel
                  },


                  draw_key =  function(self, data, params) {
                    data <- ggproto_parent(GeomSf, self)$draw_key(self, data, params)
                    data
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



sf_types <- c(GEOMETRY = "other", POINT = "point", LINESTRING = "line",
              POLYGON = "other", MULTIPOINT = "point", MULTILINESTRING = "line",
              MULTIPOLYGON = "other", GEOMETRYCOLLECTION = "other",
              CIRCULARSTRING = "line", COMPOUNDCURVE = "other", CURVEPOLYGON = "other",
              MULTICURVE = "other", MULTISURFACE = "other", CURVE = "other",
              SURFACE = "other", POLYHEDRALSURFACE = "other", TIN = "other",
              TRIANGLE = "other")
