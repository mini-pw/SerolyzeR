# Process Plate Data and Save Normalised Output

Processes a Luminex plate and computes normalised values using the
specified `normalisation_type`. Depending on the chosen method, the
function performs blank adjustment, fits models, and extracts values for
test samples. Optionally, the results can be saved as a CSV file.

## Usage

``` r
process_plate(
  plate,
  filename = NULL,
  output_dir = "normalised_data",
  write_output = TRUE,
  normalisation_type = "RAU",
  data_type = "Median",
  sample_type_filter = "ALL",
  blank_adjustment = FALSE,
  verbose = TRUE,
  reference_dilution = 1/400,
  ...
)
```

## Arguments

- plate:

  A [Plate](https://mini-pw.github.io/SerolyzeR/reference/Plate.md)
  object containing raw or processed Luminex data.

- filename:

  (`character(1)`, optional) Output CSV filename. If `NULL`, defaults to
  `"{plate_name}_{normalisation_type}.csv"`. File extension is
  auto-corrected to `.csv` if missing. If an absolute path is given,
  `output_dir` is ignored.

- output_dir:

  (`character(1)`, default = `"normalised_data"`) Directory where the
  CSV will be saved. Will be created if it doesn't exist. If `NULL`, the
  current working directory is used.

- write_output:

  (`logical(1)`, default = `TRUE`) Whether to write the output to disk.

- normalisation_type:

  (`character(1)`, default = `'RAU'`) The normalisation method to apply.

  - Allowed values: `c(MFI, RAU, nMFI)`.

- data_type:

  (`character(1)`, default = `"Median"`) The data type to use for
  normalisation (e.g., `"Median"`).

- sample_type_filter:

  ([`character()`](https://rdrr.io/r/base/character.html)) The types of
  samples to normalise. (e.g., `"TEST"`, `"STANDARD CURVE"`). It can
  also be a vector of sample types. In that case, dataframe with
  multiple sample types will be returned. By default equals to `"ALL"`,
  which corresponds to processing all sample types.

- blank_adjustment:

  (`logical(1)`, default = `FALSE`) Whether to apply blank adjustment
  before processing.

- verbose:

  (`logical(1)`, default = `TRUE`) Whether to print additional
  information during execution.

- reference_dilution:

  (`numeric(1)` or `character(1)`, default = `1/400`) Target dilution
  used for nMFI calculation. Ignored for other types. Can be numeric
  (e.g., `0.0025`) or string (e.g., `"1/400"`).

- ...:

  Additional arguments passed to the model fitting function
  [`create_standard_curve_model_analyte()`](https://mini-pw.github.io/SerolyzeR/reference/create_standard_curve_model_analyte.md)
  and
  [`predict.Model`](https://mini-pw.github.io/SerolyzeR/reference/predict.Model.md)

## Value

A data frame of computed values, with test samples as rows and analytes
as columns.

## Details

Supported normalisation types:

- **RAU** (Relative Antibody Units): Requires model fitting. Produces
  estimates using a standard curve. See
  [`create_standard_curve_model_analyte`](https://mini-pw.github.io/SerolyzeR/reference/create_standard_curve_model_analyte.md)
  for details.

- **nMFI** (Normalised Median Fluorescence Intensity): Requires a
  reference dilution. See
  [`get_nmfi`](https://mini-pw.github.io/SerolyzeR/reference/get_nmfi.md).

- **MFI** (Blank-adjusted Median Fluorescence Intensity): Returns raw
  MFI values (adjusted for blanks, if requested).

## RAU Workflow

1.  Optionally perform blank adjustment.

2.  Fit a model for each analyte using standard curve data.

3.  Predict RAU values for test samples.

4.  Aggregate and optionally save results.

## nMFI Workflow

1.  Optionally perform blank adjustment.

2.  Compute normalised MFI using the `reference_dilution`.

3.  Aggregate and optionally save results.

## MFI Workflow

1.  Optionally perform blank adjustment.

2.  Return adjusted MFI values.

## See also

[`create_standard_curve_model_analyte`](https://mini-pw.github.io/SerolyzeR/reference/create_standard_curve_model_analyte.md),
[`get_nmfi`](https://mini-pw.github.io/SerolyzeR/reference/get_nmfi.md)

## Examples

``` r
plate_file <- system.file("extdata", "CovidOISExPONTENT_CO_reduced.csv", package = "SerolyzeR")
layout_file <- system.file("extdata", "CovidOISExPONTENT_CO_layout.xlsx", package = "SerolyzeR")
plate <- read_luminex_data(plate_file, layout_file, verbose = FALSE)
#> Could not parse datetime string using default datetime format. Trying other possibilies.
#> Successfully parsed datetime string using order: mdY IM p

example_dir <- tempdir(check = TRUE)

# Process using default settings (RAU normalisation)
process_plate(plate, output_dir = example_dir)
#> Warning: The specified file /tmp/RtmpGcElT2/CovidOISExPONTENT_CO_reduced_RAU.csv already exists. Overwriting it.
#> Fitting the models and predicting RAU for each analyte
#> Saving the computed RAU values to a CSV file located in: '/tmp/RtmpGcElT2/CovidOISExPONTENT_CO_reduced_RAU.csv'
#>          Spike_6P_IPP        ME_NA
#> B            1.851528     1.644344
#> 1/50     19996.648321 20000.000000
#> 1/100     9705.250659  9667.884259
#> 1/200     5678.426749  5426.947678
#> 1/400     2261.862587  2280.534363
#> 1/800     1330.755216  1317.032271
#> 1/1600     613.282524   613.240352
#> 1/3200     307.046789   321.809726
#> 1/6400     156.375332   154.951764
#> 1/12800     83.621645    63.012212
#> 1/25600     37.395122    57.745776
#> 1/102400     9.763882     9.141187
#> K086-LM   3292.261006  2128.609832
#> M254-VM     85.387525  5496.431779
#> M199-DS   2841.645046  7169.340839
#> M164-LM    125.426944  3560.958444
#> M265-MM    396.347695  3783.900374
#> K026-DJ     85.135062  1430.546071
#> K137-DT   3142.282230  6567.666626
#> M255-VA     38.783044  1103.720244
#> M258-PA     52.985918  2174.678628
#> M188-VC   1137.877275  1877.696204
#> M270-BF     58.801999   875.658712
#> M050-EL    100.643959  2168.088477
#> M088-GE    145.306377  2892.023989
#> M259-PM   1082.028926  8614.096696
#> K101-PA     73.845028  1777.766318
#> M189-VY    511.614786  2562.331565
#> K018-FC    882.552656  2250.682762
#> M142-RA     54.433682   966.198980
#> K100-CC     42.985631   984.937963
#> K107-RP     32.368412  1138.149335
#> M240-HS     31.465941  1028.676624
#> K019-FM     83.621645  1589.089997
#> M148-PS     61.978638  1216.497661
#> M089-HG   4677.618770  7712.754643
#> K136-DA  20000.000000 17238.789725
#> M241-HR   5532.929109  1279.295237
#> K020-NA  12680.550471  9631.381408
#> M239-HJ     40.410687  2654.197103
#> M092-LS    164.844759  3102.611181
#> M162-PE   4972.480781  5738.510120
#> M260-PM  20000.000000  2370.474570
#> K021-FS     28.782107   635.138793
#> M253-VM     80.350785  1235.324899
#> M198-CN     60.265975  2056.503923
#> M163-PD   3780.094882  6970.373031
#> M264-MA  20000.000000  2197.767771
#> K024-DT    981.887071  2867.689504

# Use a custom filename and skip blank adjustment
process_plate(plate,
  filename = "no_blank.csv",
  output_dir = example_dir,
  blank_adjustment = FALSE
)
#> Fitting the models and predicting RAU for each analyte
#> Saving the computed RAU values to a CSV file located in: '/tmp/RtmpGcElT2/no_blank.csv'
#>          Spike_6P_IPP        ME_NA
#> B            1.851528     1.644344
#> 1/50     19996.648321 20000.000000
#> 1/100     9705.250659  9667.884259
#> 1/200     5678.426749  5426.947678
#> 1/400     2261.862587  2280.534363
#> 1/800     1330.755216  1317.032271
#> 1/1600     613.282524   613.240352
#> 1/3200     307.046789   321.809726
#> 1/6400     156.375332   154.951764
#> 1/12800     83.621645    63.012212
#> 1/25600     37.395122    57.745776
#> 1/102400     9.763882     9.141187
#> K086-LM   3292.261006  2128.609832
#> M254-VM     85.387525  5496.431779
#> M199-DS   2841.645046  7169.340839
#> M164-LM    125.426944  3560.958444
#> M265-MM    396.347695  3783.900374
#> K026-DJ     85.135062  1430.546071
#> K137-DT   3142.282230  6567.666626
#> M255-VA     38.783044  1103.720244
#> M258-PA     52.985918  2174.678628
#> M188-VC   1137.877275  1877.696204
#> M270-BF     58.801999   875.658712
#> M050-EL    100.643959  2168.088477
#> M088-GE    145.306377  2892.023989
#> M259-PM   1082.028926  8614.096696
#> K101-PA     73.845028  1777.766318
#> M189-VY    511.614786  2562.331565
#> K018-FC    882.552656  2250.682762
#> M142-RA     54.433682   966.198980
#> K100-CC     42.985631   984.937963
#> K107-RP     32.368412  1138.149335
#> M240-HS     31.465941  1028.676624
#> K019-FM     83.621645  1589.089997
#> M148-PS     61.978638  1216.497661
#> M089-HG   4677.618770  7712.754643
#> K136-DA  20000.000000 17238.789725
#> M241-HR   5532.929109  1279.295237
#> K020-NA  12680.550471  9631.381408
#> M239-HJ     40.410687  2654.197103
#> M092-LS    164.844759  3102.611181
#> M162-PE   4972.480781  5738.510120
#> M260-PM  20000.000000  2370.474570
#> K021-FS     28.782107   635.138793
#> M253-VM     80.350785  1235.324899
#> M198-CN     60.265975  2056.503923
#> M163-PD   3780.094882  6970.373031
#> M264-MA  20000.000000  2197.767771
#> K024-DT    981.887071  2867.689504

# Use nMFI normalisation with reference dilution
process_plate(plate,
  normalisation_type = "nMFI",
  reference_dilution = "1/400",
  output_dir = example_dir
)
#> Warning: The specified file /tmp/RtmpGcElT2/CovidOISExPONTENT_CO_reduced_nMFI.csv already exists. Overwriting it.
#> Computing nMFI values for each analyte
#> Saving the computed nMFI values to a CSV file located in: '/tmp/RtmpGcElT2/CovidOISExPONTENT_CO_reduced_nMFI.csv'
#>          Spike_6P_IPP      ME_NA
#> B         0.005413105 0.05662806
#> 1/50      3.624643875 4.73359073
#> 1/100     2.610683761 3.13770914
#> 1/200     1.918803419 2.07464607
#> 1/400     1.000000000 1.00000000
#> 1/800     0.648717949 0.61518662
#> 1/1600    0.329914530 0.32561133
#> 1/3200    0.177920228 0.20592021
#> 1/6400    0.098717949 0.13642214
#> 1/12800   0.058689459 0.09523810
#> 1/25600   0.031623932 0.09266409
#> 1/102400  0.012962963 0.06435006
#> K086-LM   1.327207977 0.94079794
#> M254-VM   0.059686610 2.09523810
#> M199-DS   1.190883191 2.55598456
#> M164-LM   0.081908832 1.47232947
#> M265-MM   0.223361823 1.54954955
#> K026-DJ   0.059544160 0.66151866
#> K137-DT   1.282905983 2.39768340
#> M255-VA   0.032478632 0.52767053
#> M258-PA   0.041025641 0.95881596
#> M188-VC   0.567663818 0.84169884
#> M270-BF   0.044444444 0.43371943
#> M050-EL   0.068233618 0.95624196
#> M088-GE   0.092735043 1.23166023
#> M259-PM   0.543589744 2.90604891
#> K101-PA   0.053133903 0.80180180
#> M189-VY   0.280626781 1.10810811
#> K018-FC   0.455270655 0.98841699
#> M142-RA   0.041880342 0.47104247
#> K100-CC   0.035042735 0.47876448
#> K107-RP   0.028490028 0.54182754
#> M240-HS   0.027920228 0.49678250
#> K019-FM   0.058689459 0.72586873
#> M148-PS   0.046296296 0.57400257
#> M089-HG   1.693447293 2.69240669
#> K136-DA   4.106552707 4.39124839
#> M241-HR   1.887749288 0.59974260
#> K020-NA   2.981481481 3.12998713
#> M239-HJ   0.033475783 1.14285714
#> M092-LS   0.103276353 1.30888031
#> M162-PE   1.762820513 2.16602317
#> M260-PM   4.175925926 1.03474903
#> K021-FS   0.026210826 0.33462033
#> M253-VM   0.056837607 0.58172458
#> M198-CN   0.045299145 0.91248391
#> M163-PD   1.464529915 2.50450450
#> M264-MA   5.674928775 0.96782497
#> K024-DT   0.499715100 1.22265122
```
