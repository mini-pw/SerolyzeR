# Check validity of given data type

Check if the data type is valid. The data type is valid if it is one of
the elements of the `VALID_DATA_TYPES` vector. The valid data types
are:  
`c(Median, Net MFI, Count, Avg Net MFI, Mean, Peak)`.

## Usage

``` r
is_valid_data_type(data_type)
```

## Arguments

- data_type:

  A string representing the data type.

## Value

`TRUE` if the data type is valid, `FALSE` otherwise.
