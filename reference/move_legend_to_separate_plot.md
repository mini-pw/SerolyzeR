# Create a ggplot with legend in a separate plot

Using cowplot, this function extracts the legend from a ggplot object
and places it in a separate plot below the original plot without the
legend. This is useful for creating cleaner visualizations where the
legend is displayed separately.

## Usage

``` r
move_legend_to_separate_plot(plot, legend_rel_height = 0.4)
```

## Arguments

- plot:

  (`ggplot`) A ggplot object whose legend is to be separated.

- legend_rel_height:

  (`numeric(1)`) A numeric value indicating the relative height of the
  legend plot compared to the main plot. Default is 0.4.

## Value

A ggplot object with the legend placed in a separate plot.
