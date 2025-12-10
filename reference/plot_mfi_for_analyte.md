# Plot MFI value distribution for a given analyte

Plot MFI value distribution for a given analyte

## Usage

``` r
plot_mfi_for_analyte(
  plate,
  analyte_name,
  data_type = "Median",
  plot_type = "violin",
  scale_y = "log10",
  plot_outliers = FALSE,
  ...
)
```

## Arguments

- plate:

  A plate object

- analyte_name:

  The analyte to plot

- data_type:

  The type of data to plot. Default is "Median"

- plot_type:

  The type of plot to generate. Default is "violin". Available options
  are "boxplot" and "violin".

- scale_y:

  What kind of transformation of the scale to apply. By default MFI is
  presented in a "log10" scale. Available options are described in the
  documentation of
  [scale_y_continuous](https://ggplot2.tidyverse.org/reference/scale_continuous.html)
  under`transform` parameter.

- plot_outliers:

  When using "boxplot" type of a plot one can set this parameter to TRUE
  and display the names of samples for which MFI falls outside the 1.5
  IQR interval

- ...:

  Additional parameters, ignored here. Used here only for consistency
  with the SerolyzeR pipeline

## Value

A ggplot object
