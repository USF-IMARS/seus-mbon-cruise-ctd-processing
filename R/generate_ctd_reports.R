# creates a report template .qmd for each
REPORT_TEMPLATE = "ctd_report_template.qmd"
REPORTS_DIR = "ctd_reports"

library(whisker)
library(glue)

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
root_dir <- "data/01_raw/"

# List all the subdirectories within the root directory
folders <- list.dirs(root_dir, full.names = TRUE, recursive = FALSE)

# Loop through each folder (cruise)
for (folder in folders) {
  # List all files within the current folder
  files <- list.files(folder, full.names = TRUE)

  # Loop through each file in the current folder (station)
  for (file in files) {
    # Print the folder name and the filename
    # print(paste("Folder:", folder, "File   :", basename(file)))
    cruise_id <- basename(folder)
    station_id <- sub("^[^_]*_([^.]*)\\..*$", "\\1", basename(file))
    params = list(
      cruise_id = cruise_id,
      station_id = station_id
    )
    print(glue("=== creating template for '{cruise_id} {station_id}' ==="))
    writeLines(
      whisker.render(templ, params),
      file.path(REPORTS_DIR, glue("{cruise_id}_{station_id}.qmd"))
    )
  }
}
