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

  # add additional columns to ctd object
  if (is.vector(other_params)) { # if vector of parameters names
    # filter for names occurring in data
    params_used <- other_params[other_params %in% names(ctd_raw)]

    # add each parameter
    for (param_name in params_used) {
      ctd_temp <-
        oce::oceSetData(
          object         = ctd_temp,
          name           = param_name,
          value          = ctd_raw[[param_name]],
          originalName   = param_name
        )
    }
  } else {
    print("No additional parameters to add")
  }
  return(ctd_temp)
  # ---- end of function ctd_load
}