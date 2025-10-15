library(testthat)


expect_equal_paths <- function(path1, path2) {
  path1 <- fs::path_abs(path1)
  path2 <- fs::path_abs(path2)
  expect_equal(path1, path2)
}

test_that("Test verify numeric join", {
  expect_true(verify_numeric_join(1, 1))
  expect_true(verify_numeric_join(NA, 1))
  expect_true(verify_numeric_join(1, NA))
  expect_false(verify_numeric_join(1, 2))
})

test_that("Test verify character join", {
  expect_true(verify_character_join("a", "a"))
  expect_true(verify_character_join(NULL, "a"))
  expect_true(verify_character_join("a", NULL))
  expect_false(verify_character_join("a", "b"))
})

test_that("Test get join value", {
  expect_equal(get_join_value(1, 1), 1)
  expect_equal(get_join_value(NA, 2), 2)
  expect_equal(get_join_value("a", "b"), NULL)
})

test_that("Test remove empty lists", {
  expect_equal(remove_empty_lists(list(1, 2, list())), list(1, 2))
  expect_equal(remove_empty_lists(list(1, 2, list(1, 2))), list(1, 2, list(1, 2)))
})

test_that("Test is.str.number function", {
  expect_true(is.str.number("1"))
  expect_false(is.str.number("a"))
})

test_that("Test is.scalar", {
  expect_true(is.scalar(1))
  expect_true(is.scalar(NA))
  expect_false(is.scalar(NULL))
  expect_false(is.scalar(c(1, 2)))
})

test_that("Test verbose cat", {
  expect_output(verbose_cat("a", "b"), "ab")
  expect_null(verbose_cat("a", "b", verbose = FALSE))
})

test_that("Test clamp function", {
  expect_equal(clamp(c(1, 0, 2), lower = 1), c(1, 1, 2))
  expect_equal(clamp(c(1, -1, NA), lower = 0), c(1, 0, NA))
  expect_equal(clamp(c(1, 2.2, 3), upper = 2), c(1, 2, 2))
  expect_equal(clamp(c(2, 10, NA), upper = 2), c(2, 2, NA))
})

test_that("Test format dilution function standard case", {
  dilutions <- c("1/2", "1/3", "1/4")
  dilution_values <- c(0.5, 0.33, 0.25)
  sample_types <- c("STANDARD CURVE", "STANDARD CURVE", "STANDARD CURVE")

  expect_equal(format_dilutions(dilutions, dilution_values, sample_types), "1/2, 1/3, 1/4")
})

test_that("Test format dilution function with sample types", {
  dilutions <- c("1/2", "1/3", "1/4")
  dilution_values <- c(0.5, 0.33, 0.25)
  sample_types <- c("STANDARD CURVE", "STANDARD CURVE", "SAMPLE")

  expect_equal(format_dilutions(dilutions, dilution_values, sample_types), "1/2, 1/3")
})

test_that("Test format dilution function with multiple duplicates", {
  dilutions <- c("1/2", "1/3", "1/4", "1/4")
  dilution_values <- c(0.5, 0.33, 0.25, 0.25)
  sample_types <- c("STANDARD CURVE", "STANDARD CURVE", "STANDARD CURVE", "STANDARD CURVE")

  expect_equal(format_dilutions(dilutions, dilution_values, sample_types), "1/2, 1/3, 2x1/4")
})

test_that("Test format dilution function with shuffled dilutions", {
  dilutions <- c("1/4", "1/2", "1/3")
  dilution_values <- c(0.25, 0.5, 0.33)
  sample_types <- c("STANDARD CURVE", "STANDARD CURVE", "STANDARD CURVE")

  expect_equal(format_dilutions(dilutions, dilution_values, sample_types), "1/2, 1/3, 1/4")
})

test_that("Test format dilution function with dilutions equal null", {
  dilutions <- NULL
  dilution_values <- c(0.25, 0.5, 0.33)
  sample_types <- c("STANDARD CURVE", "STANDARD CURVE", "SAMPLE")

  expect_equal(format_dilutions(dilutions, dilution_values, sample_types), NULL)
})


test_that("Test is.decreasing function", {
  expect_true(is.decreasing(NULL))
  expect_true(is.decreasing(c()))
  expect_true(is.decreasing(c(2)))
  expect_true(is.decreasing(c(3, 2, 1)))
  expect_false(is.decreasing(c(1, 2, 3)))
  expect_false(is.decreasing(c(1, 2, 2)))
  expect_error(is.decreasing(c(1, 2, NA)))
  expect_error(is.decreasing("wrong"))
})

test_that("Test validate_filepath_and_output_dir function", {
  tmp_dir <- tempdir(check = TRUE)
  # base case
  expect_equal_paths(
    validate_filepath_and_output_dir("test", tmp_dir, "plate_name", "report", "html"),
    file.path(tmp_dir, "test.html")
  )

  # extension handling
  expect_equal_paths(
    validate_filepath_and_output_dir("test", tmp_dir, "plate_name", "report", "html.html"),
    file.path(tmp_dir, "test.html.html")
  )


  expect_equal_paths(
    validate_filepath_and_output_dir("test.html", tmp_dir, "plate_name", "report", "html"),
    file.path(tmp_dir, "test.html")
  )

  # trailing full stop in extension
  expect_error(validate_filepath_and_output_dir("test", tmp_dir, "plate_name", "report", ".html"))

  # default filename creation
  expect_equal_paths(
    validate_filepath_and_output_dir(NULL, tmp_dir, "plate_name", "report", "html"),
    file.path(tmp_dir, "plate_name_report.html")
  )


  # filename with no output_dir
  expect_warning(
    validate_filepath_and_output_dir(file.path(tmp_dir, "test.html"), tmp_dir, "plate_name", "report", "html")
  )

  expect_no_warning(
    validate_filepath_and_output_dir(file.path(tmp_dir, "test.html"), NULL, "plate_name", "report", "html")
  )

  file.create(file.path(tmp_dir, "test.html"))
  # overwrite existing file
  expect_warning(
    validate_filepath_and_output_dir(file.path(tmp_dir, "test.html"), tmp_dir, "plate_name", "report", "html")
  )

  # create output directory
  expect_no_error(
    validate_filepath_and_output_dir("test.html", file.path(tmp_dir, "output"), "plate_name", "report", "html")
  )

  expect_true(dir.exists(file.path(tmp_dir, "output")))
})

test_that("Test path checking", {
  plate1_filepath <- system.file("extdata", "CovidOISExPONTENT.csv", package = "SerolyzeR", mustWork = TRUE) # get the filepath of the csv dataset
  plate2_filepath <- system.file("extdata", "CovidOISExPONTENT_CO.csv", package = "SerolyzeR", mustWork = TRUE) # get the filepath of the csv dataset
  plate1_rel_filepath <- fs::path_rel(plate1_filepath, start = getwd())

  expect_true(check_path_equal(plate1_filepath, plate1_filepath))
  expect_true(check_path_equal(plate1_filepath, plate1_rel_filepath))
  expect_false(check_path_equal(plate1_filepath, plate2_filepath))
  expect_false(check_path_equal(plate1_filepath, NULL))
  expect_false(check_path_equal(plate1_filepath, "/tmp/non_existent.tsv"))
})

test_that("Test mba format function", {
  expect_true(is_mba_format(SerolyzeR.env$mba_formats[1]))
  expect_true(is_mba_format(NULL, allow_nullable = TRUE))
  expect_false(is_mba_format(NULL, allow_nullable = FALSE))
  expect_false(is_mba_format("invalid", allow_nullable = FALSE))
})

test_that("Test sorting a list", {
  l <- list(a = 2, b = 1)
  sl <- list(b = 1, a = 2)
  expect_equal(sort_list_by(l, decreasing = FALSE), sl)

  l <- list(a = list(v = 2), b = list(v = 1))
  sl <- list(b = list(v = 1), a = list(v = 2))
  expect_equal(sort_list_by(l, decreasing = FALSE, value_f = function(x) x$v), sl)
})

test_that("Test select columns function", {
  df <- data.frame(A = 1:3, B = 4:6)
  result <- select_columns(df, c("A", "B"))
  expect_equal(result, df)

  result <- select_columns(df, c("A", "B", "C"), replace_value = 0)
  expected <- data.frame(A = 1:3, B = 4:6, C = c(0, 0, 0))
  expect_equal(result, expected)
})

test_that("Test merging dataframes via handles intersection", {
  df1 <- data.frame(A = 1:3, B = 4:6)
  df2 <- data.frame(A = 3:5, B = 7:9)
  df3 <- data.frame(A = 7:9, C = 10:12)

  result1 <- merge_dataframes(list(df1), column_collision_strategy = "intersection")
  expected1 <- df1
  expect_equal(result1, expected1)

  result2 <- merge_dataframes(list(df1, df2), column_collision_strategy = "intersection")
  expected2 <- rbind(df1, df2)
  expect_equal(result2, expected2)

  result3 <- merge_dataframes(list(df1, df2, df3), column_collision_strategy = "intersection")
  expected3 <- data.frame(A = c(1:3, 3:5, 7:9))
  expect_equal(result3, expected3)
})

test_that("Test merging dataframes via handles union", {
  df1 <- data.frame(A = 1:3, B = 4:6)
  df2 <- data.frame(A = 3:5, B = 7:9)
  df3 <- data.frame(A = 7:9, C = 10:12)

  result1 <- merge_dataframes(list(df1), column_collision_strategy = "union")
  expected1 <- df1
  expect_equal(result1, expected1)

  result2 <- merge_dataframes(list(df1, df2), column_collision_strategy = "union", fill_value = NA)
  expected2 <- rbind(df1, df2)
  expect_equal(result2, expected2)

  result3 <- merge_dataframes(list(df1, df2, df3), column_collision_strategy = "union", fill_value = NA)
  expected3 <- data.frame(A = c(1:3, 3:5, 7:9), B = c(4:6, 7:9, rep(NA, 3)), C = c(rep(NA, 3), rep(NA, 3), 10:12))
  expect_equal(result3, expected3)
})

test_that("format_ylab returns correct labels", {
  expect_equal(format_ylab("Median", "log10"), "Median Fluorescence Intensity")
  expect_equal(format_ylab("Median", "linear"), "MFI (linear scale)")
  expect_equal(format_ylab("Mean", "log10"), "MFI (Mean)")
  expect_equal(format_ylab("Mean", "linear"), "MFI (Mean) (linear scale)")
  expect_equal(format_ylab("Median", "identity"), "MFI (linear scale)")
})

test_that("format_xlab returns correct labels", {
  expect_equal(format_xlab("Time", "T", "log10"), "Time")
  expect_equal(format_xlab("Time", "T", "linear"), "T (linear scale)")
  expect_equal(format_xlab("Concentration", "Conc", "log10"), "Concentration")
  expect_equal(format_xlab("Concentration", "Conc", "linear"), "Conc (linear scale)")
  expect_equal(format_xlab("Dose", "D", "identity"), "D (linear scale)")
})


test_that("filter_sample_types handles typical valid inputs", {
  sample_types <- c("TEST", "BLANK", "STANDARD CURVE", "TEST", "POSITIVE CONTROL", "TEST")
  # Single type
  expect_equal(
    filter_sample_types(sample_types, "TEST"),
    c(TRUE, FALSE, FALSE, TRUE, FALSE, TRUE)
  )
  # Multiple types
  expect_equal(
    filter_sample_types(sample_types, c("TEST", "STANDARD CURVE")),
    c(TRUE, FALSE, TRUE, TRUE, FALSE, TRUE)
  )
  # ALL wildcard
  expect_true(all(filter_sample_types(sample_types, "ALL")))
  expect_true(all(filter_sample_types(sample_types, c("ALL", "TEST"))))
})

test_that("filter_sample_types returns correct length", {
  sample_types <- rep("TEST", 5)
  res <- filter_sample_types(sample_types, "TEST")
  expect_length(res, length(sample_types))
})

test_that("filter_sample_types errors on invalid sample_types input", {
  expect_error(
    filter_sample_types(NULL, "TEST"),
    "Passed sample types is either NULL or NA"
  )
  expect_error(
    filter_sample_types(c(NA, NA), "TEST"),
    "Passed sample types is either NULL or NA"
  )
  expect_error(
    filter_sample_types(c("TEST", "INVALID"), "TEST"),
    "is not a valid sample type"
  )
})

test_that("filter_sample_types errors on invalid sample_type_filter input", {
  sample_types <- c("TEST", "BLANK")
  expect_error(
    filter_sample_types(sample_types, NULL),
  )
  expect_error(
    filter_sample_types(sample_types, c(NA, "TEST")),
  )
  expect_error(
    filter_sample_types(sample_types, "FOO"),
    "is not a valid sample type"
  )
  expect_error(
    filter_sample_types(sample_types, c("TEST", "FOO")),
    "is not a valid sample type"
  )
})

test_that("Test try_cast_as_numeric function", {
  df1 <- data.frame(A = c("1", "2", "3"), B = c("a", "b", "c"), stringsAsFactors = FALSE)
  df1_res <- data.frame(A = c(1.0, 2.0, 3.0), B = c("a", "b", "c"), stringsAsFactors = FALSE)
  result <- try_cast_as_numeric(df1)
  expect_equal(result, df1_res)

  df2 <- data.frame(A = c("1", "two", "3"), B = c("4", "5", "six"), stringsAsFactors = FALSE)
  result <- try_cast_as_numeric(df2)
  expect_equal(result, df2)

  df3 <- data.frame(A = c(NA, "1", "2"), B = c("4", "5", "6"), stringsAsFactors = FALSE)
  df3_res <- data.frame(A = c(NA, 1.0, 2.0), B = c(4.0, 5.0, 6.0), stringsAsFactors = FALSE)
  result <- try_cast_as_numeric(df3)
  expect_equal(result, df3_res)
})
