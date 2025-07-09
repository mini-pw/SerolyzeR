library(testthat)

get_test_plate <- function() {
  names <- c("B", "S", "S", "S", "S", "S", "S", "S", "S", "S", "S", "TEST")
  locations <- c(
    "A1", "A2", "A3", "A4", "A5", "A6",
    "B1", "B2", "B3", "B4", "B5", "B6"
  )
  types <- ifelse(names == "B", "BLANK", "STANDARD CURVE")
  types[names == "TEST"] <- "TEST"
  values <- c(19, 11713, 8387, 5711, 3238.5, 2044, 1078, 571, 262, 138, 81, 4000)
  dilutions <- c(NA, "1/50", "1/100", "1/200", "1/400", "1/800", "1/1600", "1/3200", "1/6400", "1/12800", "1/25600", "1/102400", NA)
  dilution_values <- convert_dilutions_to_numeric(dilutions)
  plate_datetime <- as.POSIXct("2020-01-01 12:00:00", tz = "UTC")

  Plate$new(
    plate_name = "plate",
    sample_names = names,
    sample_types = types,
    sample_locations = locations,
    analyte_names = c("Spike_6P_IPP"),
    dilutions = dilutions,
    dilution_values = dilution_values,
    data = list(Median = data.frame(Spike_6P_IPP = values)),
    plate_datetime = plate_datetime
  )
}

get_test_list_of_plates <- function() {
  list(
    test = get_test_plate()
  )
}

get_list_of_plates <- function() {
  dir <- system.file("extdata", "multiplate_reallife_reduced",
    package = "SerolyzeR", mustWork = TRUE
  )

  output_dir <- tempdir(check = TRUE)
  dir.create(output_dir)
  real_list_of_plates <- process_dir(dir,
    return_plates = TRUE,
    format = "xPONENT",
    output_dir = output_dir
  )
  unlink(output_dir, recursive = TRUE)
  real_list_of_plates
}

test_that("Plot Levey-Jennings chart", {
  list_of_plates <- get_test_list_of_plates()
  expect_no_error(plot_levey_jennings(list_of_plates, "Spike_6P_IPP"))
})

test_that("Plot Levey-Jennings chart with not a list", {
  expect_error(plot_levey_jennings("not_list", "Spike_6P_IPP"))
})

test_that("Plot Levey-Jennings chart with empty list", {
  expect_error(plot_levey_jennings(list(), "Spike_6P_IPP"))
})

test_that("Plot Levey-Jennings chart with less than 10 plates", {
  list_of_plates <- get_test_list_of_plates()
  expect_warning(plot_levey_jennings(list_of_plates, "Spike_6P_IPP"))
})

test_that("Plot Levey-Jennings chart with not a Plate object", {
  list_of_plates <- list("not_plate")
  expect_error(plot_levey_jennings(list_of_plates, "Spike_6P_IPP"))
})

test_that("Plot Levey-Jennings chart with not existing analyte", {
  list_of_plates <- get_test_list_of_plates()
  expect_error(plot_levey_jennings(list_of_plates, "not_existing"))
})


test_that("Plot Levey-Jennings chart with not existing dilution", {
  list_of_plates <- get_test_list_of_plates()
  expect_error(plot_levey_jennings(list_of_plates, "Spike_6P_IPP", "1/2"))
})

test_that("Plot Levey-Jennings chart with incorrect format of dilution", {
  list_of_plates <- get_test_list_of_plates()
  expect_error(plot_levey_jennings(list_of_plates, "Spike_6P_IPP", 1 / 400))
})

test_that("Plot Levey-Jennings chart with a different legend position", {
  list_of_plates <- get_test_list_of_plates()

  expect_error(plot_levey_jennings(list_of_plates, "Spike_6P_IPP", "1/2", legend_position = "far away"))

  p <- plot_levey_jennings(list_of_plates, "Spike_6P_IPP", legend_position = "left")

  expect_equal(ggplot2::ggplot_build(p)$plot$theme$legend.position, "left")
})


test_that("Plot Levey-Jennings chart with invalid horizontal lines parameter", {
  list_of_plates <- get_test_list_of_plates()
  expect_error(plot_levey_jennings(list_of_plates, "Spike_6P_IPP", "1/400", "not_numeric"))
})

test_that("Plot Levey-Jennings chart with not a string analyte", {
  list_of_plates <- get_test_list_of_plates()
  expect_error(plot_levey_jennings(list_of_plates, 1, "1/400"))
})


test_that("Plot Levey-Jennings chart with in linear scale", {
  list_of_plates <- get_test_list_of_plates()
  expect_error(plot_levey_jennings(list_of_plates, "Spike_6P_IPP", mfi_log_scale = FALSE), NA)

  expect_error(plot_levey_jennings(list_of_plates, "Spike_6P_IPP", mfi_log_scale = "incorrect scale"))
})


# Additional tests to improve coverage for plot_levey_jennings function

test_that("Plot Levey-Jennings chart with more than 6 sd_lines", {
  list_of_plates <- get_test_list_of_plates()
  expect_error(
    plot_levey_jennings(list_of_plates, "Spike_6P_IPP", sd_lines = c(1, 2, 3, 4, 5, 6, 7)),
    "It is impossible to have more than 6 pairs of standard deviation lines."
  )
})

test_that("Plot Levey-Jennings chart with incorrect mfi_log_scale parameter", {
  list_of_plates <- get_test_list_of_plates()
  expect_error(plot_levey_jennings(list_of_plates, "Spike_6P_IPP", mfi_log_scale = c(TRUE, FALSE)))
})

test_that("Plot Levey-Jennings chart with incorrect sort_plates parameter", {
  list_of_plates <- get_test_list_of_plates()
  expect_error(plot_levey_jennings(list_of_plates, "Spike_6P_IPP", sort_plates = c(TRUE, FALSE)))
})

test_that("Plot Levey-Jennings chart with incorrect label_angle parameter", {
  list_of_plates <- get_test_list_of_plates()
  expect_error(
    plot_levey_jennings(list_of_plates, "Spike_6P_IPP", label_angle = c(45, 90)),
    "label_angle must be numeric\\(1\\)."
  )
  expect_error(
    plot_levey_jennings(list_of_plates, "Spike_6P_IPP", label_angle = "45"),
    "label_angle must be numeric\\(1\\)."
  )
})

test_that("Plot Levey-Jennings chart with incorrect plate_labels parameter", {
  list_of_plates <- get_test_list_of_plates()
  expect_error(
    plot_levey_jennings(list_of_plates, "Spike_6P_IPP", plate_labels = "invalid"),
    "plate_labels should be one of the following: 'name', 'number', or 'date'"
  )
  expect_error(plot_levey_jennings(list_of_plates, "Spike_6P_IPP", plate_labels = c("name", "number")))
})

test_that("Plot Levey-Jennings chart with different plate_labels options", {
  list_of_plates <- get_test_list_of_plates()

  # Test with plate_labels = "name"
  expect_no_error(plot_levey_jennings(list_of_plates, "Spike_6P_IPP", plate_labels = "name"))

  # Test with plate_labels = "number" (default behavior)
  expect_no_error(plot_levey_jennings(list_of_plates, "Spike_6P_IPP", plate_labels = "number"))

  # Test with plate_labels = "date"
  expect_no_error(plot_levey_jennings(list_of_plates, "Spike_6P_IPP", plate_labels = "date"))
})

test_that("Plot Levey-Jennings chart with sort_plates = FALSE", {
  list_of_plates <- get_test_list_of_plates()
  expect_no_error(plot_levey_jennings(list_of_plates, "Spike_6P_IPP", sort_plates = FALSE))
})

test_that("Plot Levey-Jennings chart with custom label_angle", {
  list_of_plates <- get_test_list_of_plates()
  expect_no_error(plot_levey_jennings(list_of_plates, "Spike_6P_IPP", label_angle = 45))
  expect_no_error(plot_levey_jennings(list_of_plates, "Spike_6P_IPP", label_angle = 90))
})

test_that("Plot Levey-Jennings chart with custom sd_lines", {
  list_of_plates <- get_test_list_of_plates()
  expect_no_error(plot_levey_jennings(list_of_plates, "Spike_6P_IPP", sd_lines = c(0.5, 1.5, 2.5)))
  expect_no_error(plot_levey_jennings(list_of_plates, "Spike_6P_IPP", sd_lines = c(1.96, 2.58)))
  expect_no_error(plot_levey_jennings(list_of_plates, "Spike_6P_IPP", sd_lines = c(1, 2, 3, 4, 5, 6)))
})

test_that("Plot Levey-Jennings chart with empty sd_lines", {
  list_of_plates <- get_test_list_of_plates()
  expect_no_error(plot_levey_jennings(list_of_plates, "Spike_6P_IPP", sd_lines = numeric(0)))
})

test_that("Plot Levey-Jennings chart with multiple plates to test sorting", {
  # Create multiple plates with different dates
  plate1 <- get_test_plate()
  plate1$plate_datetime <- as.POSIXct("2020-01-01 12:00:00", tz = "UTC")
  plate1$plate_name <- "plate1"

  plate2 <- get_test_plate()
  plate2$plate_datetime <- as.POSIXct("2020-01-02 12:00:00", tz = "UTC")
  plate2$plate_name <- "plate2"

  plate3 <- get_test_plate()
  plate3$plate_datetime <- as.POSIXct("2020-01-03 12:00:00", tz = "UTC")
  plate3$plate_name <- "plate3"

  list_of_plates <- list(plate3, plate1, plate2) # Out of order

  expect_no_error(plot_levey_jennings(list_of_plates, "Spike_6P_IPP", sort_plates = TRUE))
  expect_no_error(plot_levey_jennings(list_of_plates, "Spike_6P_IPP", sort_plates = FALSE))
})
