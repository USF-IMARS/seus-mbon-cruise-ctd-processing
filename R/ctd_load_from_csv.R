ctd_load_from_csv <- function(file, other_params = NULL) {
  # file <- here::here(glue::glue("data/01_raw/ctd/{cruise_id}/{params$cast_id}.csv"))
  # other_params <- NULL
  cat(basename(file), "\n")

  ctd_raw <- readr::read_csv(file, show_col_types = FALSE)

  # get station ID from filename
  source(here::here("R/get_metadata_from_cast_id.R"))
  metadata <- get_metadata_from_cast_id(params$cast_id)
  station_id <- metadata$station_id
  cruise_id <- metadata$cruise_id
  
  # assume lat+lon is same throughout the cast
  lat <- ctd_raw$latitude[[1]]
  lon <- ctd_raw$longitude[[1]]

  # create ctd object using csv data
  ctd_temp <-
    with(
      ctd_raw,
      as.ctd(
        salinity    = sea_water_salinity,
        temperature = sea_water_temperature,
        pressure    = sea_water_pressure,
        station     = station_id,
        cruise      = cruise_id,
        longitude   = lon,
        latitude    = lat,
        time        = time_elapsed
      )
    )

  # Automatically add all other columns from CSV to ctd object
  # Identify columns already used in the core CTD object
  core_columns <- c("sea_water_salinity", "sea_water_temperature", "sea_water_pressure", 
                    "latitude", "longitude", "time_elapsed")
  
  # Get all column names from the raw data
  all_columns <- names(ctd_raw)
  
  # Determine which columns to add (all except core ones)
  additional_columns <- setdiff(all_columns, core_columns)
  
  # Add each additional column to the ctd object
  for (param_name in additional_columns) {
    ctd_temp <-
      oce::oceSetData(
        object         = ctd_temp,
        name           = param_name,
        value          = ctd_raw[[param_name]],
        originalName   = param_name
      )
  }
  
  cat("Added", length(additional_columns), "additional parameters to CTD object\n")
  
  return(ctd_temp)
  # ---- end of function ctd_load
}