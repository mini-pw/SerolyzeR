# Read the xPONENT format data

Read the xPONENT format data

## Usage

``` r
read_xponent_format(
  path,
  exact_parse = FALSE,
  encoding = "utf-8",
  separator = ",",
  verbose = TRUE
)
```

## Arguments

- path:

  Path to the xPONENT file

- exact_parse:

  Whether to parse the file exactly or not Exact parsing means that the
  batch, calibration and assay metadata will be parsed as well

- encoding:

  Encoding of the file

- separator:

  Separator for the CSV values

- verbose:

  Whether to print the progress. Default is `TRUE`
