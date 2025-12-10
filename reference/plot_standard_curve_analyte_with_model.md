# Plot standard curve of a certain analyte with fitted model

Function plots the values of standard curve samples and the fitted
model.

## Usage

``` r
plot_standard_curve_analyte_with_model(
  plate,
  model,
  data_type = "Median",
  decreasing_rau_order = TRUE,
  log_scale = c("all"),
  plot_asymptote = TRUE,
  plot_test_predictions = TRUE,
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

  Plate object

- model:

  fitted `Model` object, which predictions we want to plot

- data_type:

  Data type of the value we want to plot - the same datatype as in the
  plate file. By default equals to `Median`

- decreasing_rau_order:

  If `TRUE` the RAU values are plotted in decreasing order, `TRUE` by
  default.

- log_scale:

  Which elements on the plot should be displayed in log scale. By
  default `"all"`. If `NULL` or [`c()`](https://rdrr.io/r/base/c.html)
  no log scale is used, if `"all"` or `c("RAU", "MFI")` all elements are
  displayed in log scale.

- plot_asymptote:

  If `TRUE` the asymptotes are plotted, `TRUE` by default

- plot_test_predictions:

  If `TRUE` the predictions for the test samples are plotted, `TRUE` by
  default. The predictions are obtained through extrapolation of the
  model

- plot_blank_mean:

  If `TRUE` the mean of the blank samples is plotted, `TRUE` by default

- plot_rau_bounds:

  If `TRUE` the RAU bounds are plotted, `TRUE` by default

- plot_legend:

  If `TRUE` the legend is plotted, `TRUE` by default

- legend_position:

  the position of the legend, a possible values are
  `c(right, bottom, left, top, none)`. Is not used if `plot_legend`
  equals to `FALSE`.

- verbose:

  If `TRUE` prints messages, `TRUE` by default

- ...:

  Additional arguments passed to the `predict` function

## Value

a ggplot object with the plot

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
model <- create_standard_curve_model_analyte(plate, analyte_name = "Spike_B16172")
plot_standard_curve_analyte_with_model(plate, model, decreasing_rau_order = FALSE)
#> Scale for colour is already present.
#> Adding another scale for colour, which will replace the existing scale.

```
