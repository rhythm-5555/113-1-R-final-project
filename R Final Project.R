library(tidyverse)
glimpse(data)

# Rename columns for better readability
data <- data %>%
  rename(
    country = `國別`,
    year = `西元年`,
    category = `類別`,
    population_65_plus_pct = `65歲以上人口占總人口比率(%)`,
    description = `資料說明`,
    source = `資料來源`
  )

