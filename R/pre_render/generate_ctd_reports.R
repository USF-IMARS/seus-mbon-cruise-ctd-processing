# Uses `ctd_reports/ctd_reports_template.qmd` to create a .qmd report for each CTD cast in the `data/01_raw/` directory.

REPORT_TEMPLATE = "ctd_reports/ctd_reports_template.qmd"
REPORTS_DIR = "ctd_reports/ctd_reports"

if (!nzchar(system.file(package = "librarian"))) {
  install.packages("librarian")
}
librarian::shelf(
  glue,
  whisker  
)

# TODO: delete everything in the $REPORTS_DIR to prevent caching issues?

# Proceed if rendering the whole project, exit otherwise
if (!nzchar(Sys.getenv("QUARTO_PROJECT_RENDER_ALL"))) {
  quit()
}

# create the template
templ <- readLines(REPORT_TEMPLATE) 
templ <- gsub(
  "WS0603_WS0603_WS0603_CAL2", "{{cast_id}}", templ
)

dir.create(REPORTS_DIR, showWarnings=FALSE)

# === iterate through the data structure 
# Set the root directory where the folders are located
folder <- "data/01_raw/ctd"

# get list of files in the folder, select only .csv files from within subfolders
files <- list.files(
  path = folder,
  pattern = "\\.csv$",
  full.names = TRUE,
  recursive = TRUE
)

# Loop through each file in the current folder (station)
for (file in files) {
  # Print the folder name and the filename
  cast_id <- sub(".csv", "", basename(file))
  params = list(
    cast_id = cast_id
  )
  print(glue("=== creating template for '{cast_id}'"))
  writeLines(
    whisker.render(templ, params),
    file.path(REPORTS_DIR, glue("{cast_id}.qmd"))
  )
}

