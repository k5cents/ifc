# add_weeks ----------------------------------------------------------------

test_that("add_weeks adds n*7 days", {
  x <- ifc_ymd(2024, 1, 1)
  expect_equal(add_weeks(x, 1L),  x + 7L)
  expect_equal(add_weeks(x, 4L),  ifc_ymd(2024, 2, 1))
  # 52 weeks = 364 days; Year Day falls at DOY 365/366, so 52 weeks from Jan 1
  # lands on Dec 28 (last regular day of the year) in a leap year like 2024
  expect_equal(add_weeks(x, 52L), ifc_ymd(2024, 13, 28))
})

test_that("add_weeks supports negative n", {
  x <- ifc_ymd(2024, 2, 1)
  expect_equal(add_weeks(x, -4L), ifc_ymd(2024, 1, 1))
})

test_that("add_weeks vectorises x and n", {
  x <- ifc_ymd(2024, c(1L, 2L), 1L)
  result <- add_weeks(x, 4L)
  expect_equal(result, ifc_ymd(2024, c(2L, 3L), 1L))

  result2 <- add_weeks(ifc_ymd(2024, 1, 1), c(0L, 4L, 8L))
  expect_equal(result2, ifc_ymd(2024, c(1L, 2L, 3L), 1L))
})

# add_months ---------------------------------------------------------------

test_that("add_months advances calendar month", {
  expect_equal(add_months(ifc_ymd(2024, 1, 1), 1L),  ifc_ymd(2024, 2,  1))
  expect_equal(add_months(ifc_ymd(2024, 1, 1), 6L),  ifc_ymd(2024, 7,  1))
  expect_equal(add_months(ifc_ymd(2024, 1, 1), 12L), ifc_ymd(2024, 13, 1))
})

test_that("add_months skips Leap Day when crossing Sol boundary in leap year", {
  # Jan 1 + 6 months = Sol 1 (not Leap Day)
  result <- add_months(ifc_ymd(2024, 1, 1), 6L)
  expect_equal(result, ifc_ymd(2024, 7, 1))
  expect_false(is_leap_day(result))
})

test_that("add_months wraps correctly across year boundary", {
  expect_equal(add_months(ifc_ymd(2024, 13, 1), 1L), ifc_ymd(2025, 1, 1))
  expect_equal(add_months(ifc_ymd(2024, 12, 1), 2L), ifc_ymd(2025, 1, 1))
  expect_equal(add_months(ifc_ymd(2024, 1,  1), 13L), ifc_ymd(2025, 1, 1))
})

test_that("add_months supports negative n", {
  expect_equal(add_months(ifc_ymd(2024, 7, 1), -6L), ifc_ymd(2024, 1, 1))
  expect_equal(add_months(ifc_ymd(2025, 1, 1), -1L), ifc_ymd(2024, 13, 1))
})

test_that("add_months preserves day-of-month", {
  expect_equal(add_months(ifc_ymd(2024, 1, 14), 6L), ifc_ymd(2024, 7, 14))
  expect_equal(add_months(ifc_ymd(2024, 1, 28), 1L), ifc_ymd(2024, 2, 28))
})

test_that("add_months returns NA for intercalary day inputs", {
  expect_equal(add_months(ifc_year_day(2024), 1L), new_ifc_date(NA_integer_))
  expect_equal(add_months(ifc_leap_day(2024), 1L), new_ifc_date(NA_integer_))
})

test_that("add_months vectorises x and n", {
  x <- ifc_ymd(2024, 1:3, 1L)
  # +12 from months 1-3 → months 13, 1 (next year), 2 (next year)
  expect_equal(add_months(x, 12L), c(ifc_ymd(2024, 13, 1), ifc_ymd(2025, 1:2, 1L)))
  # +13 from months 1-3 → months 1-3 of next year
  expect_equal(add_months(x, 13L), ifc_ymd(2025, 1:3, 1L))

  result <- add_months(ifc_ymd(2024, 1, 1), 0:2)
  expect_equal(result, ifc_ymd(2024, 1:3, 1L))
})

# add_years ----------------------------------------------------------------

test_that("add_years advances year preserving IFC month and day", {
  expect_equal(add_years(ifc_ymd(2024, 7, 1), 1L),  ifc_ymd(2025, 7, 1))
  expect_equal(add_years(ifc_ymd(2024, 1, 1), 1L),  ifc_ymd(2025, 1, 1))
  expect_equal(add_years(ifc_ymd(2024, 13, 28), 1L), ifc_ymd(2025, 13, 28))
})

test_that("add_years supports negative n", {
  expect_equal(add_years(ifc_ymd(2025, 7, 1), -1L), ifc_ymd(2024, 7, 1))
})

test_that("add_years handles Year Day correctly", {
  yd <- ifc_year_day(2024)
  expect_equal(add_years(yd, 1L), ifc_year_day(2025))
  expect_equal(add_years(yd, -1L), ifc_year_day(2023))
})

test_that("add_years handles Leap Day to another leap year", {
  ld <- ifc_leap_day(2024)
  expect_equal(add_years(ld, 4L), ifc_leap_day(2028))
})

test_that("add_years errors when Leap Day target is not a leap year", {
  expect_error(add_years(ifc_leap_day(2024), 1L), "not a leap year")
})

test_that("add_years vectorises", {
  x <- ifc_ymd(2024, 7, 1)
  expect_equal(add_years(x, 0:2), ifc_ymd(2024:2026, 7L, 1L))
})

test_that("add_years n=0 is identity", {
  x <- ifc_ymd(2024, 7, 14)
  expect_equal(add_years(x, 0L), x)
})
