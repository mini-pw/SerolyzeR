test_that("merge_plate_outputs works as expected", {
  dir <- system.file("extdata", "multiplate_reallife_reduced", package = "SerolyzeR", mustWork = TRUE)
  output_dir <- tempdir(check = TRUE)

  plates <- process_dir(dir, return_plates = TRUE, output_dir = output_dir, format = "xPONENT")
  expect_length(plates, 3)

  merged <- merge_plate_outputs(
    plates = plates,
    normalisation_type = "RAU",
    column_collision_strategy = "intersection",
    verbose = FALSE
  )

  expect_s3_class(merged, "data.frame")
  expect_true("plate_name" %in% names(merged))
  expect_true("sample_name" %in% names(merged))
})

test_that("merge_plate_outputs errors on invalid inputs", {
  expect_error(merge_plate_outputs(
    plates = list(), normalisation_type = "RAU"
  ), "`plates` must be a non-empty list")

  expect_error(merge_plate_outputs(
    plates = list("not_a_plate"), normalisation_type = "RAU"
  ), "must be of class 'Plate'")

  fake_plate <- structure(list(plate_name = "Fake", plate_datetime = Sys.time()), class = "Plate")

  expect_error(merge_plate_outputs(
    plates = list(fake_plate), normalisation_type = "INVALID"
  ), "`normalisation_type` must be one of:")

  expect_error(merge_plate_outputs(
    plates = list(fake_plate), normalisation_type = c("MFI", "RAU")
  ), "`normalisation_type` must be a single character string")

  expect_error(merge_plate_outputs(
    plates = list(fake_plate), normalisation_type = "RAU", column_collision_strategy = "unknown"
  ), "`column_collision_strategy` must be either")
})
