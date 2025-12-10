# Calculate Normalised MFI (nMFI) Values for a Plate

Calculates normalised MFI (nMFI) values for each analyte in a Luminex
plate. The nMFI values are computed as the ratio of each test sample's
MFI to the MFI of a standard curve sample at a specified reference
dilution.

## Usage

``` r
get_nmfi(
  plate,
  reference_dilution = 1/400,
  data_type = "Median",
  sample_type_filter = "ALL",
  verbose = TRUE
)
```

## Arguments

- plate:

  ([`Plate()`](https://mini-pw.github.io/SerolyzeR/reference/Plate.md))
  a plate object for which to calculate the nMFI values

- reference_dilution:

  (`numeric(1) or character(1)`) the dilution value of the standard
  curve sample to use as a reference for normalisation. The default is
  `1/400`. It should refer to a dilution of a standard curve sample in
  the given plate object. This parameter could be either a numeric value
  or a string. In case it is a character string, it should have format
  `1/d+`, where `d+` is any positive integer.

- data_type:

  (`character(1)`) type of data for the computation. Median is the
  default

- sample_type_filter:

  ([`character()`](https://rdrr.io/r/base/character.html)) The types of
  samples to normalise. (e.g., `"TEST"`, `"STANDARD CURVE"`). It can
  also be a vector of sample types. In that case, dataframe with
  multiple sample types will be returned. The default value is `"ALL"`,
  which corresponds to returning all the samples.

- verbose:

  (`logical(1)`) print additional information. The default is `TRUE`

## Value

nmfi (`data.frame`) a data frame with normalised MFI values for each
analyte in the plate and all test samples.

## Details

Normalised MFI (nMFI) is a simple, model-free metric used to compare
test sample responses relative to a fixed concentration from the
standard curve. It is particularly useful when model fitting (e.g., for
RAU calculation) is unreliable or not possible, such as when test sample
intensities fall outside the standard curve range.

The function locates standard samples with the specified dilution and
divides each test sample’s MFI by the corresponding standard MFI value
for each analyte.

## When Should nMFI Be Used?

While RAU values are generally preferred for antibody quantification,
they require successful model fitting of the standard curve. This may
not be feasible when:

- The test samples produce MFI values outside the range of the standard
  curve.

- The standard curve is poorly shaped or missing critical points.

In such cases, nMFI serves as a useful alternative, allowing for
plate-to-plate comparison without the need for extrapolation.

## References

L. Y. Chan, E. K. Yim, and A. B. Choo, Normalized median fluorescence:
An alternative flow cytometry analysis method for tracking human
embryonic stem cell states during differentiation,
http://dx.doi.org/10.1089/ten.tec.2012.0150

## Examples

``` r
# read the plate
plate_file <- system.file("extdata", "CovidOISExPONTENT.csv", package = "SerolyzeR")
layout_file <- system.file("extdata", "CovidOISExPONTENT_layout.csv", package = "SerolyzeR")

plate <- read_luminex_data(plate_file, layout_file)
#> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/CovidOISExPONTENT.csv
#> using format xPONENT
#> Failed to extract from BatchMetadata: BatchStartTime not found in BatchMetadata.
#> BatchStartTime successfully extracted from the header.
#> Could not parse datetime string using default datetime format. Trying other possibilies.
#> Successfully parsed datetime string using order: mdY IMS p
#> 
#> New plate object has been created with name: CovidOISExPONTENT!
#> 

# artificially bump up the MFI values of the test samples (the Median data type is default one)
plate$data[["Median"]][plate$sample_types == "TEST", ] <-
  plate$data[["Median"]][plate$sample_types == "TEST", ] * 10

# calculate the nMFI values
nmfi <- get_nmfi(plate, reference_dilution = 1 / 400)

# we don't do any extrapolation and the values should be comparable across plates
head(nmfi)
#>          Spike_6P        ME     HKU1_S    OC43_NP     OC43_S   HKU1_NP
#> B     0.006735897 0.1466667 0.03318584 0.03409836 0.06314244 0.0534070
#> 1/50  4.001122649 5.6133333 5.61172566 6.11081967 6.15712188 4.9456722
#> 1/100 2.436289644 2.7000000 2.72953540 2.79934426 2.91042584 2.5681400
#> 1/200 1.824586023 1.8777778 1.83849558 1.82557377 1.92070485 1.7615101
#> 1/400 1.000000000 1.0000000 1.00000000 1.00000000 1.00000000 1.0000000
#> 1/800 0.586444008 0.5911111 0.53539823 0.52065574 0.53671072 0.5893186
#>         X229E_NP  Mumps_NP RBD_B16171    NL63_NP RBD_B16172  RBD_wuhan
#> B     0.06293706 0.3855932  0.1034483 0.01903736 0.04207574 0.02611534
#> 1/50  3.30244755 6.2415254  8.0129310 2.98347701 7.08835905 4.80304679
#> 1/100 1.92482517 2.9067797  3.7198276 1.83477011 3.66339411 2.63039536
#> 1/200 1.64073427 1.7966102  2.1896552 1.47377874 2.15427770 1.73812115
#> 1/400 1.00000000 1.0000000  1.0000000 1.00000000 1.00000000 1.00000000
#> 1/800 0.64335664 0.6822034  0.5323276 0.60488506 0.53436185 0.54406964
#>          NL63_S    X229E_S Spike_B16172 Spike_B117 Measles_NP       Ade5
#> B     0.1410788 0.05323194    0.0151749  0.0113899  0.1103896 0.00410497
#> 1/50  6.0622407 6.22370089    4.7903807  4.0802245  6.0779221 2.82473244
#> 1/100 2.9336100 2.81115336    2.7214506  2.4749092  3.1298701 1.85207448
#> 1/200 1.8568465 1.89860583    1.8137860  1.8420271  2.0259740 1.48116112
#> 1/400 1.0000000 1.00000000    1.0000000  1.0000000  1.0000000 1.00000000
#> 1/800 0.5850622 0.52598226    0.5951646  0.5965665  0.5887446 0.61618531
#>                NP   Spike_P1        Rub      Ade40  RBD_B117 Spike_B1351
#> B     0.005941664 0.01177918 0.04894707 0.03777545 0.1025641  0.01491146
#> 1/50  3.291321570 4.52953586 4.75128059 5.62224554 6.7965812  4.33783784
#> 1/100 2.058786460 2.57383966 2.41605009 2.62644281 3.3623932  2.50093197
#> 1/200 1.558156284 1.93284107 1.77120091 1.80640084 2.0871795  1.90866729
#> 1/400 1.000000000 1.00000000 1.00000000 1.00000000 1.0000000  1.00000000
#> 1/800 0.520885848 0.58368495 0.59817871 0.53725079 0.5777778  0.60764212
#>             FluA RBD_B1351    RBD_P15         S2 Spike_omicron RBD_omicron
#> B     0.02048417 0.1785714 0.09322034 0.04310345    0.07150153   0.1886792
#> 1/50  6.31191806 7.5071429 6.93220339 4.63721264    5.65679265   1.4150943
#> 1/100 2.93389199 3.1357143 3.34322034 2.67385057    2.96935649   1.6509434
#> 1/200 1.95903166 1.9857143 1.94067797 1.78017241    1.99795710   1.5094340
#> 1/400 1.00000000 1.0000000 1.00000000 1.00000000    1.00000000   1.0000000
#> 1/800 0.51769088 0.5857143 0.47881356 0.46767241    0.54954035   0.5377358
# different params
nmfi <- get_nmfi(plate, reference_dilution = "1/50")
nmfi <- get_nmfi(plate, reference_dilution = "1/50", sample_type_filter = c("TEST", "BLANK"))
```
