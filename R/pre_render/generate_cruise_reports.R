# creates a report template .qmd for each
REPORT_TEMPLATE = "cruise_report/cruise_report_template.qmd"
REPORTS_DIR = "cruise_report/cruise_reports"

if (!nzchar(system.file(package = "librarian"))) {
  install.packages("librarian")
}
librarian::shelf(
  glue,
  whisker  
)

# Proceed if rendering the whole project, exit otherwise
if (!nzchar(Sys.getenv("QUARTO_PROJECT_RENDER_ALL"))) {
  quit()
}

# create the template
# TODO: do this using `double_param_the_yaml()`
templ <- readLines(REPORT_TEMPLATE) 
templ <- gsub(
  "WS22072", "{{cruise_id}}", templ
)

dir.create(REPORTS_DIR, showWarnings=FALSE)

# === iterate through the data structure 
# Set the root directory where the folders are located
folder <- "data/01_raw/raw_ctd_data"

files <- list.files(folder, full.names = TRUE)

# Loop through each file in the current folder (station)
for (file in files) {
  # Print the folder name and the filename
  # print(paste("Folder:", folder, "File   :", basename(file)))
  cruise_id <- sub(".csv", "", basename(file))
  params = list(
    cruise_id = cruise_id
  )
  print(glue("=== creating template for '{cruise_id}' ==="))
  writeLines(
    whisker.render(templ, params),
    file.path(REPORTS_DIR, glue("{cruise_id}.qmd"))
  )
}

