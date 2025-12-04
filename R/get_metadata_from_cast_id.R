get_metadata_from_cast_id <- function(cast_id){
    # usage: 
    #   metadata <- get_metatdata_from_cast_id("WS16074_WS16074_WS16074stn2")
    #   cruise_id <- metadata$cruise_id
    #   station_id <- metadata$station_id
    # params:
    #   cast_id : str in format "{}_{}_{station_id_entered_by_researcher}"

    cruise_id <- before_first <- sub("_.*", "", cast_id)
  
    # get cast ID from what researcher entered at the end of the full cast_id
    end_of_cast_id <- sub("^[^_]+_[^_]+_", "", cast_id)
    # extract station_id from cast_id by skipping first (1-3) letters and next (4-5) digits and optional
    station_id_as_entered <- sub("^[A-Za-z]{1,3}[0-9]{4,5}_?", "", end_of_cast_id)
    # drop stn, sta from station_id like `stn2`
    station_id <- sub("(?i)(stn|sta)_?", "", station_id_as_entered)
    # TODO: Deal with `station_id`s changing through time.
    #       Use mapping from https://github.com/sebastiandig/misc_ideas/blob/main/Rmd/ctd_data_station_check.qmd#L90-L117
    
    return(list(
        cast_id = cast_id,
        cruise_id = cruise_id,
        station_id = station_id
    ))
}