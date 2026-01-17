# Multiplate SerolyzeR functionalities

## Introduction

In this tutorial we are going to cover all the possible options of
reading and writing data from multiple plates implemented in `SerolyzeR`
package.

This tutorial will not be focused on a detailed analysis of the package
functionalities that are designed to analyse a single plate at a time,
as this is already covered in the .

### Reading the data

Firstly, we need to locate our dataset. The `SerolyzeR` package has a
preloaded dataset, which can be found with a command given below:

``` r
base_dir <- system.file("extdata", "multiplate_tutorial", package = "SerolyzeR", mustWork = TRUE) # get the filepath of the directory containing all the files

list.files(base_dir) # list all the files
```

    #>  [1] "P1_SEROPED_PBT_62PLEX_PLATE1_03312023_RUN001_layout.xlsx"
    #>  [2] "P1_SEROPED_PBT_62PLEX_PLATE1_03312023_RUN001.csv"        
    #>  [3] "P10_SEROPED_62PLEX_PLATE10_04062023_RUN004_layout.xlsx"  
    #>  [4] "P10_SEROPED_62PLEX_PLATE10_04062023_RUN004.csv"          
    #>  [5] "P11_SEROPED_62PLEX_PLATE11_04062023_RUN005_layout.xlsx"  
    #>  [6] "P11_SEROPED_62PLEX_PLATE11_04062023_RUN005.csv"          
    #>  [7] "P12_SEROPED_62PLEX_PLATE12_04072023_RUN000_layout.xlsx"  
    #>  [8] "P12_SEROPED_62PLEX_PLATE12_04072023_RUN000.csv"          
    #>  [9] "P13_SEROPED_62PLEX_PLATE13_04072023_RUN001_layout.xlsx"  
    #> [10] "P13_SEROPED_62PLEX_PLATE13_04072023_RUN001.csv"          
    #> [11] "P14_SEROPED_62PLEX_PLATE14_04072023_RUN002_layout.xlsx"  
    #> [12] "P14_SEROPED_62PLEX_PLATE14_04072023_RUN002.csv"          
    #> [13] "P2_SEROPED_62PLEX_PLATE2_04042023_RUN000_layout.xlsx"    
    #> [14] "P2_SEROPED_62PLEX_PLATE2_04042023_RUN000.csv"            
    #> [15] "P3_rerun_SEROPED_PLATE3_04042023_RUN002_layout.xlsx"     
    #> [16] "P3_rerun_SEROPED_PLATE3_04042023_RUN002.csv"             
    #> [17] "P4_SEROPED_62PLEX_PLATE4_04042023_RUN003_layout.xlsx"    
    #> [18] "P4_SEROPED_62PLEX_PLATE4_04042023_RUN003.csv"            
    #> [19] "P5_SEROPED_62PLEX_PLATE5_04052023_RUN001_layout.xlsx"    
    #> [20] "P5_SEROPED_62PLEX_PLATE5_04052023_RUN001.csv"            
    #> [21] "P6_SEROPED_62PLEX_PLATE6_04052023_RUN003_layout.xlsx"    
    #> [22] "P6_SEROPED_62PLEX_PLATE6_04052023_RUN003.csv"            
    #> [23] "P7_SEROPED_62PLEX_PLATE7_04052023_RUN004_layout.xlsx"    
    #> [24] "P7_SEROPED_62PLEX_PLATE7_04052023_RUN004.csv"            
    #> [25] "P8_SEROPED_62PLEX_PLATE8_04052023_RUN005_layout.xlsx"    
    #> [26] "P8_SEROPED_62PLEX_PLATE8_04052023_RUN005.csv"

As you can see, this directory contains multiple files - both raw output
from the multiplex machine and the layout files, that help to identify
the samples on the plate. Each of the plate files, e.g.
`P1_SEROPED_PBT_62PLEX_PLATE1_03312023_RUN001.csv` contains its
corresponding layout file, for instance
`P1_SEROPED_PBT_62PLEX_PLATE1_03312023_RUN001_layout.xlsx` .

We will explain in detail how the directory should be structured in
order to read the data properly in the section below. Let us first read
the directory.

### Reading a whole directory

To read the directory as above, we need to import the library
`SerolyzeR` and run a single command
[`process_dir()`](https://mini-pw.github.io/SerolyzeR/reference/process_dir.md).
This function reads all the files in the directory and processes them.
It has an option to generate 3 tabular outputs (similarly to the
[`process_file()`](https://mini-pw.github.io/SerolyzeR/reference/process_file.md)
function). It is: - MFI (mean fluorescence intensity) - the raw input
MFI values, with optional blank adjustment only - nMFI (normalised mean
fluorescence intensity) - the normalised values, with optional blank
adjustment and normalisation to the reference sample - RAU (relative
antibody units) - the normalised values, with optional blank adjustment
transformed to the relative antibody units

These output types can be selected with the `normalisation_types`
parameter, which is a vector of all tabular outputs to be generated. By
default this parameter equals to all possible values -
`c("RAU", "nMFI", "MFI")`.

Now, we will discuss how this method works and describe its most
important parameters. By default, it saves all the outputs into the
input directory, this can be changed with the `output_dir` parameter. In
this tutorial, we will set the output directory to a temporary
directory, which can be created with the
[`tempdir()`](https://rdrr.io/r/base/tempfile.html) function. We also
specify the format of the input files, which is `xPONENT` in this case.
The `format` parameter can be either set to `xPONENT`, `INTELLIFLEX`,
`BIOPLEX` or `NULL`. In case the format is `NULL`, the function will try
to infer the format based on the filename. For more details, we refer
the reader to the documentation of the \[`process_dir`\] function.

One of the most useful features of the
[`process_dir()`](https://mini-pw.github.io/SerolyzeR/reference/process_dir.md)
function is that it enables us to do all the preprocessing steps in one
go. By setting `merge_outputs` parameter to `TRUE`, the method will
output a single file with all the data from all the plates. This is very
useful when we want to analyse the data from multiple plates at once.

This method also supports automatic generation of HTML reports, which
could be enabled with setting the parameter `generate_reports` to
`TRUE`, for the single plate reports, and `generate_multiplate_report`
to `TRUE`, for the multiplate report. By default both of these values
are set to `FALSE`.

``` r
library(SerolyzeR)

output_dir <- file.path(tempdir(), "multiplate-tutorial") # create a temporary directory to store the output data
R.utils::mkdirs(output_dir)
```

    #> [1] TRUE

``` r
plates <- process_dir(base_dir, format = "xPONENT", normalisation_types = c("RAU", "nMFI", "MFI"), output_dir = output_dir, merge_outputs = TRUE, return_plates = TRUE, generate_reports = FALSE, generate_multiplate_reports = FALSE)
```

    #> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/multiplate_tutorial/P10_SEROPED_62PLEX_PLATE10_04062023_RUN004.csv
    #> using format xPONENT

    #> 
    #> New plate object has been created with name: P10_SEROPED_62PLEX_PLATE10_04062023_RUN004!
    #> 
    #> Processing plate 'P10_SEROPED_62PLEX_PLATE10_04062023_RUN004'
    #> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/multiplate_tutorial/P11_SEROPED_62PLEX_PLATE11_04062023_RUN005.csv
    #> using format xPONENT

    #> 
    #> New plate object has been created with name: P11_SEROPED_62PLEX_PLATE11_04062023_RUN005!
    #> 
    #> Processing plate 'P11_SEROPED_62PLEX_PLATE11_04062023_RUN005'
    #> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/multiplate_tutorial/P12_SEROPED_62PLEX_PLATE12_04072023_RUN000.csv
    #> using format xPONENT

    #> 
    #> New plate object has been created with name: P12_SEROPED_62PLEX_PLATE12_04072023_RUN000!
    #> 
    #> Processing plate 'P12_SEROPED_62PLEX_PLATE12_04072023_RUN000'
    #> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/multiplate_tutorial/P13_SEROPED_62PLEX_PLATE13_04072023_RUN001.csv
    #> using format xPONENT

    #> 
    #> New plate object has been created with name: P13_SEROPED_62PLEX_PLATE13_04072023_RUN001!
    #> 
    #> Processing plate 'P13_SEROPED_62PLEX_PLATE13_04072023_RUN001'
    #> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/multiplate_tutorial/P14_SEROPED_62PLEX_PLATE14_04072023_RUN002.csv
    #> using format xPONENT

    #> 
    #> New plate object has been created with name: P14_SEROPED_62PLEX_PLATE14_04072023_RUN002!
    #> 
    #> Processing plate 'P14_SEROPED_62PLEX_PLATE14_04072023_RUN002'
    #> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/multiplate_tutorial/P1_SEROPED_PBT_62PLEX_PLATE1_03312023_RUN001.csv
    #> using format xPONENT

    #> 
    #> New plate object has been created with name: P1_SEROPED_PBT_62PLEX_PLATE1_03312023_RUN001!
    #> 
    #> Processing plate 'P1_SEROPED_PBT_62PLEX_PLATE1_03312023_RUN001'
    #> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/multiplate_tutorial/P2_SEROPED_62PLEX_PLATE2_04042023_RUN000.csv
    #> using format xPONENT

    #> 
    #> New plate object has been created with name: P2_SEROPED_62PLEX_PLATE2_04042023_RUN000!
    #> 
    #> Processing plate 'P2_SEROPED_62PLEX_PLATE2_04042023_RUN000'
    #> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/multiplate_tutorial/P3_rerun_SEROPED_PLATE3_04042023_RUN002.csv
    #> using format xPONENT

    #> 
    #> New plate object has been created with name: P3_rerun_SEROPED_PLATE3_04042023_RUN002!
    #> 
    #> Processing plate 'P3_rerun_SEROPED_PLATE3_04042023_RUN002'
    #> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/multiplate_tutorial/P4_SEROPED_62PLEX_PLATE4_04042023_RUN003.csv
    #> using format xPONENT

    #> 
    #> New plate object has been created with name: P4_SEROPED_62PLEX_PLATE4_04042023_RUN003!
    #> 
    #> Processing plate 'P4_SEROPED_62PLEX_PLATE4_04042023_RUN003'
    #> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/multiplate_tutorial/P5_SEROPED_62PLEX_PLATE5_04052023_RUN001.csv
    #> using format xPONENT

    #> 
    #> New plate object has been created with name: P5_SEROPED_62PLEX_PLATE5_04052023_RUN001!
    #> 
    #> Processing plate 'P5_SEROPED_62PLEX_PLATE5_04052023_RUN001'
    #> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/multiplate_tutorial/P6_SEROPED_62PLEX_PLATE6_04052023_RUN003.csv
    #> using format xPONENT

    #> 
    #> New plate object has been created with name: P6_SEROPED_62PLEX_PLATE6_04052023_RUN003!
    #> 
    #> Processing plate 'P6_SEROPED_62PLEX_PLATE6_04052023_RUN003'
    #> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/multiplate_tutorial/P7_SEROPED_62PLEX_PLATE7_04052023_RUN004.csv
    #> using format xPONENT

    #> 
    #> New plate object has been created with name: P7_SEROPED_62PLEX_PLATE7_04052023_RUN004!
    #> 
    #> Processing plate 'P7_SEROPED_62PLEX_PLATE7_04052023_RUN004'
    #> Reading Luminex data from: /home/runner/work/_temp/Library/SerolyzeR/extdata/multiplate_tutorial/P8_SEROPED_62PLEX_PLATE8_04052023_RUN005.csv
    #> using format xPONENT

    #> 
    #> New plate object has been created with name: P8_SEROPED_62PLEX_PLATE8_04052023_RUN005!
    #> 
    #> Processing plate 'P8_SEROPED_62PLEX_PLATE8_04052023_RUN005'
    #> Fitting the models and predicting RAU for each analyte

    #> Fitting the models and predicting RAU for each analyte
    #> Fitting the models and predicting RAU for each analyte

    #> Fitting the models and predicting RAU for each analyte

    #> Fitting the models and predicting RAU for each analyte

    #> Fitting the models and predicting RAU for each analyte
    #> Fitting the models and predicting RAU for each analyte
    #> Fitting the models and predicting RAU for each analyte

    #> Fitting the models and predicting RAU for each analyte
    #> Fitting the models and predicting RAU for each analyte
    #> Fitting the models and predicting RAU for each analyte
    #> Fitting the models and predicting RAU for each analyte
    #> Fitting the models and predicting RAU for each analyte

    #> Merged output saved to: /tmp/RtmpdtZRww/multiplate-tutorial/merged_RAU_20260117_183106.csv
    #> Computing nMFI values for each analyte
    #> Computing nMFI values for each analyte
    #> Computing nMFI values for each analyte
    #> Computing nMFI values for each analyte
    #> Computing nMFI values for each analyte
    #> Computing nMFI values for each analyte
    #> Computing nMFI values for each analyte
    #> Computing nMFI values for each analyte
    #> Computing nMFI values for each analyte
    #> Computing nMFI values for each analyte
    #> Computing nMFI values for each analyte
    #> Computing nMFI values for each analyte
    #> Computing nMFI values for each analyte
    #> Merged output saved to: /tmp/RtmpdtZRww/multiplate-tutorial/merged_nMFI_20260117_183106.csv
    #> Extracting the raw MFI to the output dataframe
    #> Extracting the raw MFI to the output dataframe
    #> Extracting the raw MFI to the output dataframe
    #> Extracting the raw MFI to the output dataframe
    #> Extracting the raw MFI to the output dataframe
    #> Extracting the raw MFI to the output dataframe
    #> Extracting the raw MFI to the output dataframe
    #> Extracting the raw MFI to the output dataframe
    #> Extracting the raw MFI to the output dataframe
    #> Extracting the raw MFI to the output dataframe
    #> Extracting the raw MFI to the output dataframe
    #> Extracting the raw MFI to the output dataframe
    #> Extracting the raw MFI to the output dataframe
    #> Merged output saved to: /tmp/RtmpdtZRww/multiplate-tutorial/merged_MFI_20260117_183106.csv

Remember, if you want to read all your files properly, you need to
follow the naming convention of the files. The layout file should have
the same name as the plate file, with the added suffix `_layout`. The
detailed description of the convention, along with the list of all the
possible arguments can be found in the documentation of the function,
which can be accessed with
[`?process_dir`](https://mini-pw.github.io/SerolyzeR/reference/process_dir.md)
command.

Now, let us investigate the merged output of the
[`process_dir()`](https://mini-pw.github.io/SerolyzeR/reference/process_dir.md)
function, which contains the data for all the samples and analytes, for
each data type: MFI, nMFI and RAU.

For detailed description of the normalised output for a single plate, we
refer the reader to the . For the detailed description of the reports,
we refer the reader to the . If you are interested in specific plots
genrerated by our package, for quality control of both single and
multiple plates, we refer you to the vignette .

Let us investigate the output directory and the files that were created.

``` r
list.files(output_dir)
```

    #> [1] "merged_MFI_20260117_183106.csv"  "merged_nMFI_20260117_183106.csv"
    #> [3] "merged_RAU_20260117_183106.csv"

Since, we have selected the `merge_outputs` parameter to be `TRUE`, we
should see 3 files in the output directory:
`merged_MFI_{current_timestamp}.csv`,
`merged_nMFI_{current_timestamp}.csv` and
`merged_RAU_{current_timestamp}.csv`.

``` r
merged_RAU_filepath <- list.files(output_dir, pattern = "RAU", full.names = TRUE) # get the exact path to the RAU file


RAU_data <- read.csv(merged_RAU_filepath)
```

This file is a standard CSV dataframe. Its rows correspond to the
samples and the columns to the analytes. The first column is the plate
name from the sample originates, the second one is the sample name. The
remaining columns contain the analytes.

``` r
RAU_data[1:5, 1:5]
```

    #>                                     plate_name sample_name Adenovirus.T3
    #> 1 P1_SEROPED_PBT_62PLEX_PLATE1_03312023_RUN001           B  8.920831e-01
    #> 2 P1_SEROPED_PBT_62PLEX_PLATE1_03312023_RUN001        1/50  2.000000e+04
    #> 3 P1_SEROPED_PBT_62PLEX_PLATE1_03312023_RUN001       1/100  9.700496e+03
    #> 4 P1_SEROPED_PBT_62PLEX_PLATE1_03312023_RUN001       1/200  4.655472e+03
    #> 5 P1_SEROPED_PBT_62PLEX_PLATE1_03312023_RUN001       1/400  2.238576e+03
    #>   Adenovirus.T5 Bordetella.p..Toxin
    #> 1      1.042746        7.561766e-04
    #> 2  20000.000000        1.998425e+04
    #> 3  11301.180587        9.864071e+03
    #> 4   3753.390453        5.376943e+03
    #> 5   2278.218780        2.417622e+03
