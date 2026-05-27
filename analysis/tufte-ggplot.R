tufte_bg <- "#fffff8"
tufte_text <- "#111111"
tufte_muted <- "#666666"
tufte_axis <- "#cccccc"
tufte_highlight <- "#e41a1c"
tufte_secondary <- "#999999"
tufte_positive <- "#4e79a7"
tufte_negative <- "#e15759"

theme_tufte_gg <- function(base_size = 12) {
  theme_minimal(
    base_size = base_size,
    base_family = "Helvetica"
  ) +
    theme(
      panel.grid = element_blank(),
      panel.background = element_rect(fill = tufte_bg, color = NA),
      plot.background = element_rect(fill = tufte_bg, color = NA),
      legend.position = "none",
      axis.line = element_line(color = tufte_axis, linewidth = 0.3),
      axis.ticks = element_line(color = tufte_axis, linewidth = 0.3),
      plot.title.position = "plot",
      plot.title = element_text(color = tufte_text, face = "plain"),
      plot.subtitle = element_text(color = tufte_muted),
      axis.title = element_text(color = tufte_text),
      axis.text = element_text(color = tufte_muted),
      strip.text = element_text(color = tufte_text)
    )
}

scale_color_tufte_models <- function(...) {
  scale_color_manual(
    values = c(
      "Linear regression" = tufte_secondary,
      "LightGBM" = tufte_highlight
    ),
    ...
  )
}

scale_fill_tufte_models <- function(...) {
  scale_fill_manual(
    values = c(
      "Linear regression" = tufte_secondary,
      "LightGBM" = tufte_highlight
    ),
    ...
  )
}

theme_set(theme_tufte_gg())
