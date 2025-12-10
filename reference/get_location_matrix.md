# Generate the matrix of plate locations

The function generates a matrix of plate locations. The locations are
represented in a nrow x ncol matrix. Usually number of rows equals to 8
and number of columns to 12, and the total matrix size is 96.

The fields are represented as `E3`, where the letter corresponds to the
row and the number to the column.

## Usage

``` r
get_location_matrix(nrow = 8, ncol = 12, as_vector = FALSE)
```

## Arguments

- nrow:

  Number of rows in the plate

- ncol:

  Number of columns in the plate

- as_vector:

  logical value indicating whether to return the locations as a vector

## Value

a matrix with locations
