# Project: Comparative Economic Growth Analysis

This project analyzes economic growth across three countries (Singapore, India, and Sri Lanka) representing different stages of development. It uses macroeconomic data and visualization techniques to identify key drivers of growth.

## Project Structure
*   `data/`: Contains the raw data files sourced from the World Bank and UNDP.
*   `scripts/`: Contains R scripts for data processing, analysis, and visualization.
*   `figures/`: Stores the generated plots and figures from the analysis (created when running `analysis.R`).
*   `requirements.txt`: Lists the R packages required to run the scripts.

## Data Sources and Preprocessing Steps

### Data Sources

1.  **World Bank World Development Indicators (WDI):** Data for GDP per capita growth, GDP growth, employment-to-population ratio, foreign direct investment inflows, inflation, population growth, exports of goods and services, GDP per capita, Gini index, and unemployment rates were downloaded from the World Bank's WDI database. The data covers the period from 1974 to 2023.
2.  **UNDP Human Development Report (HDR):** Data for the Human Development Index (HDI) was obtained from the UNDP HDR. The data spans from 1990 to 2022.

### Data Preprocessing Steps (Implemented in `scripts/data_cleaning.R`)

1.  **Data Loading:** The WDI and HDI data were loaded into R as data frames.
2.  **Data Cleaning:**
    *   Missing values were handled using linear interpolation. This method estimates missing data points based on existing values, ensuring a complete dataset for analysis. This was done using the `na.approx` function from the `zoo` package in R.
    *   Data was filtered to include only the relevant countries (Singapore, India, and Sri Lanka) and the specified time periods.
    *   Data was merged based on year to create a single dataset for analysis.
3.  **Data Transformation:** No major transformations were performed, but the data was formatted to be suitable for analysis and visualization in R.

## Instructions for Replicating the Work

1.  **Software Requirements:**
    *   R (version 4.0 or later recommended)
    *   RStudio (optional, but recommended for ease of use)

2.  **R Packages:** Install the necessary R packages. You can install them by running the following code in your R console or R script:

```R
if(!require(tidyverse)){install.packages("tidyverse")}
if(!require(zoo)){install.packages("zoo")}
if(!require(corrplot)){install.packages("corrplot")}

library(tidyverse)
library(zoo)
library(corrplot)
