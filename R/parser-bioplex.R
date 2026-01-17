#' Get the index of the end of the header in the first column
#'
#' @param first_col The first column of the BIOPLEX excel sheet
#'
#' @return The index of the last row of the header
#'
#' @keywords internal
get_header_end_idx <- function(first_col) {
  header_end_idx_1 <- min(which(is.na(first_col))) - 1
  header_end_idx_2 <- min(which(first_col == "Type")) - 1
  header_end_idx <- min(header_end_idx_1, header_end_idx_2)
  if (header_end_idx < 1) {
    stop("No header found in the first column.")
  }
  return(header_end_idx)
}

#' Extract header information from the first column of a BIOPLEX file
#'
#' @param first_col The first column of the BIOPLEX excel sheet
#'
#' @return A named list containing the header key-value pairs
#'
#' @import stringi
#'
#' @keywords internal
extract_header_information <- function(first_col) {
  header_end_idx <- get_header_end_idx(first_col)
  header_col <- first_col[1:header_end_idx]
  header_list <- list()
  for (i in seq_len(length(header_col))) {
    line <- as.character(header_col[i])
    idx <- stringi::stri_locate_first(line, fixed = ":")[1, "start"]
    if (is.na(idx)) {
      warning(paste("Line", i, "does not contain a ':'. Skipping."))
    }
    key <- stringi::stri_sub(line, 1, idx - 1)
    value <- stringi::stri_sub(line, idx + 2)
    header_list[[key]] <- value
  }
  return(header_list)
}

#' Read the BIOPLEX format data
#'
#' @param path Path to the BIOPLEX file (excel file)
#' @param verbose Print additional information. Default is `TRUE`
#'
#' @import stringr
#' @import stringi
#' @import readxl
#' @import cellranger
#'
read_bioplex_format <- function(path, verbose = TRUE) {
  DATATYPE_ROW_OFFSET <- 2
  ANALYTES_ROW_OFFSET <- 1
  SAMPLES_START_COL_OFFSET <- 4

  sheets <- readxl::excel_sheets(path)
  if (length(sheets) < 1) {
    stop("No sheets found in the BIOPLEX file.")
  }

  # Extract header information from first sheet
  first_col <- suppressMessages(readxl::read_excel(path,
    range = cellranger::cell_cols("A"),
    sheet = sheets[1],
    col_names = FALSE,
    col_types = "text",
    .name_repair = "minimal"
  ))[[1]]
  header_list <- extract_header_information(first_col)
  filename <- header_list[["File Name"]]
  acq_datetime <- header_list[["Acquisition Date"]]
  # Remove those two from the header list to form metadata
  metadata <- header_list[
    names(header_list) != "File Name" & names(header_list) != "Acquisition Date"
  ]

  data <- list()
  for (sheet in sheets) {
    xlsx_data <- suppressMessages(readxl::read_excel(
      path = path,
      col_names = FALSE,
      sheet = sheet,
      col_types = "text",
      .name_repair = "minimal"
    ))
    if (ncol(xlsx_data) == 0) {
      next
    }
    header_end_idx <- get_header_end_idx(xlsx_data[[1]])
    df_start_idxs <- which(first_col == "Type")
    df_start_idxs <- df_start_idxs[df_start_idxs > header_end_idx]
    df_start_idxs <- df_start_idxs - 1 # move to the row before "Type"

    for (idx in seq_len(length(df_start_idxs))) {
      # Locate the start and end of each dataframe
      start_idx <- df_start_idxs[idx]
      end_idx <- ifelse(
        idx < length(df_start_idxs),
        df_start_idxs[idx + 1],
        length(first_col)
      )
      df <- xlsx_data[start_idx:end_idx, ]
      # Reduce the multi index into single index (and get datatype name)
      datatype <- as.character(df[DATATYPE_ROW_OFFSET, SAMPLES_START_COL_OFFSET])
      vrange <- SAMPLES_START_COL_OFFSET:ncol(df)
      df[DATATYPE_ROW_OFFSET, vrange] <- df[ANALYTES_ROW_OFFSET, vrange]
      current_colnames <- as.character(df[DATATYPE_ROW_OFFSET, ])
      df <- df[c(-DATATYPE_ROW_OFFSET, -ANALYTES_ROW_OFFSET), ]
      ## Rename analyte columns
      analyte_names <- current_colnames[vrange]
      analyte_names <- stringr::str_trim(analyte_names)
      ### Remove parentheses around numbers
      analyte_names <- stringr::str_replace_all(analyte_names, "\\((\\d+)\\)", "\\1")
      analyte_names <- stringr::str_replace_all(analyte_names, "\\s+", "_")
      ### Replace all non-alphanumeric characters with underscore
      analyte_names <- stringr::str_replace_all(analyte_names, "[^A-Za-z0-9_]", "_")

      current_colnames[vrange] <- analyte_names
      ## Set column names
      colnames(df) <- current_colnames
      # Remove numeric value in analyte columns
      df[, vrange] <- suppressWarnings(sapply(
        df[, vrange], function(col) as.numeric(col)
      ))
      # Remove trailing NaN rows
      nan_rows <- which(rowSums(is.na(df)) >= (ncol(df) - 1))
      if (length(nan_rows) > 0) {
        df <- df[1:(min(nan_rows) - 1), ]
      }
      # Check for duplicate datatype
      if (datatype %in% names(data)) {
        if (verbose) {
          warning(paste("Duplicate datatype", datatype, "found in sheet", sheet, ". Overwritting..."))
        }
      }
      # Rename columns
      # First three columns: Type, Well, Description
      # Rename to: Sample, Location, SampleDescription
      stopifnot(colnames(df)[1:3] == c("Type", "Well", "Description"))
      colnames(df)[1:3] <- c("Sample", "Location", "SampleDescription")

      data[[datatype]] <- as.data.frame(df)
    }
  }

  plate_name <- ifelse(length(sheets) == 1, sheets[1], filename)
  return(list(
    PlateName = plate_name,
    AcquisitionDate = acq_datetime,
    Metadata = metadata,
    Results = data
  ))
}
