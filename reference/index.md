# Package index

## Core functions

Reading, processing and summarising the data. These functions allow for
end-to-end analysis without going into more complex details.

- [`read_luminex_data()`](https://mini-pw.github.io/SerolyzeR/reference/read_luminex_data.md)
  : Read Luminex Data
- [`process_plate()`](https://mini-pw.github.io/SerolyzeR/reference/process_plate.md)
  : Process Plate Data and Save Normalised Output
- [`process_file()`](https://mini-pw.github.io/SerolyzeR/reference/process_file.md)
  : Process a File to Generate Normalised Data and Reports
- [`process_dir()`](https://mini-pw.github.io/SerolyzeR/reference/process_dir.md)
  : Process a Directory of Luminex Data Files
- [`generate_plate_report()`](https://mini-pw.github.io/SerolyzeR/reference/generate_plate_report.md)
  : Generate a report for a plate.
- [`generate_levey_jennings_report()`](https://mini-pw.github.io/SerolyzeR/reference/generate_levey_jennings_report.md)
  : Generate a Levey-Jennings Report for Multiple Plates.

## Plate and Model classes

Instances of the Plate and Model classes and additional functions for
predictions and normalisation. These methods are used to store the data
and the model and facilitate the analysis.

- [`Model`](https://mini-pw.github.io/SerolyzeR/reference/Model.md) :
  Logistic regression model for the standard curve
- [`Plate`](https://mini-pw.github.io/SerolyzeR/reference/Plate.md) :
  Plate Object
- [`PlateBuilder`](https://mini-pw.github.io/SerolyzeR/reference/PlateBuilder.md)
  : PlateBuilder
- [`create_standard_curve_model_analyte()`](https://mini-pw.github.io/SerolyzeR/reference/create_standard_curve_model_analyte.md)
  : Create a standard curve model for a certain analyte
- [`predict(`*`<Model>`*`)`](https://mini-pw.github.io/SerolyzeR/reference/predict.Model.md)
  : Predict the RAU values from the MFI values
- [`get_nmfi()`](https://mini-pw.github.io/SerolyzeR/reference/get_nmfi.md)
  : Calculate Normalised MFI (nMFI) Values for a Plate

## Plots

Functions for plotting the data, quality control and the results of the
analysis.

- [`plot_counts()`](https://mini-pw.github.io/SerolyzeR/reference/plot_counts.md)
  : Plot counts in a 96-well plate
- [`plot_layout()`](https://mini-pw.github.io/SerolyzeR/reference/plot_layout.md)
  : Plot layout of a 96-well plate
- [`plot_mfi_for_analyte()`](https://mini-pw.github.io/SerolyzeR/reference/plot_mfi_for_analyte.md)
  : Plot MFI value distribution for a given analyte
- [`plot_standard_curve_analyte()`](https://mini-pw.github.io/SerolyzeR/reference/plot_standard_curve_analyte.md)
  : Standard curves
- [`plot_standard_curve_analyte_with_model()`](https://mini-pw.github.io/SerolyzeR/reference/plot_standard_curve_analyte_with_model.md)
  : Plot standard curve of a certain analyte with fitted model
- [`plot_standard_curve_stacked()`](https://mini-pw.github.io/SerolyzeR/reference/plot_standard_curve_stacked.md)
  : Standard curve stacked plot for levey-jennings report
- [`plot_levey_jennings()`](https://mini-pw.github.io/SerolyzeR/reference/plot_levey_jennings.md)
  : Plot Levey-Jennings chart

## Helper functions

Additional, lower level functions that are used in the analysis

- [`read_xponent_format()`](https://mini-pw.github.io/SerolyzeR/reference/read_xponent_format.md)
  : Read the xPONENT format data
- [`read_intelliflex_format()`](https://mini-pw.github.io/SerolyzeR/reference/read_intelliflex_format.md)
  : Read the Intelliflex format data
- [`read_bioplex_format()`](https://mini-pw.github.io/SerolyzeR/reference/read_bioplex_format.md)
  : Read the BIOPLEX format data
- [`read_layout_data()`](https://mini-pw.github.io/SerolyzeR/reference/read_layout_data.md)
  : Read layout data from a file
- [`merge_plate_outputs()`](https://mini-pw.github.io/SerolyzeR/reference/merge_plate_outputs.md)
  : Merge Normalised Data from Multiple Plates
- [`is_valid_data_type()`](https://mini-pw.github.io/SerolyzeR/reference/is_valid_data_type.md)
  : Check validity of given data type
- [`is_valid_sample_type()`](https://mini-pw.github.io/SerolyzeR/reference/is_valid_sample_type.md)
  : Check validity of given sample type
- [`translate_sample_names_to_sample_types()`](https://mini-pw.github.io/SerolyzeR/reference/translate_sample_names_to_sample_types.md)
  : Translate sample names to sample types
- [`handle_high_dose_hook()`](https://mini-pw.github.io/SerolyzeR/reference/handle_high_dose_hook.md)
  : Detect and handle the high dose hook effect
