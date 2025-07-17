#' @title
#' Merge Normalised Data from Multiple Plates
#'
#' @description
#' This function merges normalised data from a list of [`Plate`] objects into a single `data.frame`.
#' It supports different normalisation types and handles column mismatches based on the specified strategy.
#'
#' @param plates A named list of [`Plate`] objects, typically returned by [process_dir()] with parameter `return_plates = TRUE`.
#' @param normalisation_type (`character(1)`) The type of normalisation to merge. Options: `"MFI"`, `"RAU"`, `"nMFI"`.
#' @param column_collision_strategy (`character(1)`, default = `"intersection"`)
#'   - Determines how to handle mismatched columns across plates.
#'   - Options: `"intersection"` (only shared columns), `"union"` (include all columns).
#' @param verbose (`logical(1)`, default = `TRUE`) Whether to print verbose output.
#' @param ... Additional arguments passed to [process_plate()], such as `sample_type_filter = "TEST"`
#'   to include only certain sample types in the merged result.
#'
#' @return A merged `data.frame` containing normalised data across all plates.
#'
#' @examples
#' # creating temporary directory for the example
#' output_dir <- tempdir(check = TRUE)
#'
#' dir_with_luminex_files <- system.file("extdata", "multiplate_reallife_reduced",
#'   package = "SerolyzeR", mustWork = TRUE
#' )
#' list_of_plates <- process_dir(dir_with_luminex_files,
#'   return_plates = TRUE, format = "xPONENT", output_dir = output_dir
#' )
#'
#' df <- merge_plate_outputs(list_of_plates, "RAU")
#'
#'
#' df <- merge_plate_outputs(list_of_plates, "RAU", sample_type_filter = c("TEST", "STANDARD CURVE"))
#'
#'
#'
#'
#' @export
merge_plate_outputs <- function(
    plates,
    normalisation_type,
    column_collision_strategy = "intersection",
    verbose = TRUE,
    ...
) {
  if (!is.character(normalisation_type) || length(normalisation_type) != 1) {
    stop("`normalisation_type` must be a single character string.")
  }

  if (!(normalisation_type %in% c("MFI", "RAU", "nMFI"))) {
    stop("`normalisation_type` must be one of: 'MFI', 'RAU', 'nMFI'.")
  }

  if (!is.list(plates) || length(plates) == 0) {
    stop("`plates` must be a non-empty list of Plate objects.")
  }

  if (!all(sapply(plates, inherits, what = "Plate"))) {
    stop("All elements of `plates` must be of class 'Plate'.")
  }

  if (!column_collision_strategy %in% c("intersection", "union")) {
    stop("`column_collision_strategy` must be either 'intersection' or 'union'.")
  }

  dataframes <- list()
  for (plate in plates) {
    output_df <- process_plate(
      plate,
      normalisation_type = normalisation_type,
      write_output = FALSE,
      blank_adjustment = TRUE,
      verbose = verbose,
      ...
    )

    df_header_columns <- data.frame(
      plate_name = plate$plate_name,
      sample_name = rownames(output_df)
    )
    rownames(output_df) <- NULL

    modified_output_df <- cbind(df_header_columns, output_df)
    dataframes[[plate$plate_name]] <- modified_output_df
  }

  merged_df <- merge_dataframes(
    dataframes,
    column_collision_strategy = column_collision_strategy,
    fill_value = NA
  )

  return(merged_df)
}
