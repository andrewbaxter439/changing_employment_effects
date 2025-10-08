args <- commandArgs(trailingOnly = FALSE)

if ("--seed" %in% args) {
  seed <- as.integer(args[which(args == "--seed") + 1])
  cat("setting seed to ", seed, "\n")
  set.seed(seed)
} else if ("-s" %in% args){
  seed <- as.integer(args[which(args == "-s") + 1])
  cat("setting seed to ", seed, "\n")
  set.seed(seed)
} else {
  set.seed(150)
}

seed_addin <- ""

if ("--seed" %in% args | "-s" %in% args) seed_addin <- glue::glue("_{seed}")

here::here("R", "run_euromod_runs.R")

library(reticulate)
library(tidyverse)
library(here)

euromod <- import("euromod")

# unzip("UKMOD-PUBLIC-B2025.07.zip")

mod <- euromod$Model(here("UKMOD-PUBLIC-B2025.07"))

min_year <- 2026
max_year <- 2029

## ----ukmod-uprated-pop-5pc-----------------------------------------------------------------------------------------------------------
# 
# data_5pc <- read_tsv(here(glue::glue("data/matching_updated_pop_5pc{seed_addin}.txt")))
# 
# if (!dir.exists("output/uprated_5pc"))) dir.create("output/uprated_5pc")
# 
# walk(min_year:max_year, \(year) {
#   policy_system <- mod$countries['UK']$systems[glue::glue("UK_{year}")]
#   policy_system$run(
#     data_5pc,
#     "UK_2023_b1.txt",
#     outputpath = here("output/uprated_5pc")
#   )
# }, .progress = TRUE)



## ----ukmod-uprated-seeking_u25-5pc---------------------------------------------------------------------------------------------------

data_seeking_u25_5pc <- read_tsv(here(glue::glue("data/matching_updated_pop_seeking_u25_5pc{seed_addin}.txt")))

dir_out <- as.character(glue::glue("output/uprated_seeking_u25_5pc{seed_addin}"))

if (!dir.exists(dir_out)) dir.create(dir_out)

walk(min_year:max_year, \(year) {
  policy_system <- mod$countries['UK']$systems[glue::glue("UK_{year}")]
  policy_system$run(
    data_seeking_u25_5pc,
    "UK_2023_b1.txt",
    outputpath = here(dir_out)
  )
}, .progress = TRUE)



## ----ukmod-uprated-seeking_o25-5pc---------------------------------------------------------------------------------------------------

data_seeking_o25_5pc <- read_tsv(here(glue::glue("data/matching_updated_pop_seeking_o25_5pc{seed_addin}.txt")))

dir_out <- as.character(glue::glue("output/uprated_seeking_o25_5pc{seed_addin}"))

if (!dir.exists(dir_out)) dir.create(dir_out)

walk(min_year:max_year, \(year) {
  policy_system <- mod$countries['UK']$systems[glue::glue("UK_{year}")]
  policy_system$run(
    data_seeking_o25_5pc,
    "UK_2023_b1.txt",
    outputpath = here(dir_out)
  )
}, .progress = TRUE)



## ----ukmod-uprated-sick_or_disabled_u25-5pc------------------------------------------------------------------------------------------

data_sick_or_disabled_u25_5pc <- read_tsv(here(glue::glue("data/matching_updated_pop_sick_or_disabled_u25_5pc{seed_addin}.txt")))

dir_out <- as.character(glue::glue("output/uprated_sick_or_disabled_u25_5pc{seed_addin}"))

if (!dir.exists(dir_out)) dir.create(dir_out)

walk(min_year:max_year, \(year) {
  policy_system <- mod$countries['UK']$systems[glue::glue("UK_{year}")]
  policy_system$run(
    data_sick_or_disabled_u25_5pc,
    "UK_2023_b1.txt",
    outputpath = here(dir_out)
  )
}, .progress = TRUE)



## ----ukmod-uprated-sick_or_disabled_o25-5pc------------------------------------------------------------------------------------------

data_sick_or_disabled_o25_5pc <- read_tsv(here(glue::glue("data/matching_updated_pop_sick_or_disabled_o25_5pc{seed_addin}.txt")))

dir_out <- as.character(glue::glue("output/uprated_sick_or_disabled_o25_5pc{seed_addin}"))

if (!dir.exists(dir_out)) dir.create(dir_out)

walk(min_year:max_year, \(year) {
  policy_system <- mod$countries['UK']$systems[glue::glue("UK_{year}")]
  policy_system$run(
    data_sick_or_disabled_o25_5pc,
    "UK_2023_b1.txt",
    outputpath = here(dir_out)
  )
}, .progress = TRUE)

