# Fetch Norwegian wage data from SSB (Statistics Norway) via PxWebApiData
# Table 11418: Monthly earnings by industry, sex, and year

library(PxWebApiData)
library(dplyr)
library(readr)

fetch_wage_data <- function() {
  wages <- ApiData(
    "https://data.ssb.no/api/v0/en/table/11418",
    Tid          = TRUE,
    Kjonn        = TRUE,
    Yrke         = TRUE,
    ContentsCode = "Manedslonn",
    MaaleMetode  = "02",   # Average only (excludes counts and FTE)
    AvtaltVanlig = "0"     # All employees (excludes full-time/part-time split)
  )

  df <- wages[[1]]

  df <- df |>
    select(occupation, sex, year, earnings = value) |>
    mutate(
      year     = as.integer(year),
      earnings = as.numeric(earnings)
    ) |>
    filter(!is.na(earnings))

  dir.create("data", showWarnings = FALSE)
  write_csv(df, "data/wages.csv")
  message("Saved ", nrow(df), " rows to data/wages.csv")
  df
}

wages <- fetch_wage_data()
