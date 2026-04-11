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

test_that("lubridate::as_datetime() on ifc_date returns midnight POSIXct", {
  x  <- ifc_ymd(2024, 7, 1)
  dt <- lubridate::as_datetime(x, tz = "UTC")
  expect_s3_class(dt, "POSIXct")
  expect_equal(as.integer(dt) %% 86400L, 0L)  # midnight = 0 seconds into day
})

# ---- floor_date / ceiling_date / round_date ---------------------------------
# NOTE: lubridate >= 1.9 delegates floor_date/ceiling_date/round_date to the
# timechange package, which does not use S3 dispatch and rejects unknown classes.
# Transparent `lubridate::floor_date(x)` dispatch is therefore not possible.
# The methods are registered via s3_register() for future compatibility (in case
# lubridate reverts to UseMethod dispatch) and for explicit method invocation.
# Users should call ifc_floor() / ifc_ceiling() / ifc_round() directly.

test_that("floor_date.ifc_date() floors to week boundary", {
  x <- ifc_ymd(2024, 7, 14)  # Sol 14 (Saturday)
  expect_equal(ifc:::floor_date.ifc_date(x, "week"), ifc_ymd(2024, 7, 8))  # Sol 8 (Sunday)
})

test_that("floor_date.ifc_date() floors to month boundary", {
  x <- ifc_ymd(2024, 7, 14)
  expect_equal(ifc:::floor_date.ifc_date(x, "month"), ifc_ymd(2024, 7, 1))
})

test_that("floor_date.ifc_date() floors to year boundary", {
  x <- ifc_ymd(2024, 7, 14)
  expect_equal(ifc:::floor_date.ifc_date(x, "year"), ifc_ymd(2024, 1, 1))
})

test_that("floor_date.ifc_date() returns x unchanged for 'day'", {
  x <- ifc_ymd(2024, 7, 14)
  expect_equal(ifc:::floor_date.ifc_date(x, "day"), x)
})

test_that("floor_date.ifc_date() accepts plural unit forms", {
  x <- ifc_ymd(2024, 7, 14)
  expect_equal(ifc:::floor_date.ifc_date(x, "weeks"),  ifc_ymd(2024, 7, 8))
  expect_equal(ifc:::floor_date.ifc_date(x, "months"), ifc_ymd(2024, 7, 1))
})

test_that("ceiling_date.ifc_date() advances to next week boundary", {
  x <- ifc_ymd(2024, 7, 14)  # Sol 14 (Saturday)
  expect_equal(ifc:::ceiling_date.ifc_date(x, "week"), ifc_ymd(2024, 7, 15))  # Sol 15
})

test_that("ceiling_date.ifc_date() advances to next month boundary", {
  x <- ifc_ymd(2024, 7, 14)
  expect_equal(ifc:::ceiling_date.ifc_date(x, "month"), ifc_ymd(2024, 8, 1))
})

test_that("round_date.ifc_date() rounds to nearest boundary", {
  # Sol 14 — 13 days from Sol 1, 14 days from Aug 1 → floor
  x <- ifc_ymd(2024, 7, 14)
  expect_equal(ifc:::round_date.ifc_date(x, "month"), ifc_ymd(2024, 7, 1))
})

test_that("floor_date.ifc_date() errors on unsupported unit", {
  x <- ifc_ymd(2024, 7, 14)
  expect_error(ifc:::floor_date.ifc_date(x, "quarter"), class = "rlang_error")
})

# ---- ifc_datetime lubridate compat ------------------------------------------

test_that("lubridate::month(label=TRUE) returns IFC month name for ifc_datetime", {
  x <- ifc_datetime("2024-06-18 09:30:00", tz = "UTC")   # IFC Sol 1
  expect_equal(lubridate::month(x, label = TRUE, abbr = TRUE),  "Sol")
  expect_equal(lubridate::month(x, label = TRUE, abbr = FALSE), "Sol")
})

test_that("lubridate::wday() dispatches correctly on ifc_datetime", {
  x <- ifc_datetime("2024-01-01 00:00:00", tz = "UTC")   # IFC Jan 1 = Sunday
  expect_equal(lubridate::wday(x), 1L)
  x7 <- ifc_datetime("2024-01-07 00:00:00", tz = "UTC")  # IFC Jan 7 = Saturday
  expect_equal(lubridate::wday(x7), 7L)
})

test_that("lubridate::yday() dispatches correctly on ifc_datetime", {
  x <- ifc_datetime("2024-01-01 00:00:00", tz = "UTC")
  expect_equal(lubridate::yday(x), 1L)
})

test_that("lubridate::as_date() on ifc_datetime returns the date portion", {
  x  <- ifc_datetime("2024-07-14 23:59:59", tz = "UTC")
  dt <- lubridate::as_date(x)
  expect_s3_class(dt, "Date")
  expect_equal(dt, as.Date("2024-07-14"))
})

test_that("lubridate::tz() returns UTC when tzone attribute is NULL", {
  x <- new_ifc_datetime(0, tzone = "UTC")
  attr(x, "tzone") <- NULL
  expect_equal(lubridate::tz(x), "UTC")
})

test_that("lubridate::force_tz() reinterprets wall-clock in new timezone", {
  # 09:30 UTC, reinterpret as 09:30 America/New_York (UTC-4 summer -> shifts epoch)
  x   <- ifc_datetime("2024-07-14 09:30:00", tz = "UTC")
  est <- lubridate::force_tz(x, "America/New_York")
  expect_s3_class(est, "ifc_datetime")
  # Wall-clock hour unchanged
  expect_equal(ifc_hour(est), 9L)
  # Epoch second shifted by 4 hours (UTC-4 in summer)
  expect_equal(
    vctrs::vec_data(est) - vctrs::vec_data(x),
    4 * 3600
  )
})
