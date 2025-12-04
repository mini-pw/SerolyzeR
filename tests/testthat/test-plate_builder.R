test_that("Dilution extraction from sample names", {
  expect_equal(
    as.vector(extract_dilution_from_names(c("POS 1/40", "Unknown4", "CP3 1/50", "P1/2"))),
    c("1/40", NA, "1/50", "1/2")
  )
})

test_that("Dilution extraction from layout", {
  values <- c("1/40", "1/50", "BLANK", "Unknown", "NN 1/5")
  dilutions <- extract_dilutions_from_layout(values)
  expect_equal(dilutions, c("1/40", "1/50", NA, NA, NA))
})

test_that("Test convert dilutions to numeric", {
  dilutions <- c(NA, "1/50", "1/100")
  dilution_values <- convert_dilutions_to_numeric(dilutions)
  expect_equal(dilution_values, c(NA, 0.02, 0.01))
})


# Test cases for translate_sample_names_to_sample_types function
test_that("Sample type is correctly identified as BLANK", {
  expect_equal(
    translate_sample_names_to_sample_types(
      c("B", "BLANK", "BACKGROUND"),
      c("BLANK", "BACKGROUND", "B")
    ),
    c("BLANK", "BLANK", "BLANK")
  )
})

test_that("Sample type is correctly identified as STANDARD CURVE", {
  expect_equal(
    translate_sample_names_to_sample_types(
      c("S", "S 1/10", "S_1/100", "S1/1000"),
      c("STANDARD CURVE", "1/10", "1/100", "1/1000")
    ),
    c("STANDARD CURVE", "STANDARD CURVE", "STANDARD CURVE", "STANDARD CURVE")
  )
})

test_that("Sample type is correctly identified as NEGATIVE CONTROL", {
  expect_equal(
    translate_sample_names_to_sample_types(
      c("NEGATIVE CONTROL", "N", "NEG"),
      c("NEGATIVE CONTROL", "N", "NEGATIVE")
    ),
    c("NEGATIVE CONTROL", "NEGATIVE CONTROL", "NEGATIVE CONTROL")
  )

  expect_equal(
    translate_sample_names_to_sample_types(
      c("NEGATIVE CONTROL", "N", "NEG")
    ),
    c("NEGATIVE CONTROL", "NEGATIVE CONTROL", "NEGATIVE CONTROL")
  )
})

test_that("Sample type is correctly identified as POSITIVE CONTROL", {
  expect_equal(
    translate_sample_names_to_sample_types(
      c("P 1/100", "POS 1/50", "B770 1/2", "B770 1/2", "10/198 1/3", "Sample1", "Sample2", "Sample3"),
      c("POSITIVE CONTROL", "", "", "B770", "10/198", "B770 1/2", "10/198 1/3", "C71/4 1/3")
    ),
    c(
      "POSITIVE CONTROL", "POSITIVE CONTROL", "POSITIVE CONTROL",
      "POSITIVE CONTROL", "POSITIVE CONTROL", "POSITIVE CONTROL",
      "POSITIVE CONTROL", "POSITIVE CONTROL"
    )
  )
})

test_that("Test translating samples with only proportions", {
  expect_equal(
    translate_sample_names_to_sample_types(
      c("BLANK", "1/50", "1/100", "1/1000"),
      c("BLANK", "1/50", "1/100", "1/1000")
    ),
    c("BLANK", "STANDARD CURVE", "STANDARD CURVE", "STANDARD CURVE")
  )
})

test_that("Sample type defaults to TEST when no special conditions are met", {
  expect_equal(
    translate_sample_names_to_sample_types(
      c("TEST1", "Unknown Sample", "SampleX"),
      c("Different Name", "Another Name", "")
    ),
    c("TEST", "TEST", "TEST")
  )
})

test_that("Handling of missing layout names", {
  expect_equal(
    translate_sample_names_to_sample_types(
      c("BLANK", "S", "POS 1/10", "NEGATIVE CONTROL"),
      NULL
    ),
    c("BLANK", "STANDARD CURVE", "POSITIVE CONTROL", "NEGATIVE CONTROL")
  )
})

test_that("Handling of empty layout names", {
  expect_equal(
    translate_sample_names_to_sample_types(
      c("BLANK", "S", "POS 1/10", "NEGATIVE CONTROL"),
      rep("", 4)
    ),
    c("BLANK", "STANDARD CURVE", "POSITIVE CONTROL", "NEGATIVE CONTROL")
  )
})

# Test setters for dilutions, sample types and sample names
test_that("Test setting dilutions", {
  plate <- PlateBuilder$new(
    sample_names = c("S1", "S2", "S3", "S4"),
    analyte_names = c("A1", "A2", "A3", "A4")
  )
  plate$set_dilutions(FALSE, c("1/50", "1/100", "1/200", NA))
  expect_equal(plate$dilutions, c("1/50", "1/100", "1/200", NA))


  plate <- PlateBuilder$new(
    sample_names = c("S1", "S2", "S3", "S4"),
    analyte_names = c("A1", "A2", "A3", "A4")
  )
  plate$set_dilutions(TRUE, c("1/50", "1/100", "1/200", NA))
  expect_equal(plate$dilutions, c("1/50", "1/100", "1/200", NA))


  plate$dilutions <- NULL
  expect_error(plate$set_dilutions(TRUE))
})


test_that("Test setting sample types", {
  plate <- PlateBuilder$new(
    sample_names = c("S1", "S2", "S3", "S4"),
    analyte_names = c("A1", "A2", "A3", "A4")
  )
  plate$set_sample_types(FALSE, c("STANDARD CURVE", "NEGATIVE CONTROL", "POSITIVE CONTROL", "TEST"))
  expect_equal(plate$sample_types, c("STANDARD CURVE", "NEGATIVE CONTROL", "POSITIVE CONTROL", "TEST"))

  expect_error(plate$set_sample_types(FALSE, NULL))

  plate <- PlateBuilder$new(
    sample_names = c("S1", "S2", "S3", "S4"),
    analyte_names = c("A1", "A2", "A3", "A4")
  )
  plate$set_sample_types(TRUE, c("STANDARD CURVE", "NEGATIVE CONTROL", "POSITIVE CONTROL", "TEST"))
  expect_equal(plate$sample_types, c("STANDARD CURVE", "NEGATIVE CONTROL", "POSITIVE CONTROL", "TEST"))

  expect_error(plate$set_sample_types(TRUE))
})


test_that("Test setting sample names", {
  plate <- PlateBuilder$new(
    sample_names = c("S1", "S2", "S3", "S4"),
    analyte_names = c("A1", "A2", "A3", "A4")
  )
  plate$set_sample_names(FALSE)
  expect_equal(plate$sample_names, c("S1", "S2", "S3", "S4"))

  expect_error(plate$set_sample_names(TRUE))
})

test_that("Test get_location_matrix the location matrix", {
  location_matrix <- get_location_matrix(4, 3)

  expect_equal(location_matrix[2, 2], "B2")

  expect_equal(location_matrix[4, 3], "D3")

  expect_equal(location_matrix[1, 1], "A1")

  vector_location_matrix <- get_location_matrix(4, 3, as_vector = TRUE)
  expect_equal(vector_location_matrix, c("A1", "A2", "A3", "B1", "B2", "B3", "C1", "C2", "C3", "D1", "D2", "D3"))
  expect_equal(length(vector_location_matrix), 12)
})

test_that("Test validating valid and invalid plate", {
  plate_builder <- PlateBuilder$new(
    sample_names = c("S1", "S2", "S3", "S4"),
    analyte_names = c("X1", "X2", "X3", "X4", "X5")
  )
  plate_builder$set_plate_name("Test Plate")
  plate_builder$set_plate_datetime(Sys.time())
  plate_builder$set_sample_locations(c("A1", "A2", "B1", "B2"))
  plate_builder$set_sample_types(FALSE, c("BLANK", "STANDARD CURVE", "POSITIVE CONTROL", "TEST"))
  plate_builder$set_dilutions(FALSE, c(NA, "1/50", "1/100", NA))

  df_mfi <- data.frame(
    X1 = c(0.1, 0.2, 0.3, 0.4),
    X2 = c(0.2, 0.3, 0.4, 0.5),
    X3 = c(0.3, 0.4, 0.5, 0.6),
    X4 = c(0.4, 0.5, 0.6, 0.7),
    X5 = c(0.5, 0.6, 0.7, 0.8)
  )
  df_count <- data.frame(
    X1 = c(1, 2, 3, 4),
    X2 = c(2, 3, 4, 5),
    X3 = c(3, 4, 5, 6),
    X4 = c(4, 5, 6, 7),
    X5 = c(5, 6, 7, 8)
  )
  plate_builder$set_data(list("Median" = df_mfi, "Count" = df_count))
  expect_no_error(plate_builder$build(validate = TRUE))

  plate_builder_invalid <- plate_builder$clone(deep = TRUE)
  plate_builder_invalid$sample_locations <- c("A1", "A2", "B1", "B2,", "B3")
  expect_error(plate_builder_invalid$build(validate = TRUE))

  plate_builder_invalid <- plate_builder$clone(deep = TRUE)
  plate_builder_invalid$dilutions <- c(NA, "1/50", "1/100")
  expect_error(plate_builder_invalid$build(validate = TRUE))

  plate_builder_invalid <- plate_builder$clone(deep = TRUE)
  df_count[1, 1] <- 0
  plate_builder_invalid$set_data(list("Median" = df_mfi, "Count" = df_count))
  expect_error(plate_builder_invalid$build(validate = TRUE))
})
