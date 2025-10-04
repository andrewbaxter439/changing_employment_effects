
# Read in data ------------------------------------------------------------

here::here("increasing_employment_rates.qmd")

library(reticulate)
library(tidyverse)
library(here)
library(fixest)

set.seed(150)


raw_data <- readr::read_tsv(here("data/UK_2023_b1.txt"))


data <- raw_data |>
  ## Group ages and ethnicity_collapsed
  mutate(
    age_collapsed = case_when(
      dag >= 16 & dag < 25 ~ 1,
      dag >= 25 & dag < 31 ~ 2,
      dag >= 31 & dag < 51 ~ 3,
      dag >= 51 & dag < 56 ~ 4,
      dag >= 56 ~ 5
    ),
    ethnicity_collapsed = case_when(
      dot %in% 1:4 ~ "White",
      dot %in% 5:8 ~ "Mixed",
      dot %in% 9:13 ~ "Asian",
      dot %in% 14:16 ~ "Black",
      dot == 17 ~ "Other",
      .default = "Missing"
    ),
    dms_collapsed = case_when(
      dms == 1 ~ "single",
      dms == 2 ~ "married",
      dms %in% 3:5 ~ "separated",
      .default = "single"
    ),
    deh_c3 = fct_collapse(
      factor(deh),
      "Low" = c(0:1),
      "Med" = c(2:4),
      "High" = 5
    ),
    enter_employment = 0
  ) |>
  mutate(n_ch = sum(dag < 17), .by = idhh) |>
  mutate(
    n_ch = case_when(n_ch == 0 ~ "0", n_ch == 1 ~ "1", n_ch > 1 ~ "2+"),
    unemployed = case_when(les == 3 ~ 0L, les %in% c(5, 7, 8) ~ 1L, .default = NA_integer_)
  )

employed_pop <- data |>
  ## All employed
  filter(les == 3, yem != 0, lhw != 0)

not_in_employment_pop <-  data |>
  ## Select unemployed, inactive, sick or disabled, working age
  filter(les %in% c(5, 7, 8), dag %in% 16:64, !is.na(dag)) |>
  mutate(
    seeking = les == 5,
    sick_or_disabled = les == 8,
    under_25 = age_collapsed == 1,
    enter_employment = 1
  )




# progressive matching ----------------------------------------------------


matches <- employed_pop |>
  select(
    les,
    lhw,
    yem,
    yds,
    bch,
    bsa,
    bho,
    lindi,
    lfs,
    age_collapsed, # age group
    dgn, # gender
    deh_c3, # education - 3 cat
    dms_collapsed, # marital status
    n_ch, # n kids (0, 1, or 2+)
    drgn1, # area
    dhr, # home responsible
    ddi03, # disabled
    lcr01,  # carer
    ethnicity_collapsed, # ethnicity
  )

unmatched_pop <- not_in_employment_pop |>
  select(-c(les, lhw, yem, yds, bch, bsa, bho, lindi, lfs))

find_matches <- function(unmatched_pop, matches = matches) {
  
  if(nrow(unmatched_pop) == 0) {
    return(unmatched_pop)
  }
  
  cat("Still to match", nrow(unmatched_pop), "rows\n")
  
  if(!("age_collapsed" %in% colnames(matches))) {
    browser()
    stop("No more matches to be found!")
  }
  
  rolling_match <- unmatched_pop |> 
    left_join(matches) 
  
  matched <- rolling_match |> 
    filter(n() >=5, .by = idperson)
  
  matched |> 
    bind_rows(
      unmatched_pop |>
        filter(!(idperson %in% matched$idperson)) |> 
        find_matches(matches |> select(-last_col()))
    )
}

output_matches <- find_matches(unmatched_pop, matches)


replacement_workers <- output_matches |> 
  slice_sample(n = 1, by = idperson)

## ----create-samples------------------------------------------------------------------------------------------------------------------

slice_weighted_sample <- function(data = replacement_workers, ..., prop = 0.05) {
  
  data |> 
    filter(...) |> 
    slice_sample(prop = 1) |> 
    mutate(.cum_dwt = cumsum(dwt)/sum(dwt)) |> 
    filter(.cum_dwt <= prop) |> 
    select(-.cum_dwt)
  
}

sample_workers_seeking <- replacement_workers |>
  slice_weighted_sample(seeking)

sample_workers_seeking_u25 <- replacement_workers |> 
  slice_weighted_sample(seeking, under_25)

sample_workers_seeking_o25 <- replacement_workers |> 
  slice_weighted_sample(seeking, !under_25)

sample_workers_sick_or_disabled_u25 <- replacement_workers |> 
  slice_weighted_sample(sick_or_disabled, under_25)

sample_workers_sick_or_disabled_o25 <- replacement_workers |> 
  slice_weighted_sample(sick_or_disabled, !under_25)

uprated_pop_5pc <- raw_data |> 
  filter(!(idperson %in% sample_workers_seeking$idperson)) |> 
  bind_rows(sample_workers_seeking) |> 
  arrange(idhh, idperson)

uprated_seeking_u25_5pc <- raw_data |> 
  filter(!(idperson %in% sample_workers_seeking_u25$idperson)) |> 
  bind_rows(sample_workers_seeking_u25) |> 
  arrange(idhh, idperson)

uprated_seeking_o25_5pc <- raw_data |> 
  filter(!(idperson %in% sample_workers_seeking_o25$idperson)) |> 
  bind_rows(sample_workers_seeking_o25) |> 
  arrange(idhh, idperson)

uprated_sick_or_disabled_u25_5pc <- raw_data |> 
  filter(!(idperson %in% sample_workers_sick_or_disabled_u25$idperson)) |> 
  bind_rows(sample_workers_sick_or_disabled_u25) |> 
  arrange(idhh, idperson)

uprated_sick_or_disabled_o25_5pc <- raw_data |> 
  filter(!(idperson %in% sample_workers_sick_or_disabled_o25$idperson)) |> 
  bind_rows(sample_workers_sick_or_disabled_o25) |> 
  arrange(idhh, idperson)

write_tsv(uprated_pop_5pc, "data/matching_updated_pop_5pc.txt")
write_tsv(uprated_seeking_u25_5pc, "data/matching_updated_pop_seeking_u25_5pc.txt")
write_tsv(uprated_seeking_o25_5pc, "data/matching_updated_pop_seeking_o25_5pc.txt")
write_tsv(uprated_sick_or_disabled_u25_5pc, "data/matching_updated_pop_sick_or_disabled_u25_5pc.txt")
write_tsv(uprated_sick_or_disabled_o25_5pc, "data/matching_updated_pop_sick_or_disabled_o25_5pc.txt")


