# Generate a Levey-Jennings Report for Multiple Plates.

This function generates a Levey-Jennings report for a list of plates.
The report includes layout plot, levey jennings plot, for each analyte
and selected dilutions.

## Usage

``` r
generate_levey_jennings_report(
  list_of_plates,
  report_title,
  dilutions = c("1/100", "1/400"),
  filename = NULL,
  output_dir = "reports",
  additional_notes = NULL,
  ...
)
```

## Arguments

- list_of_plates:

  A list of plate objects.

- report_title:

  (`character(1)`) The title of the report.

- dilutions:

  (`character`) A character vector specifying the dilutions to be
  included in the report. Default is `c("1/100", "1/400")`.

- filename:

  (`character(1)`) The name of the output HTML report file. If not
  provided or set to `NULL`, the filename will be based on the first
  plate name, formatted as `{plate_name}_levey_jennings.html`. If the
  filename does not contain the `.html` extension, it will be
  automatically added. Absolute file paths in `filename` will override
  `output_dir`. Existing files at the specified path will be
  overwritten.

- output_dir:

  (`character(1)`) The directory where the report will be saved.
  Defaults to 'reports'. If `NULL`, the current working directory will
  be used. Necessary directories will be created if they do not exist.

- additional_notes:

  (`character(1)`) Additional notes to be included in the report.
  Markdown formatting is supported. If not provided, the section will be
  omitted.

- ...:

  Additional params passed to the plots created within the report.

## Value

A Levey-Jennings report in HTML format.

## Details

The report also includes stacked standard curves plot in both
monochromatic and color versions for each analyte. The report is
generated using the R Markdown template file
`levey_jennings_report_template.Rmd`, located in the `inst/templates`
directory of the package. You can access it using:
`system.file("templates/levey_jennings_report_template.Rmd", package = "SerolyzeR")`.

## Examples

``` r
output_dir <- tempdir(check = TRUE)

dir_with_luminex_files <- system.file("extdata", "multiplate_lite",
  package = "SerolyzeR", mustWork = TRUE
)
list_of_plates <- process_dir(dir_with_luminex_files,
  return_plates = TRUE, format = "xPONENT", output_dir = output_dir
)
#> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/multiplate_lite/CovidOISExPONTENT.csv
#> using format xPONENT
#> Failed to extract from BatchMetadata: BatchStartTime not found in BatchMetadata.
#> Failed to extract from raw header: BatchStartTime not found in raw header.
#> Fallback datetime successfully extracted from ProgramMetadata.
#> Could not parse datetime string using default datetime format. Trying other possibilies.
#> Successfully parsed datetime string using order: mdY IM p
#> 
#> New plate object has been created with name: CovidOISExPONTENT!
#> 
#> Processing plate 'CovidOISExPONTENT'
#> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/multiplate_lite/CovidOISExPONTENT2.csv
#> using format xPONENT
#> Failed to extract from BatchMetadata: BatchStartTime not found in BatchMetadata.
#> Failed to extract from raw header: BatchStartTime not found in raw header.
#> Fallback datetime successfully extracted from ProgramMetadata.
#> Could not parse datetime string using default datetime format. Trying other possibilies.
#> Successfully parsed datetime string using order: mdY IM p
#> 
#> New plate object has been created with name: CovidOISExPONTENT2!
#> 
#> Processing plate 'CovidOISExPONTENT2'
#> Extracting the raw MFI to the output dataframe
#> Extracting the raw MFI to the output dataframe
#> Merged output saved to: /tmp/RtmpGcElT2/merged_MFI_20260117_183016.csv
#> Fitting the models and predicting RAU for each analyte
#> Fitting the models and predicting RAU for each analyte
#> Merged output saved to: /tmp/RtmpGcElT2/merged_RAU_20260117_183016.csv
#> Computing nMFI values for each analyte
#> Computing nMFI values for each analyte
#> Merged output saved to: /tmp/RtmpGcElT2/merged_nMFI_20260117_183016.csv
note <- "This is a Levey-Jennings report.\n**Author**: Jane Doe \n**Tester**: John Doe"

generate_levey_jennings_report(
  list_of_plates = list_of_plates,
  report_title = "QC Report",
  dilutions = c("1/100", "1/200"),
  output_dir = tempdir(),
  additional_notes = note
)
#> Generating report... For large reports with more than 30 plates, this will take a few minutes.
#> Report successfully generated, saving to: /tmp/RtmpGcElT2/CovidOISExPONTENT_levey_jennings.html
```
