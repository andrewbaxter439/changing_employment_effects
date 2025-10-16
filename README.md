
# Estimating cost savings of increasing employment

<!-- badges: start -->
<!-- badges: end -->

This project uses EUROMOD and UKMOD to estimate tax/benefit spending changes under hypothetical employment increases. This was conducted as part of the 'Estimating the savings and financial benefits to the UK government of return-to-work for people in receipt of Universal Credit' report, published [here](https://www.healthequitynorth.co.uk/government-schemes-could-save-uk-over-20-billion-by-getting-5-back-to-work/).

To access data to run these models, request access to the dataset 'UK_2023_b1.txt' from [The UKMOD site](https://www.microsimulation.ac.uk/ukmod/access/) and place in folder 'data'.

Source files in this order for full run:

- R/install_and_setup.R
- R/make_pops_from_matches.R
- R/run_euromod_runs.R
- estimating_the_impacts_of_changing_rates.qmd
