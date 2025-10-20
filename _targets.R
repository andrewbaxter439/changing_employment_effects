# Created by use_targets().

# Load packages required to define the pipeline:
library(targets)
library(tarchetypes) # Load other packages as needed.

# Set target options:
tar_option_set(
  packages = c("renv") # Packages that your targets need for their tasks.
)

# Run the R scripts in the R/ folder with your custom functions:
tar_source()

list(
  tar_target(
    ukmod_setup,
    install_and_setup()
  ),
  tar_target(
    input_pops_file,
    "data/UK_2023_b1.txt",
    format = "file"
  ),
  tar_target(
    match_pops,
    make_pops_from_matches(input_pops_file)
  ),
  tar_target(
    run_models,
    run_euromod(match_files = match_pops, min_year = 2026, max_year = 2029,
                .model = ukmod_setup),
  ),
  tar_render(
    output_report,
    "estimating_the_impacts_of_changing_rates.qmd"
  )
)
