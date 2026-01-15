# CTD SFER / SE US MBON seus-mbon-cruise-ctd-processing
CTD processing & reporting for the SEUS MBON research cruise data.

"Raw" data comes from https://gcoos5.geos.tamu.edu/erddap.
The data hosted there has already had some preprocessing done, but this cleans it even further.
The preprocessing includes cutting off the upcast using SBEDataProcessing from SeaBird.
The settings file (`.psa`) is not (yet) included here.
Other SBEDataProcessing modules may be used. 
Processing methods are documented in `Chrissy_2009_SeaBird CTD Processing Manual.pdf`.

After processing the cleaned data will be in `./data/cleaned/`.
A version of the cleaned data is hosted by USF IMaRS at [here](https://usf.app.box.com/folder/263263938989?s=dvoi1ve0jn3apbdlad114uhn0pvmjool).

NOTE: The list of cruises to be processed is manually maintained in this repo in the file `cruise_list.R`. To add a cruise to the processing, add its ID to that file.

# Usage 
Data ingestion is completed through rendering of a research notebooks into a quarto website.
The data is downloaded from ERDDAP in a pre-render step, then processed by the `.qmd` research notebooks.

1. clone this repository
3. build the site: `quarto render --no-cache`
    * NOTE: you can run with cache, but this may not generate the `data/cleaned/*.csv` files
4. view the site: `quarto preview`
5. publish to github pages: `quarto publish`


## adding a cruise
The list of cruises is in cruise_list.R.
To add a cruise, add the ID of the cruise to this file.

## Details of the pre-render & render workflow
A few steps happen when the `quarto publish` is run.

1. `pre-render` jobs will happen. These are specified `_quarto.yml`. These include downloading the data and generating a .qmd document for each CTD.
  * Sometimes there are caching issues. To resolve these delete all files within `ctd_reports/ctd_reports/*`.
2. `quarto render` will be run on all files listed under render in `_quarto.yml` to create the .html files.
3. The `.html` are uploaded to github pages.

In this workflow, you will primarily be editing the `ctd_reports/ctd_reports_template.qmd` file.

# workflow
To work with this repository:

1. edit `cruise_report/cruise_report_template.qmd` as desired.
    * note that the params in the header can be edited for testing a specific cruise.
2. `quarto preview` or `quarto publish` to generate the site.

## Running Tests
This project uses testthat for unit testing. To run the tests:

```r
# From R console
testthat::test_dir("tests/testthat")

# Or using devtools
devtools::test()
```

Or from the command line:
```bash
Rscript -e 'testthat::test_dir("tests/testthat")'
```