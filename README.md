# Project: Comparative Economic Growth Analysis

This project analyzes economic growth across three countries (Singapore, India, and Sri Lanka) representing different stages of development. It uses macroeconomic data and visualization techniques to identify key drivers of growth.

## Project Structure

*   `R_Script_Macro.R`: Contains R scripts for data processing, analysis, and visualization.
*   `figures/`: Stores the generated plots and figures from the analysis.
*   `Instructions for Replicating the Work`: Lists the R packages required to run the scripts.



## Data Sources and Preprocessing Steps

### Data Sources

1.  **World Bank World Development Indicators (WDI):** Data for GDP per capita growth, GDP growth, employment-to-population ratio, foreign direct investment inflows, inflation, population growth, exports of goods and services, GDP per capita, Gini index, and unemployment rates were obtained from the World Bank's WDI database: [https://data.worldbank.org/indicator](https://data.worldbank.org/indicator). Data was collected from 1974 to 2023. To download the data:
    *   Go to the WDI website.
    *   Search for each of the indicators listed above.
    *   Select the countries: Singapore (SGP), India (IND), and Sri Lanka (LKA).
    *   Set the time period from 1974 to 2023.
    *   Download the data as a CSV file and save it as `WDI_data.csv` in the `data/` directory.
2.  **UNDP Human Development Report (HDR):** Data for the Human Development Index (HDI) was obtained from the UNDP HDR: [http://hdr.undp.org/en/data](http://hdr.undp.org/en/data). Data was collected from 1990 to 2022. To download the data:
    *   Go to the HDR website.
    *   Download the HDI data (usually available as an Excel or CSV file).
    *   Extract the data for Singapore, India, and Sri Lanka, ensuring the file contains the Code, Year, and Human Development Index.
    *   Save the extracted data as `HDI_data.csv` in the `data/` directory.

### Data Preprocessing Steps

1.  **Data Loading:** The WDI and HDI data were loaded into R using `read.csv()`.
2.  **Filtering and Selecting Data:** The data was filtered to include only Singapore (SGP), India (IND), and Sri Lanka (LKA) and the relevant indicators were selected for analysis.
3.  **Merging Data:** The WDI and HDI datasets were merged by country code and year using the `merge()` function in R with `all=TRUE` to ensure all data was included.
4.  **Missing Value Handling:** Missing values in the merged dataset were imputed using linear interpolation with the `na.approx()` function from the `zoo` package.

 ## Instructions for Replicating the Work

1.  **Software Requirements:**
    *   R (version 4.2.0 or later recommended): [https://www.r-project.org/](https://www.r-project.org/)
    *   RStudio (recommended IDE): [https://www.rstudio.com/products/rstudio/download/](https://www.rstudio.com/products/rstudio/download/)

2.  **R Packages:**
    The following R packages are required. Install them by running this code in R:


```r
library(tidyverse)
library(readxl)
library(ggplot2)
library(dplyr)
library(zoo)
library(GGally)

**Expected Output:**
 Running the analysis script will generate several plots  including a line plot of GDP per capita growth for each country and correlation plots.

