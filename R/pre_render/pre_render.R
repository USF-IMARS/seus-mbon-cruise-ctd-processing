# Download the cruise data from the ERDDAP.
# Existing cruise data in `./data/01_raw/` will not re-download.
# source("R/pre_render/download_cruises.R")

# TODO: data preprocessing (CTD renaming?)

source("R/pre_render/generate_cruise_reports.R")
source("R/pre_render/generate_ctd_reports.R")
