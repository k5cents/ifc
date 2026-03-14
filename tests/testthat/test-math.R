test_that("is_leap_year works", {
  expect_true(ifc:::is_leap_year(2024))
  expect_true(ifc:::is_leap_year(2000))
  expect_false(ifc:::is_leap_year(2023))
  expect_false(ifc:::is_leap_year(1900))
  # vectorised
  expect_equal(
    ifc:::is_leap_year(c(2000, 1900, 2024, 2023)),
    c(TRUE, FALSE, TRUE, FALSE)
  )
})

test_that("epoch_to_ydoy round-trips with base R", {
  dates <- as.Date(c("2024-01-01", "2024-06-17", "2024-12-31", "2023-12-31"))
  epoch <- as.integer(unclass(dates))
  res   <- ifc:::epoch_to_ydoy(epoch)
  expect_equal(res$year, c(2024L, 2024L, 2024L, 2023L))
  expect_equal(res$doy,  c(1L, 169L, 366L, 365L))
})

test_that("doy_to_ifc: regular days (non-leap year)", {
  # Sol 1 in non-leap year = doy 169
  res <- ifc:::doy_to_ifc(2023L, 169L)
  expect_equal(res$month, 7L)
  expect_equal(res$day,   1L)
  expect_false(res$is_year_day)
  expect_false(res$is_leap_day)

  # January 1 = doy 1
  res <- ifc:::doy_to_ifc(2023L, 1L)
  expect_equal(res$month, 1L)
  expect_equal(res$day,   1L)

  # December 28 = doy 364
  res <- ifc:::doy_to_ifc(2023L, 364L)
  expect_equal(res$month, 13L)
  expect_equal(res$day,   28L)

  # Year Day = doy 365 (non-leap)
  res <- ifc:::doy_to_ifc(2023L, 365L)
  expect_true(res$is_year_day)
  expect_true(is.na(res$month))
  expect_true(is.na(res$day))
  expect_false(res$is_leap_day)
})

test_that("doy_to_ifc: Leap Day and Sol 1 in leap year", {
  # Leap Day = doy 169 in leap year
  res <- ifc:::doy_to_ifc(2024L, 169L)
  expect_true(res$is_leap_day)
  expect_true(is.na(res$month))
  expect_true(is.na(res$day))

  # Sol 1 in leap year = doy 170
  res <- ifc:::doy_to_ifc(2024L, 170L)
  expect_equal(res$month, 7L)
  expect_equal(res$day,   1L)
  expect_false(res$is_leap_day)

  # Year Day in leap year = doy 366
  res <- ifc:::doy_to_ifc(2024L, 366L)
  expect_true(res$is_year_day)
  expect_false(res$is_leap_day)
})

test_that("doy_to_ifc is vectorised", {
  year <- c(2024L, 2024L, 2024L)
  doy  <- c(1L, 169L, 170L)
  res  <- ifc:::doy_to_ifc(year, doy)
  expect_equal(res$month, c(1L, NA_integer_, 7L))
  expect_equal(res$day,   c(1L, NA_integer_, 1L))
})

test_that("full round-trip DOY for non-leap year", {
  year <- rep(2023L, 365L)
  doy  <- seq_len(365L)
  res  <- ifc:::doy_to_ifc(year, doy)
  back <- ifc:::ifc_to_doy(year, res$month, res$day, res$is_year_day, res$is_leap_day)
  expect_equal(back, doy)
})

test_that("full round-trip DOY for leap year", {
  year <- rep(2024L, 366L)
  doy  <- seq_len(366L)
  res  <- ifc:::doy_to_ifc(year, doy)
  back <- ifc:::ifc_to_doy(year, res$month, res$day, res$is_year_day, res$is_leap_day)
  expect_equal(back, doy)
})
