# Format dilutions

The function counts the number of times each dilution factor appears and
sorts them in descending order based on the corresponding dilution
values. The output is a string that lists the dilution factors and their
counts in the format `count x dilution_factor`. If the dilutions vector
looks like `c("1/2", "1/2", "1/2", "1/3", "1/3", "1/4")`, the output
will be `"3x1/2, 2x1/3, 1x1/4"`.

## Usage

``` r
format_dilutions(dilutions, dilution_values, sample_types)
```

## Arguments

- dilutions:

  A vector of dilution factors, taken from plate object.

- dilution_values:

  A vector of dilution values corresponding to the dilution factors,
  taken from plate object. Used only for sorting purposes.

- sample_types:

  A vector of sample types taken from plate object.

## Value

A formatted string that lists the dilution factors and their counts.
Returns `NULL` if `dilutions` is `NULL`.
