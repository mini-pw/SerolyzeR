# Check if a mba format is supported

Check if a given format is supported.

## Usage

``` r
is_mba_format(format, allow_nullable = FALSE)
```

## Arguments

- format:

  (`character(1`) Format string

- allow_nullable:

  (`logical(1)`) Set to `TRUE` if a format can be NULL Defaults to
  `FALSE`.

## Value

(`logical(1)`) `TRUE` if the format is in the supported list, else
`FALSE`
