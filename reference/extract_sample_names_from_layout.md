# Extract sample names from layout

Function extracts sample names from the layout file based on the
provided locations. Function assumes that the plate is 96-well and
extracts the sample names according to the provided location strings.

## Usage

``` r
extract_sample_names_from_layout(layout_names, locations)
```

## Arguments

- layout_names:

  a vector of sample names from the layout file

- locations:

  a vector of locations in the form of A1, B2, etc.
