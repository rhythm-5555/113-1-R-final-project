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

# Parse variables to factor class
data <- data %>%
  mutate(
    country = factor(country),
    category = factor(category),
    description = factor(description),
    source = factor(source)
  )

# Clean and filter data for Taiwan and Japan
data_filtered <- data %>%
  mutate(
    population_65_plus_pct = as.numeric(population_65_plus_pct)  # Convert to numeric
  ) %>%
  filter(country %in% c("中華民國", "日本"))  # Filter for Taiwan and Japan


# Add `status` column to indicate Actual or Estimated data
data_filtered <- data_filtered %>%
  mutate(
    status = if_else(year <= 2020, "Actual", "Estimated")  # Categorize data
  )

# Parse `status` to factor class
data_filtered <- data_filtered %>%
  mutate(
    status = factor(status)
)

# Add a duplicate row for 2020 marked as "Estimated" to create a dotted connection
data_extended <- data_filtered %>%
  bind_rows(
    data_filtered %>%
      filter(year == 2020) %>%
      mutate(status = "Estimated")
  )

# Visualization
ggplot(data_extended, aes(x = year, y = population_65_plus_pct, color = country)) +
  geom_line(aes(linetype = status), size = 1) +  # Line type based on Actual or Estimated
  geom_point(size = 2) +  # Show dots for all data
  scale_linetype_manual(values = c("Actual" = "solid", "Estimated" = "dotted")) +
  labs(
    title = "Comparison of Population Aged 65+ Between Taiwan and Japan",
    x = "Year",
    y = "Population Aged 65+ (%)",
    color = "Country",
    linetype = "Data Type"
  ) +
  theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 16),
    axis.text = element_text(size = 12),
    axis.title = element_text(size = 14),
    legend.title = element_text(size = 12)
  )

glimpse(data_filtered)