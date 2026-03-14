test_that("ifc_date() accepts Date", {
  x <- ifc_date(as.Date("2024-01-01"))
  expect_s3_class(x, "ifc_date")
  expect_identical(vec_data(x), as.integer(as.Date("2024-01-01")))
})

test_that("ifc_date() accepts character (ISO 8601)", {
  x <- ifc_date("2024-06-17")
  expect_s3_class(x, "ifc_date")
  expect_equal(as.Date(x), as.Date("2024-06-17"))
})

test_that("ifc_date() accepts POSIXct", {
  p <- as.POSIXct("2024-01-15 12:00:00", tz = "UTC")
  x <- ifc_date(p)
  expect_s3_class(x, "ifc_date")
  expect_equal(as.Date(x), as.Date("2024-01-15"))
})

test_that("ifc_date() is idempotent on ifc_date", {
  x <- ifc_date(as.Date("2024-03-10"))
  expect_identical(ifc_date(x), x)
})

test_that("ifc_date() accepts numeric (epoch days)", {
  d <- as.Date("2024-01-01")
  x <- ifc_date(as.integer(unclass(d)))
  expect_equal(as.Date(x), d)
})

test_that("ifc_ymd() constructs correctly", {
  # Sol 1, 2024 = Gregorian 2024-06-18
  x <- ifc_ymd(2024, 7, 1)
  expect_s3_class(x, "ifc_date")
  expect_equal(as.Date(x), as.Date("2024-06-18"))
  expect_equal(ifc_month(x), 7L)
  expect_equal(ifc_day(x),   1L)
  expect_equal(ifc_year(x),  2024L)
})

test_that("ifc_ymd() constructs January 1 = Gregorian January 1", {
  x <- ifc_ymd(2024, 1, 1)
  expect_equal(as.Date(x), as.Date("2024-01-01"))
})

test_that("ifc_ymd() recycles arguments", {
  x <- ifc_ymd(2024, 1:3, 1)
  expect_length(x, 3)
})

test_that("ifc_ymd() errors on bad month", {
  expect_error(ifc_ymd(2024, 14, 1), class = "rlang_error")
  expect_error(ifc_ymd(2024, 0,  1), class = "rlang_error")
})

test_that("ifc_ymd() errors on bad day", {
  expect_error(ifc_ymd(2024, 1, 29), class = "rlang_error")
  expect_error(ifc_ymd(2024, 1, 0),  class = "rlang_error")
})

test_that("ifc_year_day() works", {
  # Non-leap: Year Day = Dec 31 Gregorian
  x <- ifc_year_day(2023)
  expect_true(is_year_day(x))
  expect_equal(as.Date(x), as.Date("2023-12-31"))

  # Leap: Year Day = Dec 31 Gregorian (still last day)
  x2 <- ifc_year_day(2024)
  expect_true(is_year_day(x2))
  expect_equal(as.Date(x2), as.Date("2024-12-31"))
})

test_that("ifc_leap_day() works", {
  x <- ifc_leap_day(2024)
  expect_true(is_leap_day(x))
  # Leap Day is Gregorian June 17 in 2024 (day 169)
  expect_equal(as.Date(x), as.Date("2024-06-17"))
})

test_that("ifc_leap_day() errors on non-leap year", {
  expect_error(ifc_leap_day(2023), class = "rlang_error")
})

test_that("ifc_date() errors on unparseable character", {
  expect_error(ifc_date("not-a-date"), class = "rlang_error")
  expect_error(ifc_date("2024-13-01"), class = "rlang_error")
})

test_that("ifc_date() passes NA_character_ through as NA", {
  x <- ifc_date(NA_character_)
  expect_s3_class(x, "ifc_date")
  expect_true(is.na(vec_data(x)))
})

test_that("ifc_date() accepts POSIXlt", {
  p <- as.POSIXlt("2024-03-15", tz = "UTC")
  x <- ifc_date(p)
  expect_s3_class(x, "ifc_date")
  expect_equal(as.Date(x), as.Date("2024-03-15"))
})
