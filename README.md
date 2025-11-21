# CTD SFER / SE US MBON seus-mbon-cruise-ctd-processing
CTD processing & reporting for the SEUS MBON research cruise data.

"Raw" data comes from https://gcoos5.geos.tamu.edu/erddap.
The data hosted there has already had some processing done, but this cleans it even further.

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

# report templates & pre-rendering
The processing of each cruise data is done using the file `cruise_report/cruise_report_template.qmd`. 
When running quarto the pre-render step will use this template to make a `.qmd` for each cruise in `cruise_report/cruise_reports`. 
Then, when each `.qmd` is being rendered, the code in each cruise `.qmd` will be run. 
The code in these `.qmd` files processes the data.

# workflow
To work with this repository:

1. edit `cruise_report/cruise_report_template.qmd` as desired.
    * note that the params in the header can be edited for testing a specific cruise.
2. `quarto preview` or `quarto publish` to generate the site.