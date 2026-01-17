# Process a Directory of Luminex Data Files

This function processes all Luminex plate files within a specified
directory. Each plate file is processed using
[`process_file()`](https://mini-pw.github.io/SerolyzeR/reference/process_file.md),
and the resulting normalised data is saved. Optionally, quality control
reports can be generated, and results from multiple plates can be merged
into a single file.

### Workflow

1.  Identify all Luminex plate files in the `input_dir`, applying
    recursive search if `recurse = TRUE`.

2.  Detect the format of each file based on the `format` parameter or
    the filename.

3.  Locate the corresponding layout file using the filename or use the
    common layout passed with the `layout_filepath` parameter.

4.  Determine the appropriate output directory using
    [`get_output_dir()`](https://mini-pw.github.io/SerolyzeR/reference/get_output_dir.md).

5.  Process each plate file using
    [`process_file()`](https://mini-pw.github.io/SerolyzeR/reference/process_file.md).

6.  If `merge_outputs = TRUE`, merge normalised data from multiple
    plates into a single CSV file.

### Naming Conventions for Input Files

- **If `format` is specified:**

  - Each plate file should be named as `{plate_name}.csv`.

  - The corresponding layout file should be named as
    `{plate_name}_layout.csv` or `{plate_name}_layout.xlsx`.

  - Alternatively, if `layout_filepath` is provided, it serves as a
    unified layout file for all plates.

- **If `format` equals `NULL` (automatic detection):**

  - Each plate file should be named as `{plate_name}_{format}.csv`,
    where `{format}` is either `xPONENT` or `INTELLIFLEX`.

  - The corresponding layout file should be named using the same
    convention as above, i.i. `{plate_name}_{format}_layout.csv` or
    `{plate_name}_{format}_layout.xlsx`.

### Output File Structure

- The `output_dir` parameter specifies where the processed files are
  saved.

- If `output_dir` is `NULL`, output files are saved in the same
  directory as the input files.

- By default, the output directory structure follows the input
  directory, unless `flatten_output_dir = TRUE`, which saves all outputs
  directly into `output_dir`.

- Output filenames follow the convention used in
  [`process_file()`](https://mini-pw.github.io/SerolyzeR/reference/process_file.md).

  - For a plate named `{plate_name}`, the normalised output files are
    named as:

    - `{plate_name}_RAU.csv` for RAU normalisation.

    - `{plate_name}_nMFI.csv` for nMFI normalisation.

    - `{plate_name}_MFI.csv` for MFI normalisation.

  - If `generate_reports = TRUE`, a quality control report for every
    plate is saved as `{plate_name}_report.pdf`.

  - If `merge_outputs = TRUE`, merged normalised files are named as:

    - `merged_RAU_{timestamp}.csv`

    - `merged_nMFI_{timestamp}.csv`

    - `merged_MFI_{timestamp}.csv`

  - If `generate_multiplate_reports = TRUE`, a multiplate quality
    control report is saved as `multiplate_report_{timestamp}.pdf`.

## Usage

``` r
process_dir(
  input_dir,
  output_dir = NULL,
  recurse = FALSE,
  flatten_output_dir = FALSE,
  layout_filepath = NULL,
  format = "xPONENT",
  normalisation_types = c("MFI", "RAU", "nMFI"),
  generate_reports = FALSE,
  generate_multiplate_reports = FALSE,
  merge_outputs = TRUE,
  column_collision_strategy = "intersection",
  return_plates = FALSE,
  dry_run = FALSE,
  verbose = TRUE,
  ...
)
```

## Arguments

- input_dir:

  (`character(1)`) Path to the directory containing plate files. Can
  contain subdirectories if `recurse = TRUE`.

- output_dir:

  (`character(1)`, optional) Path to the directory where output files
  will be saved. Defaults to `NULL` (same as input directory).

- recurse:

  (`logical(1)`, default = `FALSE`)

  - If `TRUE`, searches for plate files in subdirectories as well.

- flatten_output_dir:

  (`logical(1)`, default = `FALSE`)

  - If `TRUE`, saves output files directly in `output_dir`, ignoring the
    input directory structure.

- layout_filepath:

  (`character(1)`, optional) Path to a layout file. If `NULL`, the
  function attempts to detect it automatically.

- format:

  (`character(1)`, optional) Luminex data format. If `NULL`, it is
  automatically detected. Options: `'xPONENT'`, `'INTELLIFLEX'`,
  `'BIOPLEX'`. By default equals to `'xPONENT'`.

- normalisation_types:

  ([`character()`](https://rdrr.io/r/base/character.html), default =
  `c("MFI", "RAU", "nMFI")`)

  - The normalisation types to apply. Supported values: `"MFI"`,
    `"RAU"`, `"nMFI"`.

- generate_reports:

  (`logical(1)`, default = `FALSE`)

  - If `TRUE`, generates single plate quality control reports for each
    processed plate file.

- generate_multiplate_reports:

  (`logical(1)`, default = `FALSE`)

  - If `TRUE`, generates a multiplate quality control report for all
    processed plates.

- merge_outputs:

  (`logical(1)`, default = `TRUE`)

  - If `TRUE`, merges all normalised data into a single CSV file per
    normalisation type.

  - The merged file is named
    `merged_{normalisation_type}_{timestamp}.csv`.

- column_collision_strategy:

  (`character(1)`, default = `'intersection'`)

  - Determines how to handle missing or extra columns when merging
    outputs.

  - Options: `'union'` (include all columns), `'intersection'` (include
    only common columns).

- return_plates:

  (`logical(1)`, default = `FALSE`)

  - If `TRUE`, returns a list of processed plates sorted by experiment
    date.

- dry_run:

  (`logical(1)`, default = `FALSE`)

  - If `TRUE`, prints file details without processing them.

- verbose:

  (`logical(1)`, default = `TRUE`)

  - If `TRUE`, prints detailed processing information.

- ...:

  Additional arguments passed to
  [`process_file()`](https://mini-pw.github.io/SerolyzeR/reference/process_file.md).

## Value

If `return_plates = TRUE`, returns a sorted list of
[Plate](https://mini-pw.github.io/SerolyzeR/reference/Plate.md) objects.
Otherwise, returns `NULL`.

## Examples

``` r
# Process all plate files in a directory
input_dir <- system.file("extdata", "multiplate_lite", package = "SerolyzeR", mustWork = TRUE)
output_dir <- tempdir(check = TRUE)
plates <- process_dir(input_dir, return_plates = TRUE, output_dir = output_dir)
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
#> Merged output saved to: /tmp/RtmpZdvZIB/merged_MFI_20260117_182625.csv
#> Fitting the models and predicting RAU for each analyte
#> Fitting the models and predicting RAU for each analyte
#> Merged output saved to: /tmp/RtmpZdvZIB/merged_RAU_20260117_182625.csv
#> Computing nMFI values for each analyte
#> Computing nMFI values for each analyte
#> Merged output saved to: /tmp/RtmpZdvZIB/merged_nMFI_20260117_182625.csv
```
