# Handle differences in datetimes

Handle differences in the datetime format between xPONENT and
INTELLIFLEX and output POSIXct datetime object containing the correct
datetime with the default timezone.

## Usage

``` r
handle_datetime(datetime_str, file_format = "xPONENT")
```

## Arguments

- datetime_str:

  The datetime string to parse

- file_format:

  The format of the file. Select from: xPONENT, INTELLIFLEX

## Value

POSIXct datetime object
