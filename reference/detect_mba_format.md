# Try to detect the format of a file

Try to detect the format of a file

## Usage

``` r
detect_mba_format(filepath, format = NULL)
```

## Arguments

- filepath:

  (`character(1)`) The path to the file.

- format:

  (`character(1)`, optional) If not `NULL`, the function will check if
  the provided format is valid and return it. If `NULL`, the function
  will attempt to detect the format based on the filename. The default
  is `NULL`.
