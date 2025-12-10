# Try cast dataframe columns as numeric

This function attempts to convert each column of a dataframe to numeric.
Additionally, it replaces commas with dots to handle decimal separators.

If at any point of the conversion a Nan value is detected, where it was
not present in the original column, then the original column is
retained.

## Usage

``` r
try_cast_as_numeric(dataframe)
```

## Arguments

- dataframe:

  (`data.frame`) A dataframe whose columns are to be converted to
  numeric.

## Value

A dataframe with columns converted to numeric where possible.
