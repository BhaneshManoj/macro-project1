rm(list = ls())
library(readr)
Macro_Data <- read_csv("Macro_Data.csv")
install.packages("GGally")
#Load Necessary Libraries
library(tidyverse)
library(readxl)
library(ggplot2)
library(dplyr)
library(zoo)
library(GGally)

# Clean columns applying uniform non-numerics
columns_to_clean <- c("SGP_EmPopRatio", "IND_EmPopRatio", "LKA_EmPopRatio")

Macro_Data[columns_to_clean] <- lapply(Macro_Data[columns_to_clean], function(x) {
  as.numeric(as.character(x))})

# Columns to Interpolate
columns_to_interpolate <- c("SGP_HDI", "IND_HDI","LKA_HDI", "SGP_EmPopRatio", "IND_EmPopRatio", "LKA_EmPopRatio")

# Apply interpolation to each column last observed value
Macro_Data[columns_to_interpolate] <- lapply(Macro_Data[columns_to_interpolate], zoo::na.approx, rule = 2, na.rm = TRUE)

# Ensure Metric columns are numeric
Macro_Data <- Macro_Data %>%
  mutate(across(c(LKA_Exp, SGP_Gini, IND_Gini, LKA_Gini, SGP_Unemp, IND_Unemp, LKA_Unemp), ~ as.numeric(as.character(.))))

# Check the result
head(Macro_Data)
summary(Macro_Data)

# Transform data into long format
Macro_Data_Final <- Macro_Data %>%
  pivot_longer(
    cols = ends_with("GDPPCG") | ends_with("GDPG") | ends_with("HDI") | 
      ends_with("EmPopRatio") | ends_with("FDI") | ends_with("CPI") | 
      ends_with("PopG") | ends_with("Exp") | ends_with("GDPPC") | 
      ends_with("Gini") | ends_with("Unemp"),   
    names_to = c("Country", "Variable"),         
    names_sep = "_",                             
    values_to = "Value"                         
  ) %>%
  mutate(
    Country = substr(Country, 1, 3)  # Extract first 3 characters for the country tag
  ) %>%
  pivot_wider(                                   
    names_from = "Variable",                     
    values_from = "Value"                        
  )

# Check column names
colnames(Macro_Data_Final)

#Part 2

# Plot GDP per capita Growth by year for each country
ggplot(Macro_Data_Final, aes(x = Year, y = GDPPCG, color = Country)) +
  geom_line(linewidth = 1.3) +
  labs(
    title = "GDP Per Capita Growth (%)" ,
    x = "Year",
    y = "GDP per Capita Growth (%)",
    color = "Country"
  ) +
  theme_minimal() +
  scale_y_continuous(labels = scales::comma) +
  scale_x_continuous(breaks = seq(min(Macro_Data_Final$Year), max(Macro_Data_Final$Year), by = 5))


#Part 3

#Average GDP Growth
avg_gdp_growth <- Macro_Data_Final %>%
  group_by(Country, Year) %>%
  summarize(Average_GDP_Growth = mean(GDPG, na.rm = TRUE), .groups = "drop")

# View results
print(avg_gdp_growth)

# Plot average GDP growth by period
ggplot(avg_gdp_growth, aes(x = Year, y = Average_GDP_Growth, fill = Country)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(
    title = "Average GDP Growth by Period",
    x = "Period",
    y = "Average GDP Growth (%)",
    fill = "Country"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Add historical periods for each year
Macro_Data_Final <- Macro_Data_Final %>%
  mutate(
    Period = case_when(
      Year < 1991 ~ "Pre- 1991",
      Year >= 1991 & Year <= 2000 ~ "1991 - 2000",
      Year >= 2001 & Year <= 2008 ~ "2001 - 2008",
      Year >= 2009 & Year <= 2019 ~ "2009 - 2019",
      Year >= 2020 ~ "2020 - 2023"
    )
  )

# Filter the data for India and calculate the average GDP growth by period
avg_gdp_growth_india <- Macro_Data_Final %>%
  filter(Country == "IND") %>%
  group_by(Period) %>%
  summarize(Average_GDP_Growth = mean(GDPG, na.rm = TRUE), .groups = "drop")

# View results
print(avg_gdp_growth_india)

# Reorder Periods in a custom order
avg_gdp_growth_india <- avg_gdp_growth_india %>%
  mutate(
    Period = factor(Period, levels = c(
      "Pre- 1991", 
      "1991 - 2000", 
      "2001 - 2008", 
      "2009 - 2019", 
      "2020 - 2023"
    ))
  )


# Plot average GDP growth for India by period 
ggplot(avg_gdp_growth_india, aes(x = Period, y = Average_GDP_Growth, fill = "India")) +
  geom_bar(stat = "identity", position = "dodge", show.legend = FALSE) +
  geom_line(aes(group = 1), color = "blue", size = 1, linetype = "solid") +  # Add trend line
  geom_point(aes(color = "India"), size = 3) +  # Add points on the line
  labs(
    title = "Average GDP Growth by Period (India)",
    x = "Period",
    y = "Average GDP Growth (%)",
    fill = "Country",
    color = "Country"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Scatterplots to analyze variables and how it effects GDP Growth. (Part 4)
# Load necessary libraries
library(ggplot2)
library(tidyr)

# Select relevant variables
variables <- c("PopG", "FDI", "HDI", "CPI", "Gini", "Unemp", "Exp", "EmPopRatio")

# Reshape data to long format for easier plotting
data_long <- Macro_Data_Final %>%
  pivot_longer(cols = all_of(variables), names_to = "Variable", values_to = "Value")

# Loop through each country and create a plot
countries <- unique(data_long$Country)
for (country in countries) {
  # Filter data for the current country
  country_data <- data_long %>% filter(Country == country)
  
  # Create scatterplot grid
  plot <- ggplot(country_data, aes(x = Value, y = GDPG, color = Variable)) +
    geom_point(alpha = 0.6, size = 3) +
    geom_smooth(method = "lm", se = FALSE, linetype = "dashed", color = "black") +
    facet_wrap(~Variable, scales = "free", ncol = 3) +
    labs(
      title = paste("GDP Growth (GDPG) vs Variables for", country),
      x = "Variable Value",
      y = "GDP Growth (GDPG)"
    ) +
    theme_minimal() +
    theme(
      plot.title = element_text(hjust = 0.5, size = 10, face = "bold"),
      axis.text.x = element_text(angle = 45, hjust = 1, size = 10),
      axis.text.y = element_text(size = 10),
      axis.title = element_text(size = 10),
      strip.text = element_text(size = 10, face = "bold"),
      legend.position = "bottom"
    )
  
  # Print the plot
  print(plot)
}
