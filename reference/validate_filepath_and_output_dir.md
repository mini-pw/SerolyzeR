# Validate filepath and output_dir

This function validates the filepath and output_dir arguments.

## Usage

``` r
validate_filepath_and_output_dir(
  filename,
  output_dir,
  plate_name,
  suffix,
  extension,
  verbose = TRUE
)
```

## Arguments

- filename:

  (`character(1)`) The path to the file.

- output_dir:

  (`character(1)`) The directory where the file should be saved.

- plate_name:

  (`character(1)`) The name of the plate.

- suffix:

  (`character(1)`) The suffix to be added to the filename if it is not
  provided, e.g. `RAU`.

- extension:

  (`character(1)`) The extension to be added to the filename if it does
  not have one. Passed without a dot, e.g. `csv`.

- verbose:

  (`logical(1)`) A logical value indicating whether the function should
  print additional information.

## Value

An absolute output path.
