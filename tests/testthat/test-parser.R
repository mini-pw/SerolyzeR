library(testthat)

test_that("Test handle_datetime with seen date formats", {
  # Default xPONENT datetime format MM/DD/YYYY HH:MM AM/PM
  expect_equal(
    handle_datetime("05/11/2022 4:45 PM", "xPONENT"),
    as.POSIXct("2022-05-11 16:45:00", tz = "")
  )

  # Automatic recovery with xPONENT datetime format DD/MM/YYYY HH:MM
  expect_message(dt <- handle_datetime("26/02/2014 16:07", "xPONENT"))
  expect_equal(dt, as.POSIXct("2014-02-26 16:07:00", tz = ""))

  # Default INTELLIFLEX datetime format YYYY-MM-DD HH:MM:SS AM/PM
  expect_equal(
    handle_datetime("2024-10-07 12:00:00 PM", "INTELLIFLEX"),
    as.POSIXct("2024-10-07 12:00:00", tz = "")
  )
})
test_that("Test extract_xponent_experiment_date method", {
  # Case 1: Extract from BatchMetadata
  plate_file <- system.file("extdata", "random.csv", package = "SerolyzeR", mustWork = TRUE)
  xponent_output <- read_xponent_format(plate_file, exact_parse = TRUE)
  expect_message(
    datetime <- extract_xponent_experiment_date(xponent_output),
    "BatchStartTime successfully extracted from the metadata"
  )
  expect_equal(
    handle_datetime(datetime, "xPONENT"),
    as.POSIXct("2022-05-12 18:17:40", tz = "")
  )

  # Case 2: Fallback to Header field
  xponent_output <- read_xponent_format(plate_file)
  expect_message(
    datetime <- extract_xponent_experiment_date(xponent_output),
    "BatchStartTime successfully extracted from the header"
  )
  expect_equal(
    handle_datetime(datetime, "xPONENT"),
    as.POSIXct("2022-05-12 18:17:40", tz = "")
  )

  # Case 3: Fallback to ProgramMetadata (export datetime)
  plate_file <- system.file("extdata", "random2.csv", package = "SerolyzeR", mustWork = TRUE)
  xponent_output <- read_xponent_format(plate_file)
  expect_message(
    datetime <- extract_xponent_experiment_date(xponent_output),
    "Fallback datetime successfully extracted from ProgramMetadata."
  )
  expect_equal(
    handle_datetime(datetime, "xPONENT"),
    as.POSIXct("2024-02-07 00:00:00", tz = "")
  )
})



test_that("Test parser validation", {
  # Default xPONENT datetime format MM/DD/YYYY HH:MM AM/PM
  expect_error(read_luminex_data("non-existent-data.csv", "wrong"))

  expect_error(read_luminex_data("non-existent-data.csv", "xPONENT"))

  expect_error(read_luminex_data("non-existent-data.csv", "INTELLIFLEX"))
})
