# Norwegian Wage Analysis

Analysis of Norwegian monthly earnings by occupation and sex using open data from [Statistics Norway (SSB)](https://www.ssb.no/en).

## Data source

**SSB Table 11418** — Monthly earnings by occupation (NACE 2007), sex, and year.  
Fetched directly via the [PxWebApiData](https://cran.r-project.org/package=PxWebApiData) R package. Data covers average monthly earnings for all employees.

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
install.packages(c("PxWebApiData", "dplyr", "ggplot2", "readr", "scales", "tidyr"))

source("R/fetch_data.R")
source("R/analysis.R")
```

## Findings

### 1. Earnings over time by sex
Monthly earnings have increased significantly over the last 10 years for both men and women. The gender wage gap has remained mostly stable throughout, with little variation from the trend. Growth slowed noticeably between 2019 and 2020, likely reflecting the economic impact of COVID-19, but has since accelerated — growing faster each year than before 2019.

### 2. Top 10 highest paying occupations
Trade brokers stand out as the highest paid occupation by a significant margin. The top 10 are generally competitive, high-skill professions that command premium salaries.

### 3. Gender wage gap by occupation
In occupations where women earn more than men, the gap is small. However, in occupations where men earn more, the gap is considerably larger — with manual trades like truck drivers and metalworkers showing the biggest differences. Overall, where a wage gap exists, it still favours men by a much larger margin than where it favours women.

## Limitations

- SSB data is aggregated at the occupation level. Individual sample sizes (number of workers per occupation) are not available, so results should be interpreted with caution.
- Occupations with high standard deviation in earnings were excluded from the wage gap analysis, as a high SD indicates a broad category where the mean is not representative.
- Data covers average monthly earnings and does not account for hours worked, seniority, or education level.
