# Standard curves

Plot standard curve samples of a plate of a given analyte.

## Usage

``` r
plot_standard_curve_analyte(
  plate,
  analyte_name,
  data_type = "Median",
  decreasing_rau_order = TRUE,
  log_scale = c("all"),
  plot_line = TRUE,
  plot_blank_mean = TRUE,
  plot_rau_bounds = TRUE,
  plot_legend = TRUE,
  legend_position = "bottom",
  verbose = TRUE,
  ...
)
```

## Arguments

- plate:

  A plate object

- analyte_name:

  Name of the analyte of which standard curve we want to plot.

- data_type:

  Data type of the value we want to plot - the same datatype as in the
  plate file. By default equals to `Net MFI`

- decreasing_rau_order:

  If `TRUE` the RAU values are plotted in decreasing order, `TRUE` by
  default

- log_scale:

  Which elements on the plot should be displayed in log scale. By
  default `"RAU"`. If `NULL` or [`c()`](https://rdrr.io/r/base/c.html)
  no log scale is used, if `"all"` or `c("RAU", "MFI")` all elements are
  displayed in log scale.

- plot_line:

  If `TRUE` a line is plotted, `TRUE` by default

- plot_blank_mean:

  If `TRUE` the mean of the blank samples is plotted, `TRUE` by default

- plot_rau_bounds:

  If `TRUE` the RAU values bounds are plotted, `TRUE` by default

- plot_legend:

  If `TRUE` the legend is plotted, `TRUE` by default

- legend_position:

  the position of the legend, a possible values are
  `c(right, bottom, left, top, none)`. Is not used if `plot_legend`
  equals to `FALSE`.

- verbose:

  If `TRUE` prints messages, `TRUE` by default

- ...:

  Additional parameters, ignored here. Used here only for consistency
  with the SerolyzeR pipeline

## Value

ggplot object with the plot

## Examples

``` r
path <- system.file("extdata", "CovidOISExPONTENT.csv",
  package = "SerolyzeR", mustWork = TRUE
)
layout_path <- system.file("extdata", "CovidOISExPONTENT_layout.xlsx",
  package = "SerolyzeR", mustWork = TRUE
)
plate <- read_luminex_data(path, layout_filepath = layout_path, verbose = FALSE)
#> Could not parse datetime string using default datetime format. Trying other possibilies.
#> Successfully parsed datetime string using order: mdY IMS p
plot_standard_curve_analyte(plate, "Spike_6P", plot_legend = FALSE, data_type = "Median")
#> legend_position parameter is specified, but the plot_legend is disabled. Won't show the legend.

```
