here::here("increasing_employment_rates.qmd")

library(reticulate)
library(tidyverse)
library(here)

euromod <- import("euromod")

unzip("UKMOD-PUBLIC-B2025.07.zip")

mod <- euromod$Model(here("UKMOD-PUBLIC-B2025.07"))

min_year <- 2026
max_year <- 2026

## ----ukmod-uprated-pop-5pc-----------------------------------------------------------------------------------------------------------

data_5pc <- read_tsv(here("data/matching_updated_pop_5pc.txt"))

if (!dir.exists("output/uprated_5pc")) dir.create("output/uprated_5pc")

walk(min_year:max_year, \(year) {
  policy_system <- mod$countries['UK']$systems[glue::glue("UK_{year}")]
  policy_system$run(
    data_5pc,
    "UK_2023_b1.txt",
    outputpath = here("output/uprated_5pc")
  )
}, .progress = TRUE)



## ----ukmod-uprated-seeking_u25-5pc---------------------------------------------------------------------------------------------------

data_seeking_u25_5pc <- read_tsv(here("data/matching_updated_pop_seeking_u25_5pc.txt"))

if (!dir.exists("output/uprated_seeking_u25_5pc")) dir.create("output/uprated_seeking_u25_5pc")

walk(min_year:max_year, \(year) {
  policy_system <- mod$countries['UK']$systems[glue::glue("UK_{year}")]
  policy_system$run(
    data_seeking_u25_5pc,
    "UK_2023_b1.txt",
    outputpath = here("output/uprated_seeking_u25_5pc")
  )
}, .progress = TRUE)



## ----ukmod-uprated-seeking_o25-5pc---------------------------------------------------------------------------------------------------

data_seeking_o25_5pc <- read_tsv(here("data/matching_updated_pop_seeking_o25_5pc.txt"))

if (!dir.exists("output/uprated_seeking_o25_5pc")) dir.create("output/uprated_seeking_o25_5pc")

walk(min_year:max_year, \(year) {
  policy_system <- mod$countries['UK']$systems[glue::glue("UK_{year}")]
  policy_system$run(
    data_seeking_o25_5pc,
    "UK_2023_b1.txt",
    outputpath = here("output/uprated_seeking_o25_5pc")
  )
}, .progress = TRUE)



## ----ukmod-uprated-sick_or_disabled_u25-5pc------------------------------------------------------------------------------------------

data_sick_or_disabled_u25_5pc <- read_tsv(here("data/matching_updated_pop_sick_or_disabled_u25_5pc.txt"))

if (!dir.exists("output/uprated_sick_or_disabled_u25_5pc")) dir.create("output/uprated_sick_or_disabled_u25_5pc")

walk(min_year:max_year, \(year) {
  policy_system <- mod$countries['UK']$systems[glue::glue("UK_{year}")]
  policy_system$run(
    data_sick_or_disabled_u25_5pc,
    "UK_2023_b1.txt",
    outputpath = here("output/uprated_sick_or_disabled_u25_5pc")
  )
}, .progress = TRUE)



## ----ukmod-uprated-sick_or_disabled_o25-5pc------------------------------------------------------------------------------------------

data_sick_or_disabled_o25_5pc <- read_tsv(here("data/matching_updated_pop_sick_or_disabled_o25_5pc.txt"))

if (!dir.exists("output/uprated_sick_or_disabled_o25_5pc")) dir.create("output/uprated_sick_or_disabled_o25_5pc")

walk(min_year:max_year, \(year) {
  policy_system <- mod$countries['UK']$systems[glue::glue("UK_{year}")]
  policy_system$run(
    data_sick_or_disabled_o25_5pc,
    "UK_2023_b1.txt",
    outputpath = here("output/uprated_sick_or_disabled_o25_5pc")
  )
}, .progress = TRUE)

