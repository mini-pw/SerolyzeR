is_valid_normalisation_type <- function(normalisation_type) {
  normalisation_type %in% SerolyzeR.env$normalisation_types
}
#' @title
#' Process Plate Data and Save Normalised Output
#'
#' @description
#' Processes a Luminex plate and computes normalised values using the specified
#' \code{normalisation_type}. Depending on the chosen method, the function performs
#' blank adjustment, fits models, and extracts values for test samples.
#' Optionally, the results can be saved as a CSV file.
#'
#' @details
#' Supported normalisation types:
#'
#' - **RAU** (Relative Antibody Units):
#'   Requires model fitting. Produces estimates using a standard curve.
#'   See \code{\link{create_standard_curve_model_analyte}} for details.
#'
#' - **nMFI** (Normalised Median Fluorescence Intensity):
#'   Requires a reference dilution. See \code{\link{get_nmfi}}.
#'
#' - **MFI** (Blank-adjusted Median Fluorescence Intensity):
#'   Returns raw MFI values (adjusted for blanks, if requested).
#'
#' @section RAU Workflow:
#' 1. Optionally perform blank adjustment.
#' 2. Fit a model for each analyte using standard curve data.
#' 3. Predict RAU values for test samples.
#' 4. Aggregate and optionally save results.
#'
#' @section nMFI Workflow:
#' 1. Optionally perform blank adjustment.
#' 2. Compute normalised MFI using the \code{reference_dilution}.
#' 3. Aggregate and optionally save results.
#'
#' @section MFI Workflow:
#' 1. Optionally perform blank adjustment.
#' 2. Return adjusted MFI values.
#'
#' @param plate A \link{Plate} object containing raw or processed Luminex data.
#' @param filename (`character(1)`, optional)
#'   Output CSV filename. If \code{NULL}, defaults to \code{"{plate_name}_{normalisation_type}.csv"}.
#'   File extension is auto-corrected to \code{.csv} if missing. If an absolute path is given,
#'   \code{output_dir} is ignored.
#' @param output_dir (`character(1)`, default = \code{"normalised_data"})
#'   Directory where the CSV will be saved. Will be created if it doesn't exist.
#'   If \code{NULL}, the current working directory is used.
#' @param write_output (`logical(1)`, default = \code{TRUE})
#'   Whether to write the output to disk.
#' @param normalisation_type (`character(1)`, default = \code{"RAU"})
#'   The normalisation method to use. Must be one of:
#'   \code{c("RAU", "nMFI", "MFI")}.
#' @param data_type (`character(1)`, default = \code{"Median"})
#'   The data type to use for normalisation (e.g., \code{"Median"}).
#' @param blank_adjustment (`logical(1)`, default = \code{FALSE})
#'   Whether to apply blank adjustment before processing.
#' @param verbose (`logical(1)`, default = \code{TRUE})
#'   If \code{TRUE}, prints progress and messages.
#' @param reference_dilution (`numeric(1)` or `character(1)`, default = \code{1/400})
#'   Target dilution used for nMFI calculation. Ignored for other types.
#'   Can be numeric (e.g., \code{0.0025}) or string (e.g., \code{"1/400"}).
#' @param ... Additional arguments passed to \code{\link{create_standard_curve_model_analyte}}.
#'
#' @return A data frame of computed values, with test samples as rows and analytes as columns.
#'
#' @seealso \code{\link{create_standard_curve_model_analyte}}, \code{\link{get_nmfi}}
#'
#' @examples
#' plate_file <- system.file("extdata", "CovidOISExPONTENT_CO_reduced.csv", package = "SerolyzeR")
#' layout_file <- system.file("extdata", "CovidOISExPONTENT_CO_layout.xlsx", package = "SerolyzeR")
#' plate <- read_luminex_data(plate_file, layout_file, verbose = FALSE)
#'
#' example_dir <- tempdir(check = TRUE)
#'
#' # Process using default settings (RAU normalisation)
#' process_plate(plate, output_dir = example_dir)
#'
#' # Use a custom filename and skip blank adjustment
#' process_plate(plate,
#'   filename = "no_blank.csv",
#'   output_dir = example_dir,
#'   blank_adjustment = FALSE
#' )
#'
#' # Use nMFI normalisation with reference dilution
#' process_plate(plate,
#'   normalisation_type = "nMFI",
#'   reference_dilution = "1/400",
#'   output_dir = example_dir
#' )
#'
#' @export
process_plate <-
  function(plate,
           filename = NULL,
           output_dir = "normalised_data",
           write_output = TRUE,
           normalisation_type = "RAU",
           data_type = "Median",
           blank_adjustment = FALSE,
           verbose = TRUE,
           reference_dilution = 1 / 400,
           ...) {
    stopifnot(inherits(plate, "Plate"))

    stopifnot(is_valid_normalisation_type(normalisation_type))
    stopifnot(is.character(data_type))

    if (write_output) {
      output_path <- validate_filepath_and_output_dir(filename, output_dir,
        plate$plate_name, normalisation_type,
        "csv",
        verbose = verbose
      )
    } else {
      output_path <- NULL
    }


    if ((!plate$blank_adjusted) && blank_adjustment) {
      plate <- plate$blank_adjustment(in_place = FALSE)
    }

    test_sample_names <- plate$sample_names[plate$sample_types == "TEST"]
    if (normalisation_type == "MFI") {
      verbose_cat("Extracting the raw MFI to the output dataframe\n")
      output_df <- plate$get_data(
        "ALL", "TEST",
        data_type = data_type
      )
    } else if (normalisation_type == "nMFI") {
      verbose_cat("Computing nMFI values for each analyte\n", verbose = verbose)
      output_df <- get_nmfi(
        plate,
        reference_dilution = reference_dilution, data_type = data_type
      )
    } else if (normalisation_type == "RAU") {
      # RAU normalisation
      verbose_cat("Fitting the models and predicting RAU for each analyte\n", verbose = verbose)
      output_list <- list()
      for (analyte in plate$analyte_names) {
        model <- create_standard_curve_model_analyte(
          plate, analyte,
          data_type = data_type, ...
        )
        test_samples_mfi <- plate$get_data(
          analyte, "TEST",
          data_type = data_type
        )
        test_sample_estimates <- predict(model, test_samples_mfi)
        output_list[[analyte]] <- test_sample_estimates[, "RAU"]
      }
      output_df <- data.frame(output_list)
    }
    rownames(output_df) <- test_sample_names

    if (write_output) {
      verbose_cat("Saving the computed ", normalisation_type, " values to a CSV file located in: '",
        output_path,
        "'\n",
        verbose = verbose
      )
      write.csv(output_df, output_path)
    }

    return(output_df)
  }
