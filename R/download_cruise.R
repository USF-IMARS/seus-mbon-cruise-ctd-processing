library("here")
library("rerddap") # used to access different ERDDAPs

# this database contains CTD data from Walton Smith Cruises
database <- "https://gcoos5.geos.tamu.edu/erddap/"
Sys.setenv(RERDDAP_DEFAULT_URL = database)

download_cruise <- function(cruiseID, path, verbose = TRUE) {
    message(paste("Starting cruise:", cruiseID))

    # query cruise ID
    results <- tryCatch(
        {
            ed_search_adv(query = cruiseID)
        },
        error = function(e) {
            if (verbose) message("Did not find any files!")
            return(NULL)
            break
        }
    )

    # show results of cruise
    if (verbose) print(results)

    # create folder if doesn't exist
    here(loc, cruiseID) %>%
        fs::dir_create()

    # loop through each station for the cruise and download if doesn't exist
    for (j in seq(results$info$dataset_id)) {
        # extract filename from query
        filename <- results$info$dataset_id[j]

        # create out file path
        file_path <- here(path, cruiseID, glue("{filename}.csv"))

        # skip already downloaded files
        if (fs::file_exists(file_path)) {
            if (verbose) cat("Skipping file file:", filename, "\n--------\n\n")
            next
        }

        if (verbose) cat("Downloading file:", filename, "\n--------\n\n")

        # get data
        out <- info(filename)

        ctd_data <- tabledap(out, url = eurl(), store = disk())

        # save data
        write.csv(ctd_data, file_path)
    }

    if (verbose) {
        cat("Finished cruise", IDS, "\n\n---------------------------------------\n\n")
    }
}