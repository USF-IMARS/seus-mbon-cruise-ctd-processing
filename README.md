# seus-mbon-cruise-ctd-processing
CTD processing &amp; reporting for the SEUS MBON research cruise data

# Usage 
1. clone this repository
2. put data into `data/01_raw/combined_fl_keys_data`
3. build the site: `quarto render .`
4. view the site: `quarto preview .`
5. publish to github pages: `quarto publish`

```mermaid
graph TD

get_cruise_list{{get_cruise_list.R}}
  --> cruise_list[[cruise_list.csv]]

cruise_list -.->
prerender_cruise_reports[/prerender_cruise_reports.R\]
  === foreach_cruise 

%% rendering is implied for every .qmd
%% cruise_report -.->
%%   render{{render}}
%%   --> cruise_report_html[["cruise_(cruise_id)_report.html"]]

subgraph foreach_cruise
  cruise_report{{"cruise_(cruise_id)_report.qmd"}}
  prerender_cast_reports[/prerender_cast_reports.R\]
    === foreach_cast
end


subgraph foreach_cast
  cast_report{{"ctd_(cruise_id)_(cast_id)_report.qmd"}}
end

%% subgraph legend
%% script{{script.R}} 
%%   -- creates --> file[[file.txt]]

%% file -. depends .->
%%   report{{report.qmd}}

%% map[/map\]

%% reduce[\reduce/]

%%db[(database.sqlite)]

%% end
```