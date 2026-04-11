test_that("ifc_interval() creates an ifc_interval object", {
  iv <- ifc_interval(ifc_ymd(2024, 1, 1), ifc_ymd(2024, 2, 1))
  expect_s3_class(iv, "ifc_interval")
  expect_s3_class(iv$start, "ifc_date")
  expect_s3_class(iv$end,   "ifc_date")
})

test_that("ifc_interval() recycles start and end", {
  iv <- ifc_interval(ifc_ymd(2024, 1, 1), ifc_ymd(2024, c(2, 3, 4), 1))
  expect_length(iv$start, 3L)
  expect_length(iv$end,   3L)
})

test_that("ifc_interval() accepts Date input via coercion", {
  start <- as.Date("2024-01-01")
  end   <- as.Date("2024-01-29")   # 28 days later
  iv    <- ifc_interval(start, end)
  expect_equal(iv / "day", 28L)
})

test_that("iv / 'day' returns integer days", {
  iv <- ifc_interval(ifc_ymd(2024, 1, 1), ifc_ymd(2024, 2, 1))
  expect_equal(iv / "day", 28L)
})

test_that("iv / 'week' returns days / 7", {
  # One IFC month = 28 days = 4 weeks exactly
  iv <- ifc_interval(ifc_ymd(2024, 1, 1), ifc_ymd(2024, 2, 1))
  expect_equal(iv / "week", 4)
})

test_that("iv / 'month' returns days / 28", {
  # Three IFC months: Jan -> Apr (no intercalary days in that span)
  iv <- ifc_interval(ifc_ymd(2024, 1, 1), ifc_ymd(2024, 4, 1))
  expect_equal(iv / "month", 3)
})

test_that("iv / 'day' is vectorised over interval length", {
  # Spans of 28, 56, 84 days
  iv <- ifc_interval(ifc_ymd(2024, 1, 1), ifc_ymd(2024, c(2, 3, 4), 1))
  expect_equal(iv / "day", c(28L, 56L, 84L))
})

test_that("iv / 'month' is vectorised", {
  iv <- ifc_interval(ifc_ymd(2024, 1, 1), ifc_ymd(2024, c(2, 3, 4), 1))
  expect_equal(iv / "month", c(1, 2, 3))
})

test_that("iv / unknown unit errors", {
  iv <- ifc_interval(ifc_ymd(2024, 1, 1), ifc_ymd(2024, 2, 1))
  expect_error(iv / "year", class = "rlang_error")
})

test_that("format.ifc_interval() contains '--' and day count", {
  iv <- ifc_interval(ifc_ymd(2024, 1, 1), ifc_ymd(2024, 2, 1))
  out <- format(iv)
  expect_match(out, "--")
  expect_match(out, "28 days")
})

test_that("format.ifc_interval() uses singular 'day' for 1-day spans", {
  iv <- ifc_interval(ifc_ymd(2024, 1, 1), ifc_ymd(2024, 1, 1) + 1L)
  expect_match(format(iv), "1 day\\]")
})

test_that("print.ifc_interval() is invisible", {
  iv <- ifc_interval(ifc_ymd(2024, 1, 1), ifc_ymd(2024, 2, 1))
  expect_invisible(print(iv))
})

test_that("negative intervals (end before start) work", {
  iv <- ifc_interval(ifc_ymd(2024, 2, 1), ifc_ymd(2024, 1, 1))
  expect_equal(iv / "day", -28L)
})
