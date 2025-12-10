# Read Luminex Data

Reads a Luminex plate file and returns a
[Plate](https://mini-pw.github.io/SerolyzeR/reference/Plate.md) object
containing the extracted data. Optionally, a layout file can be provided
to specify the arrangement of samples on the plate.

## Usage

``` r
read_luminex_data(
  plate_filepath,
  layout_filepath = NULL,
  format = "xPONENT",
  plate_file_separator = ",",
  plate_file_encoding = "UTF-8",
  use_layout_sample_names = TRUE,
  use_layout_types = TRUE,
  use_layout_dilutions = TRUE,
  default_data_type = "Median",
  sample_types = NULL,
  dilutions = NULL,
  verbose = TRUE,
  ...
)
```

## Arguments

- plate_filepath:

  (`character(1)`) Path to the Luminex plate file.

- layout_filepath:

  (`character(1)`, optional) Path to the Luminex layout file.

- format:

  (`character(1)`, default = `'xPONENT'`)

  - The format of the Luminex data file.

  - Supported formats: `'xPONENT'`, `'INTELLIFLEX'`.

- plate_file_separator:

  (`character(1)`, default = `','`)

  - The delimiter used in the plate file (CSV format). Used only for the
    xPONENT format.

- plate_file_encoding:

  (`character(1)`, default = `'UTF-8'`)

  - The encoding used for reading the plate file. Used only for the
    xPONENT format.

- use_layout_sample_names:

  (`logical(1)`, default = `TRUE`)

  - Whether to use sample names from the layout file.

- use_layout_types:

  (`logical(1)`, default = `TRUE`)

  - Whether to use sample types from the layout file (requires a layout
    file).

- use_layout_dilutions:

  (`logical(1)`, default = `TRUE`)

  - Whether to use dilution values from the layout file (requires a
    layout file).

- default_data_type:

  (`character(1)`, default = `'Median'`)

  - The default data type used if none is explicitly provided.

- sample_types:

  ([`character()`](https://rdrr.io/r/base/character.html), optional) A
  vector of sample types to override extracted values.

- dilutions:

  ([`numeric()`](https://rdrr.io/r/base/numeric.html), optional) A
  vector of dilutions to override extracted values.

- verbose:

  (`logical(1)`, default = `TRUE`)

  - Whether to print additional information and warnings.

- ...:

  Additional arguments. Ignored in this method. Here included for better
  integration with the pipeline

## Value

A [Plate](https://mini-pw.github.io/SerolyzeR/reference/Plate.md) object
containing the parsed Luminex data.

## Details

The function supports two Luminex data formats:

- **xPONENT**: Used by older Luminex machines.

- **INTELLIFLEX**: Used by newer Luminex devices.

## Workflow

1.  Validate input parameters, ensuring the specified format is
    supported.

2.  Read the plate file using the appropriate parser:

    - xPONENT files are read using
      [`read_xponent_format()`](https://mini-pw.github.io/SerolyzeR/reference/read_xponent_format.md).

    - INTELLIFLEX files are read using
      [`read_intelliflex_format()`](https://mini-pw.github.io/SerolyzeR/reference/read_intelliflex_format.md).

3.  Post-process the extracted data:

    - Validate required data columns (`Median`, `Count`).

    - Extract sample locations and analyte names.

    - Parse the date and time of the experiment.

## File Structure

- **Plate File (`plate_filepath`)**: A CSV file containing Luminex
  fluorescence intensity data.

- **Layout File (`layout_filepath`)** (optional): An Excel or CSV file
  containing the plate layout.

  - The layout file should contain a table with **8 rows and 12
    columns**, where each cell corresponds to a well location.

  - The values in the table represent the sample names for each well.

## Sample types detection

The `read_luminex_data()` method automatically detects the sample types
based on the sample names, unless provided the `sample_types` parameter.
The sample types are detected used the
[`translate_sample_names_to_sample_types()`](https://mini-pw.github.io/SerolyzeR/reference/translate_sample_names_to_sample_types.md)
method. In the documentation of this method, which can be accessed with
command
[`?translate_sample_names_to_sample_types`](https://mini-pw.github.io/SerolyzeR/reference/translate_sample_names_to_sample_types.md),
you can find the detailed description of the sample types detection.

### Duplicates in sample names

In some cases, we want to analyse the sample with the same name twice on
one plate. The package allows for such situations, but we assume that
the user knows what they are doing.

When importing sample names (either from the layout file or the plate
file), the function will check for duplicates. If any are found, it will
issue a warning like:

**Duplicate sample names detected: A, B. Renaming to make them unique.**

Then it will add simple numeric suffixes (e.g. “.1”, “.2”) to the
repeated sample names so that every name is unique while keeping the
original text easy to recognize.

## Examples

``` r
# Read a Luminex plate file with an associated layout file
plate_file <- system.file("extdata", "CovidOISExPONTENT.csv", package = "SerolyzeR")
layout_file <- system.file("extdata", "CovidOISExPONTENT_layout.csv", package = "SerolyzeR")
plate <- read_luminex_data(plate_file, layout_file)
#> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/CovidOISExPONTENT.csv
#> using format xPONENT
#> Failed to extract from BatchMetadata: BatchStartTime not found in BatchMetadata.
#> BatchStartTime successfully extracted from the header.
#> Could not parse datetime string using default datetime format. Trying other possibilies.
#> Successfully parsed datetime string using order: mdY IMS p
#> 
#> New plate object has been created with name: CovidOISExPONTENT!
#> 

# Read a Luminex plate file without a layout file
plate_file <- system.file("extdata", "CovidOISExPONTENT_CO.csv", package = "SerolyzeR")
plate <- read_luminex_data(plate_file, verbose = FALSE)
#> Could not parse datetime string using default datetime format. Trying other possibilies.
#> Successfully parsed datetime string using order: mdY IMS p
#> Warning: Duplicate sample names detected: S. Renaming to make them unique.
```
