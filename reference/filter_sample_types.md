# Filter Samples by Sample Type

This function returns a logical vector indicating which samples in the
plate match the specified `sample_type_filter`. It is typically used for
subsetting sample-related data such as MFI values, layout, or names.

If `sample_type_filter` is set to `"ALL"`, all sample types are
considered valid.

## Usage

``` r
filter_sample_types(sample_types, sample_type_filter)
```

## Arguments

- sample_types:

  (`character`) A character vector of sample types for each sample in
  the plate. Must by a valid sample type  
  `c(ALL, BLANK, TEST, NEGATIVE CONTROL, STANDARD CURVE, POSITIVE CONTROL)`.

- sample_type_filter:

  (`character`) A vector of desired sample types to select (e.g.,
  `"TEST"`, `"BLANK"`). If `"ALL"` is within the vector, it returns all
  the samples.

## Value

A logical vector the same length as `sample_types`, indicating which
samples match.
