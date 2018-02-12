# This wrapper script runs the markdown file lib_content.Rmd
# The markdonw run is paramaterized based on the unique LIBVER values found
# in the df dataframe in global.R
# Authors : F. Michel-Sendis & L. Fiorito 
#
source('global.R')
# Define report tibble with output filenames and parameters
reports <- tibble(
  LIBVERS = unique(df$LIBVER),
  filename = stringr::str_c("breakdown-", LIBVERS, ".html"),
  params = purrr::map(LIBVERS, ~ list(RELEASE = .))
)

# Parametrized rendering of the lib_content.Rmd markdown script using reports parameters as inputs
reports %>%
  select(output_file = filename, params) %>%
  purrr::pwalk(rmarkdown::render, input = "lib_content.Rmd")
