# Merge Normalised Data from Multiple Plates

This function merges normalised data from a list of
[`Plate`](https://mini-pw.github.io/SerolyzeR/reference/Plate.md)
objects into a single `data.frame`. It supports different normalisation
types and handles column mismatches based on the specified strategy.

## Usage

``` r
merge_plate_outputs(
  plates,
  normalisation_type,
  column_collision_strategy = "intersection",
  verbose = TRUE,
  ...
)
```

## Arguments

- plates:

  A named list of
  [`Plate`](https://mini-pw.github.io/SerolyzeR/reference/Plate.md)
  objects, typically returned by
  [`process_dir()`](https://mini-pw.github.io/SerolyzeR/reference/process_dir.md)
  with parameter `return_plates = TRUE`.

- normalisation_type:

  (`character(1)`) The type of normalisation to merge. Options: `"MFI"`,
  `"RAU"`, `"nMFI"`.

- column_collision_strategy:

  (`character(1)`, default = `"intersection"`)

  - Determines how to handle mismatched columns across plates.

  - Options: `"intersection"` (only shared columns), `"union"` (include
    all columns).

- verbose:

  (`logical(1)`, default = `TRUE`) Whether to print verbose output.

- ...:

  Additional arguments passed to
  [`process_plate()`](https://mini-pw.github.io/SerolyzeR/reference/process_plate.md),
  such as `sample_type_filter = "TEST"` to include only certain sample
  types in the merged result.

## Value

A merged `data.frame` containing normalised data across all plates.

## Examples

``` r
# creating temporary directory for the example
output_dir <- tempdir(check = TRUE)

dir_with_luminex_files <- system.file("extdata", "multiplate_reallife_reduced",
  package = "SerolyzeR", mustWork = TRUE
)
list_of_plates <- process_dir(dir_with_luminex_files,
  return_plates = TRUE, format = "xPONENT", output_dir = output_dir
)
#> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/multiplate_reallife_reduced/IGG_CO_1_xponent.csv
#> using format xPONENT
#> Failed to extract from BatchMetadata: BatchStartTime not found in BatchMetadata.
#> Failed to extract from raw header: BatchStartTime not found in raw header.
#> Fallback datetime successfully extracted from ProgramMetadata.
#> Could not parse datetime string using default datetime format. Trying other possibilies.
#> Successfully parsed datetime string using order: mdY IM p
#> 
#> New plate object has been created with name: IGG_CO_1_xponent!
#> 
#> Processing plate 'IGG_CO_1_xponent'
#> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/multiplate_reallife_reduced/IGG_CO_2_xponent.csv
#> using format xPONENT
#> Failed to extract from BatchMetadata: BatchStartTime not found in BatchMetadata.
#> BatchStartTime successfully extracted from the header.
#> Could not parse datetime string using default datetime format. Trying other possibilies.
#> Successfully parsed datetime string using order: mdY IMS p
#> 
#> New plate object has been created with name: IGG_CO_2_xponent!
#> 
#> Processing plate 'IGG_CO_2_xponent'
#> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/multiplate_reallife_reduced/IGG_CO_3_xponent.csv
#> using format xPONENT
#> Failed to extract from BatchMetadata: BatchStartTime not found in BatchMetadata.
#> BatchStartTime successfully extracted from the header.
#> Could not parse datetime string using default datetime format. Trying other possibilies.
#> Successfully parsed datetime string using order: mdY IMS p
#> 
#> New plate object has been created with name: IGG_CO_3_xponent!
#> 
#> Processing plate 'IGG_CO_3_xponent'
#> Extracting the raw MFI to the output dataframe
#> Extracting the raw MFI to the output dataframe
#> Extracting the raw MFI to the output dataframe
#> Merged output saved to: /tmp/RtmpHRzMKG/merged_MFI_20251210_094756.csv
#> Fitting the models and predicting RAU for each analyte
#> Fitting the models and predicting RAU for each analyte
#> Fitting the models and predicting RAU for each analyte
#> Merged output saved to: /tmp/RtmpHRzMKG/merged_RAU_20251210_094756.csv
#> Computing nMFI values for each analyte
#> Computing nMFI values for each analyte
#> Computing nMFI values for each analyte
#> Merged output saved to: /tmp/RtmpHRzMKG/merged_nMFI_20251210_094756.csv

df <- merge_plate_outputs(list_of_plates, "RAU", sample_type_filter = c("TEST", "STANDARD CURVE"))
#> Fitting the models and predicting RAU for each analyte
#> Fitting the models and predicting RAU for each analyte
#> Fitting the models and predicting RAU for each analyte
```
