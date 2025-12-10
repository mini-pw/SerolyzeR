# Extract the experiment date from xPONENT raw output

This method extracts the real experiment date - BatchStartTime, which
corresponds to the time when the experiment was conducted.

The Date in the top of the xPONENT file refers to the moment when the
CSV xPONENT file was exported from the system

In case the file was parsed with an `exact_parse` parameter, it looks
for a parameter in a BatchMetadata list. Otherwise it tries to read it
from the raw header.

In case this method fails, it fails back to read the Date from the file

## Usage

``` r
extract_xponent_experiment_date(xponent_output, verbose = TRUE)
```

## Arguments

- xponent_output:

  The xPONENT output list to be processed.

- verbose:

  Logical, whether to print messages (default: TRUE)

## Value

A character string representing the datetime of the experiment
