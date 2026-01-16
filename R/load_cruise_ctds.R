library(tidyverse)
library(here)

#' Load All CTD Files for a Given Cruise
#'
#' Loads all CTD files from data/02_clean that match the given cruise ID
#' and combines them into a single dataframe with a station column.
#'
#' @param cruise_id Character string of the cruise ID to filter for
#' @param data_dir Directory containing the CTD files (default: "data/02_clean")
#'
#' @return A dataframe with all CTD data for the cruise, including a station column
#'
#' @examples
#' # Load all CTD data for cruise SAV1803
#' sav1803_data <- load_cruise_ctds("SAV1803")
#'
#' # Load from a different directory
#' ws16074_data <- load_cruise_ctds("WS16074", data_dir = "data/02_renamed")
#'
#' @author GitHub Copilot
load_cruise_ctds <- function(cruise_id, data_dir = "data/02_clean") {
  
  # Source helper function
  source(here("R/get_metadata_from_cast_id.R"))
  
  # Get all CSV files from the specified directory
  all_files <- list.files(
    path = here(data_dir),
    pattern = "\\.csv$",
    full.names = TRUE
  )
  
  # Filter files for the specified cruise
  cruise_files <- all_files[grepl(paste0("^", cruise_id, "_"), basename(all_files))]
  
  if (length(cruise_files) == 0) {
    warning(paste0("No files found for cruise ID: ", cruise_id))
    return(tibble())
  }
  
  # Read all cruise files and combine them
  cruise_data <- cruise_files %>%
    map_dfr(function(file) {
      # Extract station from filename
      filename <- basename(file)
      cast_id <- str_remove(filename, "\\.csv$")
      metadata <- get_metadata_from_cast_id(cast_id)
      station_id <- metadata$station_id
      
      # Read the CSV file with col_types = cols(.default = col_guess())
      # This allows read_csv to guess types, but we'll handle inconsistencies
      df <- read_csv(file, show_col_types = FALSE, col_types = cols(.default = col_guess()))
      
      # Remove first column if it's an unnamed row index (for backwards compatibility)
      if (ncol(df) > 0 && (names(df)[1] == "" || grepl("^\\.\\.\\.\\d+$", names(df)[1]))) {
        df <- df %>% select(-1)
      }
            
      # Add station column
      df$station <- station_id
      
      return(df)
    })
  
  cat("Loaded", length(cruise_files), "files for cruise", cruise_id, "\n")
  cat("Total rows:", nrow(cruise_data), "\n")
  
  return(cruise_data)
}
