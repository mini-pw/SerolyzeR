# Extract dilutions from the layout representation

Extract dilution factor represented as string from vector of characters.
The matches has to be exact and the dilution factor has to be in the
form of `1/\d+`

## Usage

``` r
extract_dilutions_from_layout(dilutions)
```

## Arguments

- dilutions:

  vector of dilutions used during the examination due to the nature of
  data it's a vector of strings, the numeric vales are created from
  those strings
