# Select Columns from a DataFrame

Selects specified columns from a dataframe. If a column does not exist
in the dataframe, it will be added with a specified replacement value.

## Usage

``` r
select_columns(df, columns, replace_value = NA)
```

## Arguments

- df:

  A dataframe from which columns are to be selected.

- columns:

  A vector of column names to select.

- replace_value:

  Value to use for columns that do not exist in the dataframe. Default
  is NA.

## Value

A dataframe containing the specified columns, with missing columns
filled with the replacement value.
