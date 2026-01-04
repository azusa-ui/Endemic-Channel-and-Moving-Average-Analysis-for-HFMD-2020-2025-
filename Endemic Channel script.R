---
  title: "Endemic Channel HFMD XXX 2020-june2025"
author: "AZuSA"
date: "`r Sys.Date()`"
output:
  pdf_document:
  toc: true
html_document:
  toc: true
toc_float: true
number_sections: true
theme: united
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Introduction

This analysis compares two time-series methods used for monitoring HFMD cases in XXX from 2020 to June 2025:
  
  Endemic Channel Method

Moving Average Trend Method

Year 2022 was excluded from all baseline calculations.

## Load Libraries


```{r}
library(dplyr)
library(lubridate)
library(ggplot2)
library(epiCo)
library(incidence)
library(readr)
library(readxl)
library(janitor)
library(tidyverse)
library(tidyr)
library(zoo)
```

## Load and Clean Data

```{r, echo=FALSE}
df <- read_excel("C:/Users/User/Desktop/Practice with R/Endemic channel/enotis hfmd 2020_2024.xls") %>% 
  clean_names() %>%
  filter(!if_all(everything(), ~ is.na(.) | str_trim(as.character(.)) == ""))

df1 <- df %>%
  select(
    week = epid_minggu_tkh_daftar,
    date = tarikh_onset,
    outbreak_status = klasifikasi_kejadian
  ) %>%
  mutate(year = year(date))
```

## Weekly Aggregation and Endemic Channel Calculation


```{r}
weekly_cases <- df1 %>%
  group_by(week, year) %>%
  summarise(cases = n(), .groups = "drop")

endemic_channel <- weekly_cases %>%
  filter(year != 2022) %>%
  group_by(week) %>%
  summarise(
    mean_cases = mean(cases, na.rm = TRUE),
    sd_cases = sd(cases, na.rm = TRUE),
    upper_endemic = mean_cases + sd_cases,
    epidemic_threshold = mean_cases + 2 * sd_cases,
    .groups = "drop"
  )

current_year <- 2025
current_data <- weekly_cases %>%
  filter(year == current_year) %>%
  select(week, current_cases = cases)

comparison <- endemic_channel %>%
  left_join(current_data, by = "week")

```

## Plot: Endemic Channel
```{r}
ggplot(comparison, aes(x = week)) +
  geom_ribbon(aes(ymin = upper_endemic, ymax = epidemic_threshold), fill = "red", alpha = 0.8) +
  geom_ribbon(aes(ymin = mean_cases, ymax = upper_endemic), fill = "gold", alpha = 0.8) +
  geom_line(aes(y = mean_cases), color = "darkgray", size = 0.8, linetype = "dashed") +
  geom_line(aes(y = current_cases), color = "navy", size = 1.5) +
  geom_point(aes(y = current_cases), color = "navy", size = 1.2) +
  scale_x_continuous(breaks = seq(1, 52, by = 2)) +
  labs(
    title = paste("Endemic Channel (HFMD)", current_year),
    subtitle = "Based on historical data (2020–2024, excluding 2022)",
    x = "Week",
    y = "HFMD Cases"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold"),
    plot.subtitle = element_text(size = 11),
    axis.text.x = element_text(angle = 0, vjust = 0.5),
    legend.position = "none"
  )

```

## Moving Average (2025 Cases Only)

```{r}
comparison <- comparison %>%
  arrange(week) %>%
  mutate(moving_avg = zoo::rollapply(current_cases, width = 3, FUN = mean, fill = NA, align = "center"))

ggplot(comparison, aes(x = week)) +
  geom_line(aes(y = current_cases), color = "black", size = 1) +
  geom_line(aes(y = moving_avg), color = "blue", size = 1.4, linetype = "twodash") +
  labs(
    title = paste("Moving Average Trend of HFMD Cases -", current_year),
    subtitle = "3-week centered moving average vs. actual weekly cases",
    x = "Epidemiological Week",
    y = "HFMD Cases"
  ) +
  scale_x_continuous(breaks = seq(1, 52, by = 2)) +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(face = "bold"))

```

## Historical Moving Average vs 2025


```{r}
historical_ma <- weekly_cases %>%
  filter(year != 2022 & year != current_year) %>%
  group_by(week) %>%
  summarise(hist_mean = mean(cases, na.rm = TRUE), .groups = "drop") %>%
  arrange(week) %>%
  mutate(hist_ma = zoo::rollapply(hist_mean, width = 3, FUN = mean, fill = NA, align = "center"))

current_cases <- weekly_cases %>%
  filter(year == current_year) %>%
  select(week, current_cases = cases)

comparison_ma <- historical_ma %>%
  left_join(current_cases, by = "week")

comparison_ma_long <- comparison_ma %>%
  select(week, hist_ma, current_cases) %>%
  pivot_longer(cols = c(hist_ma, current_cases), names_to = "type", values_to = "cases") %>%
  mutate(
    type = factor(type, levels = c("hist_ma", "current_cases"),
                  labels = c("Historical Moving Average (2020–2024, excl. 2022)", "Current Year Cases (2025)"))
  )

ggplot(comparison_ma_long, aes(x = week, y = cases, color = type, linetype = type)) +
  geom_line(size = 1.4) +
  geom_point(data = filter(comparison_ma_long, type == "Current Year Cases (2025)"),
             size = 1.2) +
  scale_color_manual(values = c("Historical Moving Average (2020–2024, excl. 2022)" = "blue",
                                "Current Year Cases (2025)" = "red")) +
  scale_linetype_manual(values = c("Historical Moving Average (2020–2024, excl. 2022)" = "dashed",
                                   "Current Year Cases (2025)" = "solid")) +
  labs(
    title = "Comparison of HFMD Cases: 3-Week Moving Average (Past) vs 2025",
    subtitle = "Smoothed historical trend vs actual weekly cases",
    x = "Epidemiological Week",
    y = "Number of HFMD Cases",
    color = "Legend",
    linetype = "Legend"
  ) +
  scale_x_continuous(breaks = seq(1, 52, by = 2)) +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(face = "bold"), legend.position = "bottom")

```
## Compare MA & EC

```{r}
# Assuming 'comparison' already has current_cases, mean_cases, and hist_ma
comparison$hist_ma <- zoo::rollapply(comparison$mean_cases, width = 3, FUN = mean, fill = NA, align = "center")

ggplot(comparison, aes(x = week)) +
  geom_ribbon(aes(ymin = mean_cases, ymax = upper_endemic), fill = "yellow", alpha = 0.3) +
  geom_ribbon(aes(ymin = upper_endemic, ymax = epidemic_threshold), fill = "red", alpha = 0.3) +
  geom_line(aes(y = hist_ma, color = "Moving Average"), size = 1, linetype = "dashed") +
  geom_line(aes(y = mean_cases, color = "Endemic Channel Mean"), size = 1, linetype = "solid") +
  geom_line(aes(y = current_cases, color = "2025 Cases"), size = 1.2) +
  scale_color_manual(values = c("2025 Cases" = "black", "Moving Average" = "blue", "Endemic Channel Mean" = "darkgreen")) +
  labs(
    title = "Visual Comparison: Endemic Channel vs Moving Average",
    x = "Week", y = "HFMD Cases", color = "Legend"
  ) +
  theme_minimal(base_size = 14)
```

## Error Metrics: Endemic vs Moving Average
```{r}
comparison <- comparison %>%
  mutate(
    hist_ma = zoo::rollapply(mean_cases, width = 3, FUN = mean, fill = NA, align = "center"),
    error_endemic = abs(current_cases - mean_cases),
    error_ma = abs(current_cases - hist_ma),
    squared_error_endemic = (current_cases - mean_cases)^2,
    squared_error_ma = (current_cases - hist_ma)^2
  )

error_table <- comparison %>%
  summarise(
    `MAE_Endemic` = round(mean(error_endemic, na.rm = TRUE), 2),
    `RMSE_Endemic` = round(sqrt(mean(squared_error_endemic, na.rm = TRUE)), 2),
    `MAE_MA` = round(mean(error_ma, na.rm = TRUE), 2),
    `RMSE_MA` = round(sqrt(mean(squared_error_ma, na.rm = TRUE)), 2)
  ) %>%
  pivot_longer(cols = everything(), names_to = "Metric", values_to = "Value") %>%
  separate(Metric, into = c("Metric", "Method"), sep = "_") %>%
  pivot_wider(names_from = "Method", values_from = "Value")

knitr::kable(error_table, caption = "Table: Forecast Error Comparison between Endemic Channel and Moving Average")

```

Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.
