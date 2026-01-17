# Generate a report for a plate.

This function generates a report for a plate. The report contains all
the necessary information about the plate, from the general plate
parameters, such as examination date, to the breakdown of the analytes'
plots. The report is generated using the R Markdown template file
`plate_report_template.Rmd`, located in the `inst/templates` directory
of the package. You can access it using:
`system.file("templates/plate_report_template.Rmd", package = "SerolyzeR")`.

## Usage

``` r
generate_plate_report(
  plate,
  use_model = TRUE,
  filename = NULL,
  output_dir = "reports",
  counts_lower_threshold = 50,
  counts_higher_threshold = 70,
  additional_notes = NULL,
  ...
)
```

## Arguments

- plate:

  A plate object.

- use_model:

  (`logical(1)`) A logical value indicating whether the model should be
  used in the report.

- filename:

  (`character(1)`) The name of the output HTML report file. If not
  provided or equals to `NULL`, the output filename will be based on the
  plate name, precisely: `{plate_name}_report.html`. By default the
  `plate_name` is the filename of the input file that contains the plate
  data. For more details please refer to
  [Plate](https://mini-pw.github.io/SerolyzeR/reference/Plate.md).

  If the passed filename does not contain `.html` extension, the default
  extension `.html` will be added. Filename can also be a path to a
  file, e.g. `path/to/file.html`. In this case, the `output_dir` and
  `filename` will be joined together. However, if the passed filepath is
  an absolute path and the `output_dir` parameter is also provided, the
  `output_dir` parameter will be ignored. If a file already exists under
  a specified filepath, the function will overwrite it.

- output_dir:

  (`character(1)`) The directory where the output CSV file should be
  saved. Please note that any directory path provided will create all
  necessary directories (including parent directories) if they do not
  exist. If it equals to `NULL` the current working directory will be
  used. Default is 'reports'.

- counts_lower_threshold:

  (`numeric(1)`) The lower threshold for the counts plots (works for
  each analyte). Default is 50.

- counts_higher_threshold:

  (`numeric(1)`) The higher threshold for the counts plots (works for
  each analyte). Default is 70.

- additional_notes:

  (`character(1)`) Additional notes to be included in the report.
  Contents of this fields are left to the user's discretion. If not
  provided, the field will not be included in the report.

- ...:

  Additional params passed to the plots created in the report.

## Value

A report.

## Examples

``` r
plate_file <- system.file("extdata", "CovidOISExPONTENT_CO_reduced.csv", package = "SerolyzeR")
# a plate file with reduced number of analytes to speed up the computation
layout_file <- system.file("extdata", "CovidOISExPONTENT_CO_layout.xlsx", package = "SerolyzeR")
note <- "This is a test report.\n**Author**: Jane Doe \n**Tester**: John Doe"

plate <- read_luminex_data(plate_file, layout_file, verbose = FALSE)
#> Could not parse datetime string using default datetime format. Trying other possibilies.
#> Successfully parsed datetime string using order: mdY IM p
example_dir <- tempdir(check = TRUE) # a temporary directory
generate_plate_report(plate,
  output_dir = example_dir,
  counts_lower_threshold = 40,
  counts_higher_threshold = 50,
  additional_notes = note
)
#> Generating report...This will take approximately 30 seconds.
#> Report successfully generated, saving to: /tmp/RtmpGcElT2
```
