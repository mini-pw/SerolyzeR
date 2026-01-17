# Raw data parsers

## Introduction

Our package primarily aims to read, perform quality control, and
normalise raw MBA data. The entire package is made to be as
user-friendly as possible, so in most of your code, you will read the
data from xPONENT, INTELLIFLEX or BIOPLEX file using the
`read_luminex_data` function and interacting with the created `Plate`
object.

Under the hood, the `read_luminex_data` function uses a specific
function to read data from a given format and later standardises this
output to finally create a `Plate` object.

This article will go deeper into the details of our data parsers,
illustrate how the reading system works and show you how to use them
even outside the SerolyzeR package.

## Basic data loading

The simplest way of loading a file is to use the `read_luminex_data`
function with default values.

``` r
library(SerolyzeR)

plate_filepath <- system.file("extdata", "CovidOISExPONTENT.csv", package = "SerolyzeR", mustWork = TRUE)
layout_filepath <- system.file("extdata", "CovidOISExPONTENT_layout.xlsx", package = "SerolyzeR", mustWork = TRUE)
plate <- read_luminex_data(plate_filepath, layout_filepath)
```

    #> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/CovidOISExPONTENT.csv
    #> using format xPONENT

    #> 
    #> New plate object has been created with name: CovidOISExPONTENT!
    #> 

``` r
summary(plate)
```

    #> Summary of the plate with name 'CovidOISExPONTENT':
    #> Plate examination date: 2022-05-12 18:17:40
    #> Total number of samples: 96
    #> Number of blank samples: 1
    #> Number of standard curve samples: 11
    #> Number of positive control samples: 0
    #> Number of negative control samples: 0
    #> Number of test samples: 84
    #> Number of analytes: 30

``` r
# display a sample of the dataframe
data.frame(plate)[c(1, 2), c(1, 2)]
```

    #>   Spike_6P   ME
    #> 1       24   33
    #> 2    14256 1263

The function has many parameters that can be used to customise the
reading process.

For example, we can change the data type we want to find in the file. By
default, the datatype we are looking for is the Median MFI value. This
default value can be changed, e.g. for the Mean value, as illustrated
below. In this way, we provide more flexibility to the user.

``` r
plate <- read_luminex_data(plate_filepath, layout_filepath, default_data_type = "Mean")
```

    #> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/CovidOISExPONTENT.csv
    #> using format xPONENT

    #> 
    #> New plate object has been created with name: CovidOISExPONTENT!
    #> 

``` r
summary(plate)
```

    #> Summary of the plate with name 'CovidOISExPONTENT':
    #> Plate examination date: 2022-05-12 18:17:40
    #> Total number of samples: 96
    #> Number of blank samples: 1
    #> Number of standard curve samples: 11
    #> Number of positive control samples: 0
    #> Number of negative control samples: 0
    #> Number of test samples: 84
    #> Number of analytes: 30

``` r
# display a sample of the dataframe
data.frame(plate)[c(1, 2), c(1, 2)]
```

    #>   Spike_6P      ME
    #> 1    25.13   32.29
    #> 2 13681.42 1352.75

For the complete list of parameters and their description, please refer
to the `read_luminex_data` documentation.

## SerolyzeR as an MBA data reader

The `read_luminex_data` function enforces additional constraints on the
raw MBA data, such as the sample names following a specific pattern to
be correctly classified. If your data does not follow our standards but
you still want to use our parsers, you can directly use the
format-specific functions here: - `read_xponent_format` -
`read_intelliflex_format` - `read_bioplex_format`

For example, let us read the xPONENT file above using the
`read_xponent_format`.

``` r
output <- read_xponent_format(plate_filepath)
typeof(output)
```

    #> [1] "list"

``` r
names(output)
```

    #> [1] "ProgramMetadata" "Header"          "Samples"         "Min Events"     
    #> [5] "Per Bead"        "Results"         "CRC32"

``` r
output[["ProgramMetadata"]]
```

    #> $Program
    #> [1] "xPONENT"
    #> 
    #> $Build
    #> [1] "4.2.1705.0"
    #> 
    #> $Date
    #> [1] "05/11/2022"
    #> 
    #> $Time
    #> [1] "4:45 PM"
    #> 
    #> $SN
    #> [1] "MAGPX16145704"
    #> 
    #> $Batch
    #> [1] "IgG_CovidOiseS4_30plex_plate5_20220511"

``` r
names(output[["Results"]])
```

    #>  [1] "Median"                       "Net MFI"                     
    #>  [3] "Count"                        "Avg Net MFI"                 
    #>  [5] "Mean"                         "%CV"                         
    #>  [7] "Peak"                         "Std Dev"                     
    #>  [9] "Trimmed Count"                "Trimmed Mean"                
    #> [11] "Trimmed % CV of Microspheres" "Trimmed Peak"                
    #> [13] "Trimmed Standard Deviation"   "Units"                       
    #> [15] "Per Bead Count"               "Acquisition Time"            
    #> [17] "Dilution Factor"              "Analysis Types"              
    #> [19] "Audit Logs"                   "Warnings/Errors"

``` r
# sample of the data
output[["Results"]][["Median"]][c(1, 2), c(1, 2, 3)]
```

    #>   Location Sample Spike_6P
    #> 1  1(1,A1)      B       24
    #> 2  2(1,A2)      S    14256

We can see now that the output of that function is a nested list
containing the information parsed from the file. As the structure of the
output may be different across the formats, this is not the recommended
way to read the data, but the package is open enough to allow you to do
so.
