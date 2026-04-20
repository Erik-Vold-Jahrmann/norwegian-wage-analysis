library(dplyr)
library(ggplot2)
library(readr)

wages <- read_csv("data/wages.csv")

# --- Trend over time by sex ---
wages |>
  filter(sex != "Both sexes", occupation == "All occupations", sector == "Sum all sectors") |>
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
  filter(
    year == latest_year,
    sex == "Both sexes",
    sector == "Sum all sectors",
    !occupation %in% c("All occupations", "Unspecified or unidentifiable occupations")
  ) |>
  group_by(occupation) |>
  summarise(avg_earnings = mean(earnings, na.rm = TRUE), .groups = "drop") |>
  slice_max(avg_earnings, n = 10) |>
  mutate(occupation = reorder(occupation, avg_earnings)) |>
  ggplot(aes(avg_earnings, occupation)) +
  geom_col(fill = "#2171b5") +
  scale_x_continuous(labels = scales::comma) +
  labs(
    title = paste("Top 10 Industries by Monthly Earnings (", latest_year, ")", sep = ""),
    subtitle = "Source: SSB Table 11418",
    x = "NOK per month", y = NULL
  ) +
  theme_minimal()

ggsave("output/top_industries.png", width = 9, height = 5)

# --- Gender wage gap (filtered by SD <= 30000 for reliability) ---
wage_gap <- wages |>                                    
  filter(year == latest_year, sex != "Both sexes", sector == "Sum all sectors") |>  
  group_by(occupation, sex) |>
  summarise(
    avg_earnings = mean(earnings, na.rm = TRUE),
    sd_earnings  = sd(earnings, na.rm = TRUE),
    .groups = "drop"
  ) |>
  tidyr::pivot_wider(
    names_from  = sex,
    values_from = c(avg_earnings, sd_earnings)
  ) |>
  mutate(gap = avg_earnings_Males - avg_earnings_Females) |>
  filter(
    !is.na(gap),
    sd_earnings_Males   <= 30000,
    sd_earnings_Females <= 30000
  ) |>
  arrange(desc(gap))

top_men   <- wage_gap |> slice_max(gap, n = 5)
top_women <- wage_gap |> slice_min(gap, n = 5)

plot_data <- bind_rows(top_men, top_women) |>
  mutate(
    occupation = reorder(occupation, gap),
    direction  = ifelse(gap > 0, "Men earn more", "Women earn more"),
    hjust      = ifelse(gap > 0, -0.1, 1.1)
  )

ggplot(plot_data, aes(gap, occupation, fill = direction)) +
  geom_col() +
  geom_vline(xintercept = 0, linewidth = 0.5) +
  geom_text(aes(label = scales::comma(round(gap)), hjust = hjust), size = 3) +
  scale_fill_manual(values = c("Men earn more" = "#2171b5", "Women earn more" = "#d7191c")) +
  scale_x_continuous(
    labels = scales::comma,
    limits = c(-65000, 50000),
    breaks = c(-45000, -15000, 0, 15000, 30000, 45000),
    name   = "\u2190 Women earn more                          Men earn more \u2192"
  ) +
  labs(
    title    = "Occupations with the biggest gender wage gap",
    subtitle = paste("Top 5 occupations where each sex earns more (", latest_year, ", NOK per month)", sep = ""),
    y = NULL, fill = NULL
  ) +
  theme_minimal() +
  theme(
    legend.position     = "bottom",
    axis.title.x        = element_text(hjust = 0.5)
  )

ggsave("output/wage_gap.png", width = 10, height = 6)

sector_gap <- wages |>                                    
  filter(year == latest_year, sex != "Both sexes") |>
  group_by(occupation, sector, sex) |>                    
  summarise(                                              
    avg_earnings = mean(earnings, na.rm = TRUE),          
    sd_earnings  = sd(earnings, na.rm = TRUE),            
    .groups = "drop"
  ) |>                                                    
  tidyr::pivot_wider(                                   
    names_from  = sex,
    values_from = c(avg_earnings, sd_earnings)
  ) |>                                                    
  mutate(gap = avg_earnings_Males - avg_earnings_Females) |>                                                        
  filter(                                               
    !is.na(gap),
    sd_earnings_Males   <= 30000,
    sd_earnings_Females <= 30000
  ) |>                                                    
  arrange(desc(gap))

sector_gap |>                                             
  group_by(sector) |>                                     
  summarise(avg_gap = mean(gap, na.rm = TRUE)) |>         
  filter(sector != "Sum all sectors") |>                  
  mutate(sector = reorder(sector, avg_gap)) |>
  ggplot(aes(avg_gap, sector)) +                          
  geom_col(fill = "steelblue") +                          
  scale_x_continuous(labels = scales::comma) +
  labs(                                                   
    title = "Average gender wage gap by sector in Norway",
    x = "NOK per month", y = NULL                         
  ) +
  theme_minimal()                                         

ggsave("output/sector_gap.png", width = 8, height = 4) 

message("Plots saved to output/")

