library(tidyverse)
library(tidyr)
library(plotly)

setwd("~/Programming/homotopycontinuation-econ")
df_econ <- read.csv("stackelberg_paths_final.csv")

# (The one that ends with q1 > 0 and q2 > 0)
economic_path_id <- df_econ %>%
  group_by(path_id) %>%
  filter(step == max(step)) %>%
  filter(q1_re > 0 & q2_re > 0 & abs(q1_im) < 1e-4) %>%
  pull(path_id)

# create the 3D Plot, wtf
plot_ly(df_econ, x = ~q1_re, y = ~q2_re, z = ~step, 
        split = ~path_id, type = 'scatter3d', mode = 'lines',
        line = list(width = 3), opacity = 0.4, name = "Mathematical Paths") %>%
  # highlight the paths in a different color
  add_trace(data = filter(df_econ, path_id %in% economic_path_id),
            x = ~q1_re, y = ~q2_re, z = ~step,
            type = 'scatter3d', mode = 'lines+markers',
            line = list(width = 8, color = "forestgreen"),
            marker = list(size = 2, color = "forestgreen"),
            opacity = 1, name = "Economic Equilibrium Path") %>%
  layout(title = "Stackelberg Path Trace: Solver Convergence to Equilibrium",
         scene = list(xaxis = list(title = 'Leader Output (q1)'),
                      yaxis = list(title = 'Follower Output (q2)'),
                      zaxis = list(title = 'Homotopy Step')))

# Reshape data to plot q1 and q2 in separate panels
df_long <- df_econ %>%
  pivot_longer(cols = c(q1_re, q2_re), names_to = "Variable", values_to = "Value")

ggplot(df_long, aes(x = step, y = Value, color = as.factor(path_id), group = path_id)) +
  geom_line(alpha = 0.6) +
  facet_wrap(~Variable, scales = "free_y") +
  theme_minimal() +
  labs(title = "Convergence of Leader (q1) and Follower (q2)",
       subtitle = "Straight lines indicate a very 'easy' path for the solver",
       x = "Solver Step", y = "Output Quantity",
       color = "Path ID")

