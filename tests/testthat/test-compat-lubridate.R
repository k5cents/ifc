skip_if_not_installed("lubridate")

test_that("lubridate::year() returns IFC year", {
  x <- ifc_ymd(2024, 7, 14)
  expect_identical(lubridate::year(x), 2024L)
})

test_that("lubridate::month() returns IFC month number", {
  expect_identical(lubridate::month(ifc_ymd(2024, 7, 1)),  7L)   # Sol
  expect_identical(lubridate::month(ifc_ymd(2024, 1, 1)),  1L)
  expect_identical(lubridate::month(ifc_ymd(2024, 13, 1)), 13L)
})

test_that("lubridate::month() returns NA for special days", {
  expect_true(is.na(lubridate::month(ifc_year_day(2024))))
  expect_true(is.na(lubridate::month(ifc_leap_day(2024))))
})

test_that("lubridate::month(label = TRUE) returns IFC month names", {
  expect_equal(lubridate::month(ifc_ymd(2024, 7, 1), label = TRUE, abbr = TRUE),  "Sol")
  expect_equal(lubridate::month(ifc_ymd(2024, 1, 1), label = TRUE, abbr = FALSE), "January")
})

test_that("lubridate::mday() returns IFC day of month", {
  expect_identical(lubridate::mday(ifc_ymd(2024, 7, 14)), 14L)
})

test_that("lubridate::mday() returns NA for special days", {
  expect_true(is.na(lubridate::mday(ifc_year_day(2024))))
})

test_that("lubridate::wday() is deterministic from IFC day-of-month", {
  # Day 1 of any month = Sunday = 1
  expect_identical(lubridate::wday(ifc_ymd(2024, 1, 1)), 1L)
  # Day 7 = Saturday = 7
  expect_identical(lubridate::wday(ifc_ymd(2024, 1, 7)), 7L)
})

test_that("lubridate::wday() returns NA for special days", {
  expect_true(is.na(lubridate::wday(ifc_year_day(2024))))
})

test_that("lubridate::yday() returns Gregorian day of year", {
  expect_identical(lubridate::yday(ifc_ymd(2024, 1, 1)), 1L)
  expect_identical(lubridate::yday(ifc_leap_day(2024)), 169L)
})

test_that("lubridate::as_date() converts ifc_date to Date", {
  x <- ifc_ymd(2024, 7, 1)
  d <- lubridate::as_date(x)
  expect_s3_class(d, "Date")
  expect_equal(d, as.Date("2024-06-18"))
})

test_that("lubridate::tz() returns empty string (date-only, no timezone)", {
  expect_equal(lubridate::tz(ifc_ymd(2024, 7, 1)), "")
})

test_that("lubridate::as_datetime() works without warning", {
  x <- ifc_ymd(2024, 7, 1)
  expect_no_warning(lubridate::as_datetime(x))
  expect_s3_class(lubridate::as_datetime(x), "POSIXct")
})
