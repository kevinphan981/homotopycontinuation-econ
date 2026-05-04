library(tidyverse)
if (!require("plotly")) install.packages("plotly")
library(plotly)

print(getwd())
setwd('~/Programming/homotopycontinuation-econ')
# 
# sols <- read.csv('path_summary.csv')
# # Add only filtered solutions
# sols_pos <- subset(sols, px > 0 & py > 0)
# 
# 
# n_grid <- 50
# # Focus only on the positive quadrant for px and py
# grid_axis <- seq(0, 30, length.out = n_grid) 
# # Z can still be negative based on your solutions, so we keep its full range
# grid_z    <- seq(-30, 30, length.out = n_grid)
# 
# g <- expand.grid(px = grid_axis, py = grid_axis, Z = grid_z)
# 
# # Recalculate values
# f1 <- with(g, -2700 + 2700*px + 8100*Z^2*px^2 - 5400*Z^2*px^3 + 51*Z^3*px^6 - 2*Z^3*px^7)
# f2 <- with(g, -2700 + 2700*py + 8100*Z^2*py^2 - 5400*Z^2*py^3 + 51*Z^3*py^6 - 2*Z^3*py^7)
# f3 <- with(g, Z^2 * px^2 * py^2 - (px^2 + py^2))
# 
# # Plot
# fig <- plot_ly() %>%
#   add_trace(type = "isosurface", x = g$px, y = g$py, z = g$Z, value = f1,
#             isomin = -0.1, isomax = 0.1, surface = list(count = 1),
#             colorscale = list(c(0, 1), c("red", "red")), opacity = 0.2, name="Eq 1") %>%
#   add_trace(type = "isosurface", x = g$px, y = g$py, z = g$Z, value = f2,
#             isomin = -0.1, isomax = 0.1, surface = list(count = 1),
#             colorscale = list(c(0, 1), c("blue", "blue")), opacity = 0.2, name="Eq 2") %>%
#   add_trace(type = "isosurface", x = g$px, y = g$py, z = g$Z, value = f3,
#             isomin = -0.1, isomax = 0.1, surface = list(count = 1),
#             colorscale = list(c(0, 1), c("green", "green")), opacity = 0.2, name="Z-Constraint")
# 
# fig <- fig %>% add_trace(
#   data = sols_pos, x = ~px, y = ~py, z = ~z,
#   type = "scatter3d", mode = "markers",
#   marker = list(size = 8, color = "gold", line = list(color = "black", width = 1)),
#   name = "Positive Solutions"
# )
# 
# fig %>% layout(scene = list(xaxis=list(range=c(0,30)), yaxis=list(range=c(0,30))))


# cursed

df_bertrand = read.csv('bertrand_paths_full.csv') %>%
  distinct(step, px_re, px_im, py_re, py_im, .keep_all = TRUE)


df_sols = df_bertrand %>%
  group_by(path_id) %>%
  filter(step == max(step)) %>%
  ungroup()

solutions = df_sols |>
  filter(abs(px_im) < 1e+3, abs(py_im) < 1e+3, abs(py_re) < 1e+3, abs(px_re) < 1e+3) %>%
  filter(z_re >= 0.1, py_re >= 0.1)

print(solutions)


ggplot(df_bertrand, aes(x = px_re, y = px_im)) +
  geom_path(arrow = arrow(type = "closed", length = unit(0.1, "inches"))) +
  geom_point(alpha = 0.5) +
  theme_minimal() +
  labs(title = "Complex Path Trajectory of X",
       x = "Real(x)", y = "Imag(x)",
       color = "Path ID")

ggplot(df_bertrand, aes(x = py_re, y = py_im)) +
  geom_path(arrow = arrow(type = "closed", length = unit(0.1, "inches"))) +
  geom_point(alpha = 0.5) +
  theme_minimal() +
  labs(title = "Real Path Trajectory of X & Y",
       x = "Real(x)", y = "Real(y)",
       color = "Path ID")


fig <- plot_ly(df_bertrand, 
               x = ~px_re, 
               y = ~px_im, 
               z = ~step, 
               split = ~path_id, 
               type = 'scatter3d', 
               mode = 'lines',
               line = list(width = 5),
               opacity = 0.6) %>%
  layout(
    title = "Homotopy Continuation Paths: Price (px)",
    scene = list(
      xaxis = list(title = "Re(px)"),
      yaxis = list(title = "Im(px)"),
      zaxis = list(title = "Step")
    ),
    showlegend = FALSE # Set to TRUE if you want to identify individual paths
  )

# Display the plot
fig


fig_2 <- plot_ly(df_bertrand, 
               x = ~py_re, 
               y = ~z_re, 
               z = ~step, 
               split = ~path_id, 
               type = 'scatter3d', 
               mode = 'lines',
               line = list(width = 5),
               opacity = 0.6) %>%
  layout(
    title = "Homotopy Continuation Paths: Real Prices x,y",
    scene = list(
      xaxis = list(title = "Re(px)"),
      yaxis = list(title = "Re(py)"),
      zaxis = list(title = "Step")
    ),
    showlegend = FALSE # Set to TRUE if you want to identify individual paths
  )

fig_2

