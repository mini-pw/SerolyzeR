# Detect and handle the high dose hook effect

Typically, the MFI values associated with standard curve samples should
decrease as we dilute the samples. However, sometimes in high dilutions,
the MFI presents a non monotonic behavior. In that case, MFI values
associated with dilutions above (or equal to) `high_dose_threshold`
should be removed from the analysis.

For the `nplr` model the recommended number of standard curve samples is
at least 4. If the high dose hook effect is detected but the number of
samples below the `high_dose_threshold` is lower than 4, additional
warning is printed and the samples are not removed.

Warning: High dose hook effect affects which dilution and MFI values are
used to fit the logistic model and by extension affects the maximum
value to which the predicted RAU MFI values are extrapolated /
truncated.

The function returns a logical vector that can be used to subset the MFI
values.

## Usage

``` r
handle_high_dose_hook(mfi, dilutions, high_dose_threshold = 1/200)
```

## Arguments

- mfi:

  ([`numeric()`](https://rdrr.io/r/base/numeric.html))

- dilutions:

  ([`numeric()`](https://rdrr.io/r/base/numeric.html))

- high_dose_threshold:

  (`numeric(1)`) MFI values associated with dilutions above this
  threshold should be checked for the high dose hook effect

## Value

sample selector ([`logical()`](https://rdrr.io/r/base/logical.html))

## References

Namburi, R. P. et. al. (2014) High-dose hook effect. DOI:
10.4103/2277-8632.128412

## Examples

``` r
plate_filepath <- system.file(
  "extdata", "CovidOISExPONTENT.csv",
  package = "SerolyzeR", mustWork = TRUE
) # get the filepath of the csv dataset
layout_filepath <- system.file(
  "extdata", "CovidOISExPONTENT_layout.xlsx",
  package = "SerolyzeR", mustWork = TRUE
)
plate <- read_luminex_data(plate_filepath, layout_filepath) # read the data
#> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/CovidOISExPONTENT.csv
#> using format xPONENT
#> Failed to extract from BatchMetadata: BatchStartTime not found in BatchMetadata.
#> BatchStartTime successfully extracted from the header.
#> Could not parse datetime string using default datetime format. Trying other possibilies.
#> Successfully parsed datetime string using order: mdY IMS p
#> 
#> New plate object has been created with name: CovidOISExPONTENT!
#> 

# here we plot the data with observed high dose hook effect
plot_standard_curve_analyte(plate, "RBD_omicron")


# here we create the model with the high dose hook effect handled
model <- create_standard_curve_model_analyte(plate, "RBD_omicron")
#> Warning: High dose hook detected.
#>         Removing samples with dilutions above the high dose threshold.
```
