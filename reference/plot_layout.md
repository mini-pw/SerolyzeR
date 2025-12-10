# Plot layout of a 96-well plate

This function plots the layout of a 96-well plate using a colour to
represent the sample types.  
  
If the plot window is resized, it's best to re-run the function to
adjust the scaling. Sometimes, the whole layout may be shifted when a
legend is plotted. It's best to stretch the window, and everything will
be adjusted automatically.

## Usage

``` r
plot_layout(plate, plot_legend = TRUE)
```

## Arguments

- plate:

  The plate object with the layout information

- plot_legend:

  Logical indicating if the legend should be plotted

## Value

A ggplot object

## Examples

``` r
plate_filepath <- system.file("extdata", "CovidOISExPONTENT_CO.csv",
  package = "SerolyzeR", mustWork = TRUE
)
layout_filepath <- system.file("extdata", "CovidOISExPONTENT_CO_layout.xlsx",
  package = "SerolyzeR", mustWork = TRUE
)
plate <- read_luminex_data(plate_filepath, layout_filepath)
#> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/CovidOISExPONTENT_CO.csv
#> using format xPONENT
#> Failed to extract from BatchMetadata: BatchStartTime not found in BatchMetadata.
#> BatchStartTime successfully extracted from the header.
#> Could not parse datetime string using default datetime format. Trying other possibilies.
#> Successfully parsed datetime string using order: mdY IMS p
#> 
#> New plate object has been created with name: CovidOISExPONTENT_CO!
#> 
plot_layout(plate = plate, plot_legend = TRUE)

```
