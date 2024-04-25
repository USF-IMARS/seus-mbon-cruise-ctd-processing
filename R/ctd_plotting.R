library(dplyr)
library(ggplot2)

# function to plot CTD data
ctd_plotting <- function(.data, depth, var1, xlab = NULL, .color = "blue") {
  .data <- dplyr::select(.data, var1 = {{ var1 }}, depth = {{ depth }})

  ggplot(
    data = na.omit(.data),
    aes(x = var1, y = depth)
  ) +
    geom_smooth(
      color = "red", method = "loess", span = 0.05, orientation = "y",
      se = FALSE, alpha = 0.5
    ) +
    geom_path(colour = .color, alpha = 0.7, linewidth = 0.5) +
    scale_y_reverse(
      breaks = scales::breaks_pretty(n = 6), limits = c(NA, 0),
      expand = expansion(add = c(1, 0))) +
    scale_x_continuous(breaks = scales::breaks_pretty(n = 3), position = "top") +
    theme_bw() +
    theme(
      axis.text = element_text(size = 12, colour = 1),
      axis.title = element_text(size = 14, colour = 1)
    ) +
    labs(
      x = xlab,
      y = "Pressure[dbar]"
    )

  # ---- end of function ctd_plotting
}
