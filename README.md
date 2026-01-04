# **Endemic Channel and Moving Average Analysis for HFMD (2020–2025)**

## **Time-Series Surveillance Methods for Outbreak Monitoring**
 

# 📑 Overview

This repository demonstrates the application of two epidemiological time-series surveillance methods for monitoring Hand, Foot and Mouth Disease (HFMD) trends using routinely collected notification data from 2020 to June 2025.

The analysis compares:

- Endemic Channel Method

- Moving Average Trend Method

- Both approaches are widely used in public health surveillance to detect unusual increases in disease incidence and support early outbreak detection and situational awareness.

- All geographic identifiers have been fully anonymised, and the analysis is presented for methodological and educational purposes only.

# 🎯 Objectives

- Construct an endemic channel using historical HFMD data

- Visualise current-year HFMD trends against historical baselines

- Apply a 3-week moving average to smooth short-term fluctuations

- Compare the performance of endemic channel and moving average methods

- Quantify predictive accuracy using MAE and RMSE

- Demonstrate reproducible epidemiological surveillance workflows in R

# 📊 Data Description

- Disease: Hand, Foot and Mouth Disease (HFMD)

- Time unit: Epidemiological week

- Study period: 2020 – June 2025

- Baseline exclusion: Year 2022 (excluded from baseline calculations)

- Current year of interest: 2025


# 🧪 Methods
## 1. Endemic Channel Method

- Weekly HFMD counts aggregated by year

- Baseline calculated using historical years (excluding 2022)

- Thresholds defined as:

  - Mean

  - Upper Endemic Limit: Mean + 1 SD

  - Epidemic Threshold: Mean + 2 SD

  - Current-year cases overlaid for comparison

## 2. Moving Average Method

- 3-week centred moving average applied to:

- Current-year weekly cases

- Historical weekly means

- Used to smooth short-term variation and identify sustained trends

## 3. Comparative Evaluation

- Visual comparison between:

- Endemic channel mean

- Historical moving average

- Current-year observed cases

- Error metrics computed:

  - Mean Absolute Error (MAE)

  - Root Mean Squared Error (RMSE)

# 📈 Outputs

The analysis produces:

- Endemic channel plots with alert zones

- Moving average trend plots

- Historical vs current-year comparisons

- Combined endemic channel vs moving average visualisation

- Error comparison table (MAE & RMSE)

# 🛠️ Software & Packages
## R Environment

- R (≥ 4.0)

## Key R Packages

- Data manipulation: dplyr, tidyverse, tidyr, janitor

- Date handling: lubridate

- Epidemiology: epiCo, incidence

- Visualisation: ggplot2

- Time-series smoothing: zoo

- Data import: readr, readxl

- Reporting: knitr

# 🔁 Reproducibility

- All analyses are scripted in R 

- Weekly aggregation and thresholds are calculated programmatically

- Moving averages use consistent window sizes

- Results can be fully reproduced by running the .qmd or .R files

# 📌 Interpretation Notes

- The endemic channel is more sensitive to abrupt deviations from historical norms

- The moving average provides smoother trend detection but may lag rapid changes

- Error metrics help quantify which method better approximates observed trends

- Methods are complementary and best used together in routine surveillance

# ⚠️ Disclaimer

- This repository is intended for educational and methodological demonstration only.
- All data are anonymised, and results must not be interpreted as official surveillance outputs or used for policy decision-making.


# 📜 License

- This repository is released under the MIT License.
- You are free to use, adapt, and redistribute the code with appropriate citation.

# 👤 Author

Dr AZuSA
Public Health & Epidemiological Analytics
