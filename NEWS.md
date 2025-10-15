Version 1.3.0
---------------------------------------------------------------
* improve handling of xPONENT files with excessive empty lines

Version 1.3.0
---------------------------------------------------------------
* more precise selection of `data_type` in all of the methods, with better flow of optional parameters ([#304](https://github.com/mini-pw/SerolyzeR/issues/304))
* improved the readibility of the levey-jennings and stacked standard curve plots ([#293](https://github.com/mini-pw/SerolyzeR/issues/293), [#292](https://github.com/mini-pw/SerolyzeR/issues/292), [#296](https://github.com/mini-pw/SerolyzeR/issues/296), [#297](https://github.com/mini-pw/SerolyzeR/issues/297))
* fixed reading the experiment date ([#290](https://github.com/mini-pw/SerolyzeR/issues/290))
* improved the documentation ([#313](https://github.com/mini-pw/SerolyzeR/issues/313), [#308](https://github.com/mini-pw/SerolyzeR/issues/308), [#307](https://github.com/mini-pw/SerolyzeR/issues/307))
* added selection of sample types in `process_dir` function 
* updated some defaults parameters ([#310](https://github.com/mini-pw/SerolyzeR/issues/310), [#291](https://github.com/mini-pw/SerolyzeR/issues/291))
* fixed the bug with duplicate sample names ([#301](https://github.com/mini-pw/SerolyzeR/issues/301))



Version 1.2.0
---------------------------------------------------------------
* added dissemination about the PvSTATEM project
* added consistent axis naming
* updated the multiplate tutorial with real data


Version 1.1.0
---------------------------------------------------------------
* added vignette on multiplate functionalities
* added more verbose error and warning messages
* added warnings in HTML report
* added option to select a custom separator in xPONENT format
* bug fixes


Version 1.0.0
---------------------------------------------------------------
* package name changed from PvSTATEM to SerolyzeR


Version 0.2.2
---------------------------------------------------------------
* CRAN re-upload due to nplr package problems
* docs updates
* bug fixes


Version 0.2.1
---------------------------------------------------------------
* updated the multiple plate report layout
* merged output files of `process_dir`
* accelerated the model fitting
* reading plate made less restrictive - added an option to skip some datatypes
* bug fixes


Version 0.2.0
---------------------------------------------------------------
* added processing of multiple plates
* added stacked plot, levey-jennings plot and multiple plate report
* fixed the search option in the documentation


Version 0.1.3
---------------------------------------------------------------
* fixed an issue with writing into the home user's directory
* fixed an issue with reading plate files containing empty wells in the middle of the layout
* added a badge displaying coverage status 
  

Version 0.1.2
---------------------------------------------------------------
* uploaded missing vignettes that were removed in the previous release


Version 0.1.1
---------------------------------------------------------------
* released the package to CRAN
* fixed minor formatting issues


Version 0.1.0
---------------------------------------------------------------
* enhanced and unified file saving for generate_plate_report and process_plate
* reduced HTML report size and improved its structure
* removed extraneous column from RAU output
* added notes field in the HTML report
* made nplr warnings more informative
* added vignette for generate_plate_report function
* limited the amount of data frame presented in the vignettes


Version 0.0.5
---------------------------------------------------------------
* added function `generate_plate_report` generating the html report
* added nMFI normalisation type
* added an option to include raw MFI in the output of the `process_plate` function
* renamed output of the model to RAU (Relative Antibody Unit), which should be more interpretable for human
* simple censoring of the extrapolation


Version 0.0.4
---------------------------------------------------------------
* met the CRAN policy
* fixed the issue templates
* added the plate object view options


Version 0.0.3
---------------------------------------------------------------
* refactored the whole package structure to simplify the usage
* added a new, much faster parser for the xPONENT and INTELLIFLEX files
* model encapsulation for the standard curve fitting
* added new plots - MFI chart and layout plot
* updated blank adjustment function
* error fixes


Version 0.0.2
---------------------------------------------------------------
* added new datasets to the package
* sample standard curve plotting
* GitHub actions
* tests with coverage calculation


Version 0.0.1
---------------------------------------------------------------
* initial package structure with simple reading functionality
