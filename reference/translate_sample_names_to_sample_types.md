# Translate sample names to sample types

Function translates sample names to sample types based on the sample
name from Luminex file and the sample name from the layout file, which
may not be provided. The function uses regular expressions to match the
sample names to the sample types.

## Usage

``` r
translate_sample_names_to_sample_types(
  sample_names,
  sample_names_from_layout = NULL
)
```

## Arguments

- sample_names:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Vector of sample names from Luminex file

- sample_names_from_layout:

  ([`character()`](https://rdrr.io/r/base/character.html))  
  Vector of sample names from Layout file values in this vector may be
  different than `sample_names` and may contain additional information
  about the sample type like dilution. This vector when set has to have
  at least the length of `sample_names`.

## Value

A vector of valid sample_type strings of length equal to the length of
`sample_names`

## Details

Function assigns SampleType to each of the samples from one of
`c(ALL, BLANK, TEST, NEGATIVE CONTROL, STANDARD CURVE, POSITIVE CONTROL)`.

It parses the names as follows:

If `sample_names` or `sample_names_from_layout` equals to `BLANK`,
`BACKGROUND` or `B`, then SampleType equals to `BLANK`

If `sample_names` or `sample_names_from_layout` equals to
`STANDARD CURVE`, `SC`, `S`, contains substring `1/\d+` and has prefix
` `, `S_`, `S `, `S` or `CP3`, then SampleType equals to
`STANDARD CURVE`. For instance, sample with a name `S_1/2` or `S 1/2`
will be classified as `STANDARD CURVE`.

If `sample_names` or `sample_names_from_layout` equals to
`NEGATIVE CONTROL`, starts with `NEG` (or `Neg`) or ends with `NEG`,
then SampleType equals to `NEGATIVE CONTROL`

If `sample_names` or `sample_names_from_layout` starts with `P` followed
by whitespace, `POS` followed by whitespace, some sample name followed
by substring `1/\d+` SampleType equals to `POSITIVE CONTROL`

Otherwise, the returned SampleType is `TEST`

It also removes any additional suffixes created by
[`make.unique()`](https://rdrr.io/r/base/make.unique.html) method, such
as, `.1`, `.4`.

## Examples

``` r
translate_sample_names_to_sample_types(c("B", "BLANK", "NEG", "TEST1"))
#> [1] "BLANK"            "BLANK"            "NEGATIVE CONTROL" "TEST"            
translate_sample_names_to_sample_types(c("S", "CP3"))
#> [1] "STANDARD CURVE" "TEST"          
```
