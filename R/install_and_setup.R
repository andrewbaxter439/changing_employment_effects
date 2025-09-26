here::i_am("R/install_and_setup.R")

library(here)

download.file("https://www.microsimulation.ac.uk/wp-content/uploads/2025/09/UKMOD-PUBLIC-B2025.07.zip",
              destfile = "UKMOD-PUBLIC-B2025.07.zip")

unzip(here("UKMOD-PUBLIC-B2025.07.zip"))



# start run bits ----------------------------------------------------------


library(reticulate)
library(tidyverse)

data <- readr::read_tsv(here("data/UK_2023_a1.txt"))

euromod <- import("euromod")

mod <- euromod$Model(here("UKMOD-PUBLIC-B2025.07"))

if (!dir.exists("output/baseline")) dir.create("output/baseline")

purrr::walk(2026:2029, \(year) {
  policy_system <- mod$countries['UK']$systems[glue::glue("UK_{year}")]
  policy_system$run(
    data,
    "UK_2023_a.txt",
    outputpath = here("output/baseline")
  )
}, .progress = TRUE)
