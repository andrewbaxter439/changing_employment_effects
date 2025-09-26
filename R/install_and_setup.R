here::i_am("R/install_and_setup.R")

library(here)
library(reticulate)
library(tidyverse)

data <- readr::read_tsv(here("data/UK_2023_a1.txt"))

euromod <- import("euromod")

download.file("https://www.microsimulation.ac.uk/wp-content/uploads/2025/09/UKMOD-PUBLIC-B2025.07.zip",
              destfile = "UKMOD-PUBLIC-B2025.07.zip")

unzip(here("UKMOD-PUBLIC-B2025.07.zip"))
