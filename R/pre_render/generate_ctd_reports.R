# creates a report template .qmd for each
REPORT_TEMPLATE = "ctd_report/ctd_report_template.qmd"
REPORTS_DIR = "ctd_report/ctd_reports"

if (!nzchar(system.file(package = "librarian"))) {
  install.packages("librarian")
}
librarian::shelf(
  glue,
  here,
  readr,
  whisker  
)

# Proceed if rendering the whole project, exit otherwise
if (!nzchar(Sys.getenv("QUARTO_PROJECT_RENDER_ALL"))) {
  quit()
}

# create the template
# TODO: do this using `double_param_the_yaml()`
templ <- readLines(REPORT_TEMPLATE) 
templ <-  gsub(
  "stn9_5", "{{station_id}}", templ
)
templ <- gsub(
  "WS15320", "{{cruise_id}}", templ
)

dir.create(REPORTS_DIR, showWarnings=FALSE)

# === iterate through the data structure 
# Set the root directory where the folders are located
root_dir <- "cruise_report/cruise_reports/"

# List all the subdirectories within the cruise
files <- list.files(root_dir, pattern=".*qmd", full.names = TRUE, recursive = FALSE)

# Loop through each file in the current folder (station)
for (file in files) {
  # Print the folder name and the filename
  print(paste("File   :", basename(file)))
  cruise_id <- sub("\\.qmd$", "", basename(file))
  
  # load cruise data
  ctd_dir <- here("data/01_raw/raw_ctd_data")
  fpath <- here(glue(
    "{ctd_dir}/{cruise_id}_ctd_comb.csv"
  ))
  
  cruise_df <- readr::read_csv(
    fpath, 
    show_col_types = FALSE, 
    col_types = readr::cols(station = col_character())
  )
  for (station_id in unique(cruise_df$station)) {
    params = list(
      cruise_id = cruise_id,
      station_id = station_id
    )
    print(glue("=== creating template for '{cruise_id} {station_id}' ==="))
    station_id <- sub("/", "_", station_id)
    cruise_dir <- file.path(REPORTS_DIR, cruise_id)
    dir.create(cruise_dir, showWarnings=FALSE)
    writeLines(
      whisker.render(templ, params),
      glue("{cruise_dir}/{station_id}.qmd")
    )
  }
}


  