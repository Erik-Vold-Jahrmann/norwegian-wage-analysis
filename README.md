# Norwegian Wage Analysis

Analysis of Norwegian monthly earnings by industry and sex using open data from [Statistics Norway (SSB)](https://www.ssb.no/en).

## Data source

**SSB Table 11418** — Monthly earnings, by industry (NACE 2007), sex, and year.  
Fetched directly via the [PxWebApiData](https://cran.r-project.org/package=PxWebApiData) R package.

## Project structure

```
R/
  fetch_data.R   # download and clean data from SSB API
  analysis.R     # plots and summary statistics
data/            # saved locally, not tracked by git
output/          # generated plots, not tracked by git
```

## How to run

```r
# Install dependencies
install.packages(c("PxWebApiData", "dplyr", "ggplot2", "readr", "scales"))

# Fetch data
source("R/fetch_data.R")

# Run analysis
source("R/analysis.R")
```

## Key findings

- To be filled in after running the analysis.
