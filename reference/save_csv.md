# Wrapper for write.table to save CSV files

This wrapper handles locale difference when saving CSV files.

## Usage

``` r
save_csv(df, filepath, row_names_col = "")
```

## Arguments

- df:

  (`data.frame`) A dataframe to be saved as a CSV file.

- filepath:

  (`character(1)`) The path where the CSV file will be saved.

- row_names_col:

  (`character(1)`) The name of the column to store row names. If empty,
  row names are not saved.
