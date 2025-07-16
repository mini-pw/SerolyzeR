#' @title
#' Calculate Normalised MFI (nMFI) Values for a Plate
#'
#' @description
#' Calculates normalised MFI (nMFI) values for each analyte in a Luminex plate.
#' The nMFI values are computed as the ratio of each test sample's MFI to the
#' MFI of a standard curve sample at a specified reference dilution.
#'
#' @details
#' Normalised MFI (nMFI) is a simple, model-free metric used to compare test
#' sample responses relative to a fixed concentration from the standard curve.
#' It is particularly useful when model fitting (e.g., for RAU calculation)
#' is unreliable or not possible, such as when test sample intensities fall
#' outside the standard curve range.
#'
#' The function locates standard samples with the specified dilution and divides
#' each test sample’s MFI by the corresponding standard MFI value for each analyte.
#'
#' @section When Should nMFI Be Used?:
#' While RAU values are generally preferred for antibody quantification,
#' they require successful model fitting of the standard curve.
#' This may not be feasible when:
#'
#' - The test samples produce MFI values outside the range of the standard curve.
#' - The standard curve is poorly shaped or missing critical points.
#'
#' In such cases, nMFI serves as a useful alternative, allowing for
#' plate-to-plate comparison without the need for extrapolation.
#'
#'
#' @param plate (`Plate()`) a plate object for which to calculate the nMFI values
#' @param reference_dilution (`numeric(1) or character(1)`) the dilution value of the standard curve sample
#' to use as a reference for normalisation. The default is `1/400`.
#' It should refer to a dilution of a standard curve sample in the given plate object.
#' This parameter could be either a numeric value or a string.
#' In case it is a character string, it should have format `1/d+`, where `d+` is any positive integer.
#' @param data_type (`character(1)`) type of data for the computation. Median is the default
#' @param verbose (`logical(1)`) print additional information. The default is `TRUE`
#'
#' @return nmfi (`data.frame`) a data frame with normalised MFI values for each analyte in the plate and all test samples.
#'
#' @references L. Y. Chan, E. K. Yim, and A. B. Choo, Normalized median fluorescence: An alternative flow cytometry analysis method for tracking human embryonic stem cell states during differentiation,  http://dx.doi.org/10.1089/ten.tec.2012.0150
#'
#' @examples
#'
#' # read the plate
#' plate_file <- system.file("extdata", "CovidOISExPONTENT.csv", package = "SerolyzeR")
#' layout_file <- system.file("extdata", "CovidOISExPONTENT_layout.csv", package = "SerolyzeR")
#'
#' plate <- read_luminex_data(plate_file, layout_file)
#'
#' # artificially bump up the MFI values of the test samples (the Median data type is default one)
#' plate$data[["Median"]][plate$sample_types == "TEST", ] <-
#'   plate$data[["Median"]][plate$sample_types == "TEST", ] * 10
#'
#' # calculate the nMFI values
#' nmfi <- get_nmfi(plate, reference_dilution = 1 / 400)
#'
#' # we don't do any extrapolation and the values should be comparable across plates
#' head(nmfi)
#' # different params
#' nmfi <- get_nmfi(plate, reference_dilution = "1/50")
#'
#' @export
get_nmfi <-
  function(plate,
           reference_dilution = 1 / 400,
           data_type = "Median",
           verbose = TRUE) {
    stopifnot(inherits(plate, "Plate"))

    stopifnot(length(reference_dilution) == 1)

    # check if data_type is valid
    stopifnot(is_valid_data_type(data_type))

    # check if reference_dilution is numeric or string
    if (is.character(reference_dilution)) {
      reference_dilution <-
        convert_dilutions_to_numeric(reference_dilution)
    }

    stopifnot(is.numeric(reference_dilution))
    stopifnot(reference_dilution > 0)

    if (!reference_dilution %in% plate$get_dilution_values("STANDARD CURVE")) {
      stop(
        "The target ",
        reference_dilution,
        " dilution is not present in the plate."
      )
    }


    # get index of standard curve sample with the target dilution
    reference_standard_curve_id <-
      which(
        plate$dilution_values == reference_dilution &
          plate$sample_types == "STANDARD CURVE"
      )
    stopifnot(length(reference_standard_curve_id) == 1)

    plate_data <-
      plate$get_data(
        analyte = "ALL",
        sample_type = "ALL",
        data_type = data_type
      )

    reference_mfi <- plate_data[reference_standard_curve_id, ]

    test_mfi <-
      plate$get_data(
        analyte = "ALL",
        sample_type = "TEST",
        data_type = data_type
      )
    reference_mfi <- reference_mfi[rep(1, nrow(test_mfi)), ]

    nmfi <- test_mfi / reference_mfi

    rownames(nmfi) <-
      plate$sample_names[plate$sample_types == "TEST"]


    return(nmfi)
  }
