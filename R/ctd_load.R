##%######################################################%##
#                                                          #
####            Load CTD Data and Parameters            ####
#                                                          #
##%######################################################%##
#' Load CTD Data and Parameters
#'
#' FUNCTION_DESCRIPTION
#'
#' @param data DESCRIPTION.
#' @param params_other DESCRIPTION.
#' @param verbose DESCRIPTION.
#'
#' @return RETURN_DESCRIPTION
#' @examples
#' # ADD_EXAMPLES_HERE
#'
#' @author Sebastian Di Geronimo
#' @author Tylar Murray
#' @author Mostafa Soliman
#'
ctd_load <- function(data, params_other = NULL, verbose = TRUE) {

  stations  <- unique(data$station)
  final_ctd <- list()

  for (station in stations) {
    if (verbose) cat(station, "\n")
    ctd_raw <- filter(data, station == .env$station)

    # create ctd object using csv data
    ctd_temp <-
      with(
        ctd_raw,
        as.ctd(
          salinity    = sea_water_salinity,
          temperature = sea_water_temperature,
          pressure    = sea_water_pressure,
          station     = station[[1]],
          cruise      = cruise_id[[1]],
          longitude   = longitude[[1]],
          latitude    = latitude[[1]],
          time        = time_elapsed
        )
      )

    # add additional columns to ctd object
    if (is.null(params_other)) {
      final_ctd[[station]] <- ctd_temp
      next
    }

    # if vector of parameters names
    if (is.vector(params_other)) {
      # filter for names occurring in data
      params_used <- params_other[params_other %in% names(ctd_raw)]

      # add each parameter
      for (param_name in params_used) {
        ctd_temp <-
          oceSetData(
            object         = ctd_temp,
            name           = param_name,
            value          = ctd_raw[[param_name]],
            originalName   = param_name
          )
      }
    } 
    
    if (is.data.frame(params_other)) {
      
      # filter for names occurring in data
      params_used <- filter(params_other, parameter %in% names(ctd_raw))
      
      # add each parameter
      for (i in seq(nrow(params_used))) {

        param_name <- params_used$parameter[i]
        
        param_unit <- 
          params_used$unit[i] %>%
          str_replace_all("\\s", "~") %>%
          str_replace("%", "'%'") %>%
          parse(text = .)
        
        ctd_temp <-
          oceSetData(
            object         = ctd_temp,
            name           = params_used$name[i],
            value          = ctd_raw[[param_name]],
            originalName   = param_name,
            unit           = param_unit
          )
      }
    }

    final_ctd[[station]] <- ctd_temp
  }

  return(final_ctd)
}