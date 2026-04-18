library(dplyr)
library(ggplot2)
library(readr)

wages <- read_csv("data/wages.csv")

# --- Trend over time by sex ---
wages |>
  filter(sex != "Both sexes") |>
  group_by(year, sex) |>
  summarise(avg_earnings = mean(earnings, na.rm = TRUE), .groups = "drop") |>
  ggplot(aes(year, avg_earnings, color = sex)) +
  geom_line(linewidth = 1) +
  geom_point() +
  scale_y_continuous(labels = scales::comma) +
  labs(
    title = "Average Monthly Earnings in Norway by Sex",
    subtitle = "Source: SSB Table 11418",
    x = NULL, y = "NOK per month", color = NULL
  ) +
  theme_minimal()

ggsave("output/earnings_by_sex.png", width = 8, height = 5)

# --- Top 10 industries by earnings (latest year) ---
latest_year <- max(wages$year)

wages |>
  filter(year == latest_year, sex == "Both sexes") |>
  slice_max(earnings, n = 10) |>
  mutate(occupation = reorder(occupation, earnings)) |>
  ggplot(aes(earnings, occupation)) +
  geom_col(fill = "#2171b5") +
  scale_x_continuous(labels = scales::comma) +
  labs(
    title = paste("Top 10 Industries by Monthly Earnings (", latest_year, ")", sep = ""),
    subtitle = "Source: SSB Table 11418",
    x = "NOK per month", y = NULL
  ) +
  theme_minimal()

ggsave("output/top_industries.png", width = 9, height = 5)

message("Plots saved to output/")
