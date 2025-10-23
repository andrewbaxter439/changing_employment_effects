run_euromod <- function(seed = NULL, min_year = 2026, max_year = 2026, match_files = "matching_uprated_pop", .model = "UKMOD-PUBLIC-B2025.07") {
  
  
  
  seed_addin <- ""
  
  if (!is.null(seed)) {
    seed_addin <- glue::glue("_{seed}")
    set.seed(seed)
  }
  
  here::here("R", "run_euromod_runs.R")
  
  library(reticulate)
  library(tidyverse)
  library(here)
  
  # source_python("py/init_dotnet.py")
  
  euromod <- import("euromod")
  
  
  mod <- euromod$Model(here(.model))
  
  ## ----ukmod-uprated-pop-5pc-----------------------------------------------------------------------------------------------------------
  # 
  # data_5pc <- read_tsv(here(glue::glue("data/{match_files}_5pc{seed_addin}.txt")))
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
  
  data_seeking_u25_5pc <- read_tsv(here(glue::glue("data/{match_files}_seeking_u25_5pc{seed_addin}.txt")))
  
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
  
  data_seeking_o25_5pc <- read_tsv(here(glue::glue("data/{match_files}_seeking_o25_5pc{seed_addin}.txt")))
  
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
  
  data_sick_or_disabled_u25_5pc <- read_tsv(here(glue::glue("data/{match_files}_sick_or_disabled_u25_5pc{seed_addin}.txt")))
  
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
  
  data_sick_or_disabled_o25_5pc <- read_tsv(here(glue::glue("data/{match_files}_sick_or_disabled_o25_5pc{seed_addin}.txt")))
  
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
  
  return(TRUE)
  
}


# if (!interactive()) {
#   args <- commandArgs(trailingOnly = FALSE)
#   
#   if ("--seed" %in% args) {
#     seed <- as.integer(args[which(args == "--seed") + 1])
#     cat("setting seed to ", seed, "\n")
#   } else if ("-s" %in% args){
#     seed <- as.integer(args[which(args == "-s") + 1])
#     cat("setting seed to ", seed, "\n")
#   } else {
#     seed <- NULL
#   }
#   
#   run_euromod(seed, min_year = 2026, max_year = 2029)
# }
