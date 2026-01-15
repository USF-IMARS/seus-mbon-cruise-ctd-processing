library(testthat)
library(here)

test_that("align_raw_ctd_filename correctly maps filenames", {
  # Test case: WS0906_WS0906_ws0906-0020-5.csv -> WS0906_WS0906_WS0906_21LK.csv
  input_filename <- "WS0906_WS0906_ws0906-0020-5.csv"
  expected_output <- "WS0906_WS0906_WS0906_21LK.csv"
  
  # Clear any cached mapping to ensure clean test
  if (exists("ctd_mapping_cache", envir = .GlobalEnv)) {
    rm(ctd_mapping_cache, envir = .GlobalEnv)
  }
  
  source(here::here("R", "align_raw_ctd_filename.R"))
  
  result <- align_raw_ctd_filename(input_filename)
  
  expect_equal(result, expected_output)
})
