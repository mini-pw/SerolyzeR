# Logistic regression model for the standard curve

The Model class is a wrapper around the `nplr` model. It allows to
predict the RAU (Relative Antibody Unit) values directly from the MFI
values of a given sample.

The `nplr` model is fitted using the formula: \$\$y = B + \frac{T -
B}{(1 + 10^{b \cdot (x\_{mid} - x)})^s},\$\$

where:

- \\y\\ is the predicted value, MFI in our case,

- \\x\\ is the independent variable, dilution in our case,

- \\B\\ is the bottom plateau - the right horizontal asymptote,

- \\T\\ is the top plateau - the left horizontal asymptote,

- \\b\\ is the slope of the curve at the inflection point,

- \\x\_{mid}\\ is the x-coordinate at the inflection point,

- \\s\\ is the asymmetric coefficient.

This equation is referred to as the Richards' equation. More information
about the model can be found in the `nplr` package documentation.

After the model is fitted to the data, the RAU values can be predicted
using the
[`predict.Model()`](https://mini-pw.github.io/SerolyzeR/reference/predict.Model.md)
method. The RAU value is simply a predicted dilution value (using the
standard curve) for a given MFI multiplied by 1,000 000 to have a more
readable value. For more information about the differences between
dilution, RAU and MFI values, please see [Normalisation section in the
Basic SerolyzeR functionalities
vignette](https://mini-pw.github.io/SerolyzeR/articles/example_script.html#normalisation)
.

## Public fields

- `analyte`:

  (`character(1)`)  
  Name of the analyte for which the model was fitted

- `dilutions`:

  ([`numeric()`](https://rdrr.io/r/base/numeric.html))  
  Dilutions used to fit the model

- `mfi`:

  ([`numeric()`](https://rdrr.io/r/base/numeric.html))  
  MFI values used to fit the model

- `mfi_min`:

  (`numeric(1)`)  
  Minimum MFI used for scaling MFI values to the range \[0, 1\]

- `mfi_max`:

  (`numeric(1)`)  
  Maximum MFI used for scaling MFI values to the range \[0, 1\]

- `model`:

  (`nplr`)  
  Instance of the `nplr` model fitted to the data

- `log_dilution`:

  ([`logical()`](https://rdrr.io/r/base/logical.html))  
  Indicator should the dilutions be transformed using the `log10`
  function

- `log_mfi`:

  ([`logical()`](https://rdrr.io/r/base/logical.html))  
  Indicator should the MFI values be transformed using the `log10`
  function

- `scale_mfi`:

  ([`logical()`](https://rdrr.io/r/base/logical.html))  
  Indicator should the MFI values be scaled to the range \[0, 1\]

## Active bindings

- `top_asymptote`:

  (`numeric(1)`)  
  The top asymptote of the logistic curve

- `bottom_asymptote`:

  (`numeric(1)`)  
  The bottom asymptote of the logistic curve

## Methods

### Public methods

- [`Model$new()`](#method-Model-new)

- [`Model$predict()`](#method-Model-predict)

- [`Model$get_plot_data()`](#method-Model-get_plot_data)

- [`Model$print()`](#method-Model-print)

- [`Model$clone()`](#method-Model-clone)

------------------------------------------------------------------------

### Method `new()`

Create a new instance of Model
[R6](https://r6.r-lib.org/reference/R6Class.html) class

#### Usage

    Model$new(
      analyte,
      dilutions,
      mfi,
      npars = 5,
      verbose = TRUE,
      log_dilution = TRUE,
      log_mfi = TRUE,
      scale_mfi = TRUE,
      mfi_min = NULL,
      mfi_max = NULL,
      ...
    )

#### Arguments

- `analyte`:

  (`character(1)`)  
  Name of the analyte for which the model was fitted.

- `dilutions`:

  ([`numeric()`](https://rdrr.io/r/base/numeric.html))  
  Dilutions used to fit the model

- `mfi`:

  MFI ([`numeric()`](https://rdrr.io/r/base/numeric.html))  
  values used to fit the model

- `npars`:

  (`numeric(1)`)  
  Number of parameters to use in the model

- `verbose`:

  ([`logical()`](https://rdrr.io/r/base/logical.html))  
  If `TRUE` prints messages, `TRUE` by default

- `log_dilution`:

  ([`logical()`](https://rdrr.io/r/base/logical.html))  
  If `TRUE` the dilutions are transformed using the `log10` function,
  `TRUE` by default

- `log_mfi`:

  ([`logical()`](https://rdrr.io/r/base/logical.html))  
  If `TRUE` the MFI values are transformed using the `log10` function,
  `TRUE` by default

- `scale_mfi`:

  ([`logical()`](https://rdrr.io/r/base/logical.html))  
  If `TRUE` the MFI values are scaled to the range \[0, 1\], `TRUE` by
  default

- `mfi_min`:

  (`numeric(1)`)  
  Enables to set the minimum MFI value used for scaling MFI values to
  the range \[0, 1\]. Use values before any transformations (e.g.,
  before the `log10` transformation)

- `mfi_max`:

  (`numeric(1)`)  
  Enables to set the maximum MFI value used for scaling MFI values to
  the range \[0, 1\]. Use values before any transformations (e.g.,
  before the `log10` transformation)

- `...`:

  Additional parameters, ignored here. Used here only for consistency
  with the SerolyzeR pipeline

------------------------------------------------------------------------

### Method [`predict()`](https://rdrr.io/r/stats/predict.html)

Predict RAU values from the MFI values

#### Usage

    Model$predict(mfi, over_max_extrapolation = 0, eps = 1e-06, ...)

#### Arguments

- `mfi`:

  ([`numeric()`](https://rdrr.io/r/base/numeric.html))  
  MFI values for which we want to predict the RAU values

- `over_max_extrapolation`:

  (`numeric(1)`)  
  How much we can extrapolate the values above the maximum RAU value
  seen in standard curve samples \\\text{RAU}\_{max}\\. Defaults to 0.
  If the value of the predicted RAU is above \\RAU\_{max} +
  \text{over\\max\\extrapolation}\\, the value is censored to the value
  of that sum.

- `eps`:

  (`numeric(1)`)  
  A small value used to avoid numerical issues close to the asymptotes

- `...`:

  Additional parameters. This method ignores them, used here for
  compatibility with the pipeline.

  Warning: High dose hook effect affects which dilution and MFI values
  are used to fit the logistic model and by extension affects the
  over_max_extrapolation value. When a high dose hook effect is detected
  we remove the samples with dilutions above the high dose threshold
  (which by default is 1/200). Making the highest RAU value lower than
  the one calculated without handling of the high dose hook effect.

#### Returns

([`data.frame()`](https://rdrr.io/r/base/data.frame.html))  
Dataframe with the predicted RAU values for given MFI values The columns
are named as follows:

- `RAU` - the Relative Antibody Units (RAU) value

- `MFI` - the predicted MFI value

------------------------------------------------------------------------

### Method `get_plot_data()`

Data that can be used to plot the standard curve.

#### Usage

    Model$get_plot_data()

#### Returns

([`data.frame()`](https://rdrr.io/r/base/data.frame.html))  
Prediction dataframe for scaled MFI (or logMFI) values in the range \[0,
1\]. Columns are named as in the `predict` method

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Function prints the basic information about the model such as the number
of parameters or samples used

#### Usage

    Model$print()

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    Model$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.

## Examples

``` r
plate_file <- system.file("extdata", "CovidOISExPONTENT.csv", package = "SerolyzeR")
layout_file <- system.file("extdata", "CovidOISExPONTENT_layout.csv", package = "SerolyzeR")
plate <- read_luminex_data(plate_file, layout_filepath = layout_file)
#> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/CovidOISExPONTENT.csv
#> using format xPONENT
#> Failed to extract from BatchMetadata: BatchStartTime not found in BatchMetadata.
#> BatchStartTime successfully extracted from the header.
#> Could not parse datetime string using default datetime format. Trying other possibilies.
#> Successfully parsed datetime string using order: mdY IMS p
#> 
#> New plate object has been created with name: CovidOISExPONTENT!
#> 
model <- create_standard_curve_model_analyte(plate, "S2", log_mfi = TRUE)
print(model)
#> Instance of the Model class fitted for analyte ' S2 ': 
#>  - fitted with 5 parameters
#>  - using 11 samples
#>  - using log residuals (mfi):  TRUE 
#>  - using log dilution:  TRUE 
#>  - top asymptote: 6587.765 
#>  - bottom asymptote: 24.6534 
#>  - goodness of fit: 0.996416 
#>  - weighted goodness of fit: 0.9998704 
```
