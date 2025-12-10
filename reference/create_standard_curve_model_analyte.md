# Create a standard curve model for a certain analyte

Create a standard curve model for a certain analyte

## Usage

``` r
create_standard_curve_model_analyte(
  plate,
  analyte_name,
  data_type = "Median",
  source_mfi_range_from_all_analytes = FALSE,
  detect_high_dose_hook = TRUE,
  ...
)
```

## Arguments

- plate:

  ([`Plate()`](https://mini-pw.github.io/SerolyzeR/reference/Plate.md))
  Object of the Plate class

- analyte_name:

  (`character(1)`) Name of the analyte for which we want to create the
  model

- data_type:

  (`character(1)`) Data type of the value we want to use to fit the
  model - the same datatype as in the plate file. By default, it equals
  to `Median`

- source_mfi_range_from_all_analytes:

  (`logical(1)`) If `TRUE`, the MFI range is calculated from all
  analytes; if `FALSE`, the MFI range is calculated only for the current
  analyte Defaults to `FALSE`

- detect_high_dose_hook:

  (`logical(1)`) If `TRUE`, the high dose hook effect is detected and
  handled. For more information, please see the
  [handle_high_dose_hook](https://mini-pw.github.io/SerolyzeR/reference/handle_high_dose_hook.md)
  function documentation.

- ...:

  Additional arguments passed to the model

  Standard curve samples should not contain `na` values in mfi values
  nor in dilutions.

## Value

([`Model()`](https://mini-pw.github.io/SerolyzeR/reference/Model.md))
Standard Curve model
