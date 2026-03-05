# Download the cruise data from the ERDDAP.
# Existing cruise data in `./data/01_raw/` will not re-download.
source("R/pre_render/download_cruises.R")

# TODO: rm -rf cruise_report/cruise_reports/
source("R/pre_render/generate_cruise_reports.R")
# TODO: rm -rf ctd_reports/ctd_reports/
source("R/pre_render/generate_ctd_reports.R")
