# Fetch Norwegian wage data from SSB (Statistics Norway) via PxWebApiData
# Table 11418: Monthly earnings by industry, sex, and year

library(PxWebApiData)
library(dplyr)
library(readr)

fetch_wage_data <- function() {
  wages <- ApiData(
    "https://data.ssb.no/api/v0/en/table/11418",
    Tid = TRUE,          # all years
    Kjonn = TRUE,        # all sexes
    NACE2007 = TRUE      # all industries
  )

  # ApiData returns a list; take the data frame element
  df <- wages[[1]]

  df <- df |>
    rename(
      industry = NACE2007,
      sex      = Kjonn,
      year     = Tid,
      earnings = value
    ) |>
    mutate(
      year     = as.integer(year),
      earnings = as.numeric(earnings)
    ) |>
    filter(!is.na(earnings))

  write_csv(df, "data/wages.csv")
  message("Saved ", nrow(df), " rows to data/wages.csv")
  df
}

wages <- fetch_wage_data()
