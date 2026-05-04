library(tidyverse)
library(plotly)
setwd("~/Programming/homotopycontinuation-econ")
df <- read.csv("homotopy_test_traces.csv")

# plot x_real vs x_imag for all 4 paths
ggplot(df, aes(x = x_real, y = x_imag, color = as.factor(path_id), group = path_id)) +
  geom_path(arrow = arrow(type = "closed", length = unit(0.1, "inches"))) +
  geom_point(alpha = 0.5) +
  theme_minimal() +
  labs(title = "Complex Path Trajectory of X",
       x = "Real(x)", y = "Imag(x)",
       color = "Path ID")

# same thing but for y
ggplot(df, aes(x = y_real, y = y_imag, color = as.factor(path_id), group = path_id)) +
  geom_path(arrow = arrow(type = "closed", length = unit(0.1, "inches"))) +
  geom_point(alpha = 0.5) +
  theme_minimal() +
  labs(title = "Complex Path Trajectory of Y",
       x = "Real(y)", y = "Imag(y)",
       color = "Path ID")

library(tidyr)

# Pivot data to compare x and y side-by-side
df_long <- pivot_longer(df, cols = c(x_real, y_real), names_to = "Variable", values_to = "Value")

ggplot(df_long, aes(x = step, y = Value, color = as.factor(path_id))) +
  geom_line() +
  facet_wrap(~Variable) +
  theme_light() +
  labs(title = "Convergence of Real Parts per Step",
       x = "Step Number", y = "Coordinate Value")


plot_ly(df, x = ~x_real, y = ~y_real, z = ~step, 
        split = ~path_id, type = 'scatter3d', mode = 'lines',
        line = list(width = 5)) %>%
  layout(title = "3D Real Evolution: X and Y vs. Time",
         scene = list(xaxis = list(title = 'Re(x)'),
                      yaxis = list(title = 'Re(y)'),
                      zaxis = list(title = 'Step (Time)')))

plot_ly(df) %>%
  # trace for X
  add_trace(x = ~x_real, y = ~x_imag, z = ~step, 
            split = ~path_id, type = 'scatter3d', mode = 'lines',
            name = ~paste("Path", path_id, "(x)"),
            line = list(dash = 'solid')) %>%
  # trace for Y
  add_trace(x = ~y_real, y = ~y_imag, z = ~step, 
            split = ~path_id, type = 'scatter3d', mode = 'lines',
            name = ~paste("Path", path_id, "(y)"),
            line = list(dash = 'dot')) %>%
  layout(title = "Complex Evolution of X (solid) and Y (dotted)",
         scene = list(xaxis = list(title = 'Real Part'),
                      yaxis = list(title = 'Imaginary Part'),
                      zaxis = list(title = 'Step')))


# create the plot for x
p1 <- plot_ly(df, x = ~x_real, y = ~x_imag, z = ~step, 
              split = ~path_id, type = 'scatter3d', mode = 'lines',
              line = list(width = 4), showlegend = FALSE) %>%
  layout(scene = list(xaxis = list(title = 'Re(x)'),
                      yaxis = list(title = 'Im(x)'),
                      zaxis = list(title = 'Step')))

# create the plot for y separately
p2 <- plot_ly(df, x = ~y_real, y = ~y_imag, z = ~step, 
              split = ~path_id, type = 'scatter3d', mode = 'lines',
              line = list(width = 4), showlegend = TRUE) %>%
  layout(scene = list(xaxis = list(title = 'Re(y)'),
                      yaxis = list(title = 'Im(y)'),
                      zaxis = list(title = 'Step')))

# combine
fig <- subplot(p1, p2, margin = 0.05) %>%
  layout(title = "Complex Path Evolution: Variable X (Left) vs Variable Y (Right)",
         scene = list(domain = list(x = c(0, 0.45))),
         scene2 = list(domain = list(x = c(0.55, 1)),
                       xaxis = list(title = 'Re(y)'),
                       yaxis = list(title = 'Im(y)'),
                       zaxis = list(title = 'Step')))

fig