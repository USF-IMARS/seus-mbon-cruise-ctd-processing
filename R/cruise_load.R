library(here)
library(glue)

# load cruise from combined cruise files
cruise_load <- function(cruise_id){
  ctd_dir <- here("data/01_raw/raw_ctd_data")
  fpath <- here(glue(
    "{ctd_dir}/{cruise_id}_ctd_comb.csv"
  ))
  
  cruise_df <- read_csv(
    fpath, show_col_types = FALSE, col_types = cols(station = col_character())
  )
}