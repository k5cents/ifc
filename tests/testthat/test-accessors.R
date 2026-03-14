test_that("ifc_year() returns integer year", {
  x <- ifc_ymd(2024, 7, 14)
  expect_identical(ifc_year(x), 2024L)
})

test_that("ifc_month() returns 1-13 for regular days", {
  expect_identical(ifc_month(ifc_ymd(2024, 1,  1)), 1L)
  expect_identical(ifc_month(ifc_ymd(2024, 7,  1)), 7L)   # Sol
  expect_identical(ifc_month(ifc_ymd(2024, 13, 1)), 13L)  # December
})

test_that("ifc_month() returns NA for special days", {
  expect_true(is.na(ifc_month(ifc_year_day(2024))))
  expect_true(is.na(ifc_month(ifc_leap_day(2024))))
})

test_that("ifc_day() returns 1-28 for regular days", {
  x <- ifc_ymd(2024, 7, 14)
  expect_identical(ifc_day(x), 14L)
})

test_that("ifc_day() returns NA for special days", {
  expect_true(is.na(ifc_day(ifc_year_day(2024))))
  expect_true(is.na(ifc_day(ifc_leap_day(2024))))
})

test_that("ifc_wday() is deterministic from day-of-month", {
  # Day 1 of any IFC month is always Sunday (1)
  x1 <- ifc_ymd(2024, 1,  1)
  x2 <- ifc_ymd(2024, 7,  1)
  x3 <- ifc_ymd(2023, 13, 1)
  expect_identical(ifc_wday(x1), 1L)
  expect_identical(ifc_wday(x2), 1L)
  expect_identical(ifc_wday(x3), 1L)

  # Day 7 = Saturday (7)
  expect_identical(ifc_wday(ifc_ymd(2024, 1, 7)), 7L)

  # Day 14 = Saturday (7)
  expect_identical(ifc_wday(ifc_ymd(2024, 1, 14)), 7L)

  # Day 8 = Sunday again
  expect_identical(ifc_wday(ifc_ymd(2024, 1, 8)), 1L)
})

test_that("ifc_wday() returns NA for special days", {
  expect_true(is.na(ifc_wday(ifc_year_day(2024))))
  expect_true(is.na(ifc_wday(ifc_leap_day(2024))))
})

test_that("ifc_wday(label=TRUE) returns character", {
  x <- ifc_ymd(2024, 1, 1)
  expect_identical(ifc_wday(x, label = TRUE, abbr = TRUE),  "Sun")
  expect_identical(ifc_wday(x, label = TRUE, abbr = FALSE), "Sunday")
})

test_that("ifc_yday() returns day of year", {
  # January 1 = doy 1
  expect_identical(ifc_yday(ifc_ymd(2024, 1, 1)), 1L)
  # Sol 1 non-leap = doy 169
  expect_identical(ifc_yday(ifc_ymd(2023, 7, 1)), 169L)
  # Leap Day = doy 169
  expect_identical(ifc_yday(ifc_leap_day(2024)), 169L)
  # Year Day non-leap = doy 365
  expect_identical(ifc_yday(ifc_year_day(2023)), 365L)
  # Year Day leap = doy 366
  expect_identical(ifc_yday(ifc_year_day(2024)), 366L)
})

test_that("is_year_day() and is_leap_day() are correct", {
  expect_true(is_year_day(ifc_year_day(2024)))
  expect_false(is_year_day(ifc_ymd(2024, 1, 1)))
  expect_true(is_leap_day(ifc_leap_day(2024)))
  expect_false(is_leap_day(ifc_ymd(2024, 1, 1)))
  expect_false(is_leap_day(ifc_year_day(2024)))
})

test_that("ifc_wday(label=TRUE) returns NA for special days", {
  expect_true(is.na(ifc_wday(ifc_year_day(2024), label = TRUE)))
  expect_true(is.na(ifc_wday(ifc_leap_day(2024), label = TRUE)))
})

test_that("accessors error on non-ifc_date input", {
  expect_error(ifc_year(42),         class = "vctrs_error_assert_ptype")
  expect_error(ifc_month("2024"),    class = "vctrs_error_assert_ptype")
  expect_error(ifc_wday(Sys.Date()), class = "vctrs_error_assert_ptype")
})
