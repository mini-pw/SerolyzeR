# Process a File to Generate Normalised Data and Reports

This function reads a Luminex plate file by calling
[`read_luminex_data()`](https://mini-pw.github.io/SerolyzeR/reference/read_luminex_data.md)
and then processes it by calling
[`process_plate()`](https://mini-pw.github.io/SerolyzeR/reference/process_plate.md).
It optionally generates also a quality control report using
[`generate_plate_report()`](https://mini-pw.github.io/SerolyzeR/reference/generate_plate_report.md).
It reads the specified plate file, processes the plate object using all
specified normalisation types (including raw MFI values), and saves the
results. If `generate_report = TRUE`, a quality control report is also
generated.

## Usage

``` r
process_file(
  plate_filepath,
  layout_filepath,
  output_dir = "normalised_data",
  format = "xPONENT",
  generate_report = FALSE,
  process_plate = TRUE,
  normalisation_types = c("MFI", "RAU", "nMFI"),
  blank_adjustment = FALSE,
  verbose = TRUE,
  ...
)
```

## Arguments

- plate_filepath:

  (`character(1)`) Path to the Luminex plate file.

- layout_filepath:

  (`character(1)`) Path to the corresponding layout file.

- output_dir:

  (`character(1)`, default = `'normalised_data'`)

  - Directory where the output files will be saved.

  - If it does not exist, it will be created.

- format:

  (`character(1)`, default = `'xPONENT'`)

  - Format of the Luminex data.

  - Available options: `'xPONENT'`, `'INTELLIFLEX'`.

- generate_report:

  (`logical(1)`, default = `FALSE`)

  - If `TRUE`, generates a quality control report using
    [`generate_plate_report()`](https://mini-pw.github.io/SerolyzeR/reference/generate_plate_report.md).

- process_plate:

  (`logical(1)`, default = `TRUE`)

  - If `TRUE`, processes the plate data using
    [`process_plate()`](https://mini-pw.github.io/SerolyzeR/reference/process_plate.md).

  - If `FALSE`, only reads the plate file and returns the plate object
    without processing.

- normalisation_types:

  ([`character()`](https://rdrr.io/r/base/character.html), default =
  `c("MFI", "RAU", "nMFI")`)

  - List of normalisation types to apply.

  - Supported values: `c("MFI", "RAU", "nMFI")`.

- blank_adjustment:

  (`logical(1)`, default = `FALSE`)

  - If `TRUE`, performs blank adjustment before processing.

- verbose:

  (`logical(1)`, default = `TRUE`)

  - If `TRUE`, prints additional information during execution.

- ...:

  Additional arguments passed to
  [`read_luminex_data()`](https://mini-pw.github.io/SerolyzeR/reference/read_luminex_data.md),
  [`generate_plate_report()`](https://mini-pw.github.io/SerolyzeR/reference/generate_plate_report.md)
  and
  [`process_plate()`](https://mini-pw.github.io/SerolyzeR/reference/process_plate.md).

## Value

A [Plate](https://mini-pw.github.io/SerolyzeR/reference/Plate.md) object
containing the processed data.

## Workflow

1.  Read the plate file and layout file.

2.  Process the plate data using the specified normalisation types
    (`MFI`, `RAU`, `nMFI`).

3.  Save the processed data to CSV files in the specified `output_dir`.
    The files are named as `{plate_name}_{normalisation_type}.csv`.

4.  Optionally, generate a quality control report. The report is saved
    as an HTML file in the `output_dir`, under the name
    `{plate_name}_report.html`.

## Examples

``` r
# Example 1: Process a plate file with default settings (all normalisation types)
plate_file <- system.file("extdata", "CovidOISExPONTENT_CO_reduced.csv", package = "SerolyzeR")
layout_file <- system.file("extdata", "CovidOISExPONTENT_CO_layout.xlsx", package = "SerolyzeR")
example_dir <- tempdir(check = TRUE)
process_file(plate_file, layout_file, output_dir = example_dir)
#> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/CovidOISExPONTENT_CO_reduced.csv
#> using format xPONENT
#> Failed to extract from BatchMetadata: BatchStartTime not found in BatchMetadata.
#> Failed to extract from raw header: BatchStartTime not found in raw header.
#> Fallback datetime successfully extracted from ProgramMetadata.
#> Could not parse datetime string using default datetime format. Trying other possibilies.
#> Successfully parsed datetime string using order: mdY IM p
#> 
#> New plate object has been created with name: CovidOISExPONTENT_CO_reduced!
#> 
#> Processing plate 'CovidOISExPONTENT_CO_reduced'
#> Extracting the raw MFI to the output dataframe
#> Saving the computed MFI values to a CSV file located in: '/tmp/RtmpHRzMKG/CovidOISExPONTENT_CO_reduced_MFI.csv'
#> Fitting the models and predicting RAU for each analyte
#> Saving the computed RAU values to a CSV file located in: '/tmp/RtmpHRzMKG/CovidOISExPONTENT_CO_reduced_RAU.csv'
#> Computing nMFI values for each analyte
#> Saving the computed nMFI values to a CSV file located in: '/tmp/RtmpHRzMKG/CovidOISExPONTENT_CO_reduced_nMFI.csv'
#> Plate with 49 samples and 2 analytes

# Example 2: Process the plate for only RAU normalisation
process_file(plate_file, layout_file, output_dir = example_dir, normalisation_types = c("RAU"))
#> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/CovidOISExPONTENT_CO_reduced.csv
#> using format xPONENT
#> Failed to extract from BatchMetadata: BatchStartTime not found in BatchMetadata.
#> Failed to extract from raw header: BatchStartTime not found in raw header.
#> Fallback datetime successfully extracted from ProgramMetadata.
#> Could not parse datetime string using default datetime format. Trying other possibilies.
#> Successfully parsed datetime string using order: mdY IM p
#> 
#> New plate object has been created with name: CovidOISExPONTENT_CO_reduced!
#> 
#> Processing plate 'CovidOISExPONTENT_CO_reduced'
#> Warning: The specified file /tmp/RtmpHRzMKG/CovidOISExPONTENT_CO_reduced_RAU.csv already exists. Overwriting it.
#> Fitting the models and predicting RAU for each analyte
#> Saving the computed RAU values to a CSV file located in: '/tmp/RtmpHRzMKG/CovidOISExPONTENT_CO_reduced_RAU.csv'
#> Plate with 49 samples and 2 analytes

# Example 3: Process the plate and generate a quality control report
process_file(plate_file, layout_file, output_dir = example_dir, generate_report = TRUE)
#> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/CovidOISExPONTENT_CO_reduced.csv
#> using format xPONENT
#> Failed to extract from BatchMetadata: BatchStartTime not found in BatchMetadata.
#> Failed to extract from raw header: BatchStartTime not found in raw header.
#> Fallback datetime successfully extracted from ProgramMetadata.
#> Could not parse datetime string using default datetime format. Trying other possibilies.
#> Successfully parsed datetime string using order: mdY IM p
#> 
#> New plate object has been created with name: CovidOISExPONTENT_CO_reduced!
#> 
#> Processing plate 'CovidOISExPONTENT_CO_reduced'
#> Warning: The specified file /tmp/RtmpHRzMKG/CovidOISExPONTENT_CO_reduced_MFI.csv already exists. Overwriting it.
#> Extracting the raw MFI to the output dataframe
#> Saving the computed MFI values to a CSV file located in: '/tmp/RtmpHRzMKG/CovidOISExPONTENT_CO_reduced_MFI.csv'
#> Warning: The specified file /tmp/RtmpHRzMKG/CovidOISExPONTENT_CO_reduced_RAU.csv already exists. Overwriting it.
#> Fitting the models and predicting RAU for each analyte
#> Saving the computed RAU values to a CSV file located in: '/tmp/RtmpHRzMKG/CovidOISExPONTENT_CO_reduced_RAU.csv'
#> Warning: The specified file /tmp/RtmpHRzMKG/CovidOISExPONTENT_CO_reduced_nMFI.csv already exists. Overwriting it.
#> Computing nMFI values for each analyte
#> Saving the computed nMFI values to a CSV file located in: '/tmp/RtmpHRzMKG/CovidOISExPONTENT_CO_reduced_nMFI.csv'
#> Generating report...This will take approximately 30 seconds.
#> Warning: The specified file /tmp/RtmpHRzMKG/CovidOISExPONTENT_CO_reduced_report.html already exists. Overwriting it.
#> Report successfully generated, saving to: /tmp/RtmpHRzMKG
#> Plate with 49 samples and 2 analytes
```
