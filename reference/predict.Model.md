# Predict the RAU values from the MFI values

More details can be found here:
[Model](https://mini-pw.github.io/SerolyzeR/reference/Model.md)

## Usage

``` r
# S3 method for class 'Model'
predict(object, mfi, ...)
```

## Arguments

- object:

  ([`Model()`](https://mini-pw.github.io/SerolyzeR/reference/Model.md))
  Object of the Model class

- mfi:

  ([`numeric()`](https://rdrr.io/r/base/numeric.html)) MFI values for
  which we want to predict the RAU values Should be in the same scale as
  the MFI values used to fit the model

- ...:

  Additional arguments passed to the method

## Value

([`data.frame()`](https://rdrr.io/r/base/data.frame.html))
