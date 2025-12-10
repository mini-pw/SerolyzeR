# Standard curve thumbnail for report

Function generates a thumbnail of the standard curve for a given
analyte. The thumbnail is used in the plate report. It doesn't have any
additional parameters, because it is used only internally.

## Usage

``` r
plot_standard_curve_thumbnail(plate, analyte_name, data_type = "Median")
```

## Arguments

- plate:

  Plate object

- analyte_name:

  Name of the analyte of which standard curve we want to plot.

- data_type:

  Data type of the value we want to plot - the same types as in the
  plate file. By default equals to `median`

## Value

ggplot object with the plot
