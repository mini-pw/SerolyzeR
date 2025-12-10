# Check validity of given sample type

Check if the sample type is valid. The sample type is valid if it is one
of the elements of the `VALID_SAMPLE_TYPES` vector. The valid sample
types are:

`c(ALL, BLANK, TEST, NEGATIVE CONTROL, STANDARD CURVE, POSITIVE CONTROL)`.

## Usage

``` r
is_valid_sample_type(sample_type)
```

## Arguments

- sample_type:

  A string representing the sample type.

## Value

`TRUE` if the sample type is valid, `FALSE` otherwise.
