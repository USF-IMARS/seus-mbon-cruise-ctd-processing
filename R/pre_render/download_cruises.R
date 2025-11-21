library("purrr") # used to loop through lists
library("rerddap") # used to access different ERDDAPs
library("dplyr") # used to manipulate variables
library("here") # used to get relative directory location to a project
library("glue")
library("fs")

source(here::here("cruise_list.R"))
source(here::here("R/download_cruise.R"))

# this database contains CTD data from Walton Smith Cruises
database <- "https://gcoos5.geos.tamu.edu/erddap/"
Sys.setenv(RERDDAP_DEFAULT_URL = database)

# Set folder location
loc <- here("data", "01_raw", "ctd")

for (i in seq(cruise_list)) {
  try(download_cruise(cruise_list[i], loc), silent = TRUE)
}
