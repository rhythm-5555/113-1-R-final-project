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

# Clean and filter data for Taiwan and Japan
data_filtered <- data %>%
  mutate(
    population_65_plus_pct = as.numeric(population_65_plus_pct)  # Convert to numeric
  ) %>%
  filter(country %in% c("中華民國", "日本"))  # Filter for Taiwan and Japan

# Parse variables to factor class
data <- data %>%
  mutate(
    country = factor(country),
    category = factor(category),
    description = factor(description),
    source = factor(source)
  )

# Add `status` column to indicate Actual or Estimated data
data_filtered <- data_filtered %>%
  mutate(
    status = if_else(year <= 2020, "Actual", "Estimated")  # Categorize data
  )

# Add a duplicate row for 2020 marked as "Estimated" to create a dotted connection
data_extended <- data_filtered %>%
  bind_rows(
    data_filtered %>%
      filter(year == 2020) %>%
      mutate(status = "Estimated")
  )

