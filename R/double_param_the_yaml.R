library(yaml)

# === TODO: read yaml from file
library(yaml)

read_yaml_front_matter <- function(file_path) {
  lines <- readLines(file_path)
  
  # Identify the start and end of the YAML front matter
  delimiters <- which(lines == "---")
  if (length(delimiters) < 2) {
    stop("YAML front matter delimiters not found or incomplete.")
  }
  
  # Extract the YAML content between the first two '---' lines
  yaml_lines <- lines[(delimiters[1] + 1):(delimiters[2] - 1)]
  yaml_content <- paste(yaml_lines, collapse = "\n")
  
  # Return the parsed YAML content (as a list) or as raw text
  yaml_list <- yaml.load(yaml_content)
  return(yaml_list)
}

# Usage example:
file_path <- "path/to/your/document.Rmd"  # Replace with your actual file path
yaml_data <- read_yaml_front_matter(file_path)
print(yaml_data)



yaml_content <- "
---
title: \"Clean up cast\"
format: html
code-fold: true
params: 
  cruise_id: WS15320
  station_id: stn9_5
---
"

# Load and parse the YAML
parsed_yaml <- yaml.load(yaml_content)

# Modify the `params` section
params <- parsed_yaml$params
new_params <- sapply(
  names(params), 
  function(x) paste0("{", x, "}"), 
  simplify = FALSE
)
parsed_yaml$params <- new_params

# Convert back to YAML
new_yaml_content <- as.yaml(parsed_yaml)

# Output the result
cat(new_yaml_content)
