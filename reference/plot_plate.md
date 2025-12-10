# Plot a 96-well plate with coloured wells

It is a generic function to plot a 96-well plate with coloured wells
used by other functions in this package, mainly to plot layout and
counts. The function uses a background image of a 96-well plate and
plots the colours in the wells using ggplot2. This function is not
intended for the user to use directly. Rather, it is used by other
functions specified in this file.

## Usage

``` r
plot_plate(
  colours,
  plot_numbers = FALSE,
  numbers = NULL,
  plot_title = "Plate",
  plot_legend = FALSE,
  legend_mapping = NULL
)
```

## Arguments

- colours:

  A vector with 96 colours will be used to colour the wells; the order
  is from left to right and top to bottom

- plot_numbers:

  Logical value indicating if the well numbers should be plotted,
  default is `FALSE`

- numbers:

  An optional vector with 96 numbers plotted on the wells. Order is from
  left to right and top to bottom and must have the same length as
  colours. It could be used, for instance, to plot the bead count of
  each well. Must be provided in case the `plot_numbers` parameter is
  set to `TRUE`

- plot_title:

  The title of the plot (default is "Plate")

- plot_legend:

  Logical value indicating if the legend should be plotted, default is
  `FALSE`

- legend_mapping:

  A named vector with the colour mapping used to create the legend

## Value

A ggplot object
