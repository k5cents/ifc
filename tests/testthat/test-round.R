# ifc_floor ----------------------------------------------------------------

test_that("ifc_floor week: back to Sunday of current week", {
  expect_equal(ifc_floor(ifc_ymd(2024, 7,  1), "week"), ifc_ymd(2024, 7,  1))  # already Sunday
  expect_equal(ifc_floor(ifc_ymd(2024, 7,  7), "week"), ifc_ymd(2024, 7,  1))  # Saturday -> Sol 1
  expect_equal(ifc_floor(ifc_ymd(2024, 7, 14), "week"), ifc_ymd(2024, 7,  8))  # Saturday -> Sol 8
  expect_equal(ifc_floor(ifc_ymd(2024, 7,  8), "week"), ifc_ymd(2024, 7,  8))  # already Sunday
  expect_equal(ifc_floor(ifc_ymd(2024, 7, 11), "week"), ifc_ymd(2024, 7,  8))  # Wednesday -> Sol 8
})

test_that("ifc_floor month: back to day 1", {
  expect_equal(ifc_floor(ifc_ymd(2024, 7,  1), "month"), ifc_ymd(2024, 7, 1))  # already day 1
  expect_equal(ifc_floor(ifc_ymd(2024, 7, 14), "month"), ifc_ymd(2024, 7, 1))
  expect_equal(ifc_floor(ifc_ymd(2024, 7, 28), "month"), ifc_ymd(2024, 7, 1))
  expect_equal(ifc_floor(ifc_ymd(2024,  1,  1), "month"), ifc_ymd(2024, 1, 1))
  expect_equal(ifc_floor(ifc_ymd(2024, 13, 28), "month"), ifc_ymd(2024, 13, 1))
})

test_that("ifc_floor year: back to Jan 1", {
  expect_equal(ifc_floor(ifc_ymd(2024,  1,  1), "year"), ifc_ymd(2024, 1, 1))  # already Jan 1
  expect_equal(ifc_floor(ifc_ymd(2024,  7, 14), "year"), ifc_ymd(2024, 1, 1))
  expect_equal(ifc_floor(ifc_ymd(2024, 13, 28), "year"), ifc_ymd(2024, 1, 1))
})

test_that("ifc_floor week: Year Day -> preceding Sunday (7 days back)", {
  yd <- ifc_year_day(2024)
  expect_equal(ifc_floor(yd, "week"), ifc_ymd(2024, 13, 22))
})

test_that("ifc_floor week: Leap Day -> preceding Sunday (7 days back)", {
  ld <- ifc_leap_day(2024)
  expect_equal(ifc_floor(ld, "week"), ifc_ymd(2024, 6, 22))
})

test_that("ifc_floor month: Year Day -> Dec 1 (28 days back)", {
  expect_equal(ifc_floor(ifc_year_day(2024), "month"), ifc_ymd(2024, 13, 1))
})

test_that("ifc_floor month: Leap Day -> Jun 1 (28 days back)", {
  expect_equal(ifc_floor(ifc_leap_day(2024), "month"), ifc_ymd(2024, 6, 1))
})

test_that("ifc_floor year: Year Day -> Jan 1 same year", {
  expect_equal(ifc_floor(ifc_year_day(2024), "year"), ifc_ymd(2024, 1, 1))
})

test_that("ifc_floor year: Leap Day -> Jan 1 same year", {
  expect_equal(ifc_floor(ifc_leap_day(2024), "year"), ifc_ymd(2024, 1, 1))
})

# ifc_ceiling --------------------------------------------------------------

test_that("ifc_ceiling week: no-op when already on Sunday", {
  expect_equal(ifc_ceiling(ifc_ymd(2024, 7,  1), "week"), ifc_ymd(2024, 7,  1))
  expect_equal(ifc_ceiling(ifc_ymd(2024, 7, 22), "week"), ifc_ymd(2024, 7, 22))
})

test_that("ifc_ceiling week: advance to next Sunday", {
  expect_equal(ifc_ceiling(ifc_ymd(2024, 7,  7), "week"), ifc_ymd(2024, 7,  8))
  expect_equal(ifc_ceiling(ifc_ymd(2024, 7, 14), "week"), ifc_ymd(2024, 7, 15))
  expect_equal(ifc_ceiling(ifc_ymd(2024, 7, 11), "week"), ifc_ymd(2024, 7, 15))
})

test_that("ifc_ceiling week: crosses month boundary cleanly", {
  # Dec 28 (Saturday) -> ceiling = Jan 1 next year (skip Year Day)
  expect_equal(ifc_ceiling(ifc_ymd(2024, 13, 28), "week"), ifc_ymd(2025, 1, 1))
  # Jun 28 (Saturday) in leap year -> ceiling = Sol 1 (skip Leap Day)
  expect_equal(ifc_ceiling(ifc_ymd(2024, 6, 28), "week"), ifc_ymd(2024, 7, 1))
})

test_that("ifc_ceiling month: no-op when already on day 1", {
  expect_equal(ifc_ceiling(ifc_ymd(2024, 7, 1), "month"), ifc_ymd(2024, 7, 1))
})

test_that("ifc_ceiling month: advance to day 1 of next month", {
  expect_equal(ifc_ceiling(ifc_ymd(2024, 7, 14), "month"), ifc_ymd(2024, 8, 1))
  expect_equal(ifc_ceiling(ifc_ymd(2024, 7, 28), "month"), ifc_ymd(2024, 8, 1))
})

test_that("ifc_ceiling month: wraps year boundary", {
  # Dec 14 -> Jan 1 next year
  expect_equal(ifc_ceiling(ifc_ymd(2024, 13, 14), "month"), ifc_ymd(2025, 1, 1))
})

test_that("ifc_ceiling year: no-op when already on Jan 1", {
  expect_equal(ifc_ceiling(ifc_ymd(2024, 1, 1), "year"), ifc_ymd(2024, 1, 1))
})

test_that("ifc_ceiling year: advance to Jan 1 next year", {
  expect_equal(ifc_ceiling(ifc_ymd(2024, 7, 14), "year"), ifc_ymd(2025, 1, 1))
  expect_equal(ifc_ceiling(ifc_year_day(2024),   "year"), ifc_ymd(2025, 1, 1))
  expect_equal(ifc_ceiling(ifc_leap_day(2024),   "year"), ifc_ymd(2025, 1, 1))
})

test_that("ifc_ceiling week: Year Day -> Jan 1 next year", {
  expect_equal(ifc_ceiling(ifc_year_day(2024), "week"), ifc_ymd(2025, 1, 1))
})

test_that("ifc_ceiling week: Leap Day -> Sol 1", {
  expect_equal(ifc_ceiling(ifc_leap_day(2024), "week"), ifc_ymd(2024, 7, 1))
})

test_that("ifc_ceiling month: Year Day -> Jan 1 next year", {
  expect_equal(ifc_ceiling(ifc_year_day(2024), "month"), ifc_ymd(2025, 1, 1))
})

test_that("ifc_ceiling month: Leap Day -> Sol 1", {
  expect_equal(ifc_ceiling(ifc_leap_day(2024), "month"), ifc_ymd(2024, 7, 1))
})

# ifc_round ----------------------------------------------------------------

test_that("ifc_round week: rounds to nearer Sunday", {
  # Day 14 = Saturday: 6 days from Sol 8, 1 day from Sol 15 -> ceiling
  expect_equal(ifc_round(ifc_ymd(2024, 7, 14), "week"), ifc_ymd(2024, 7, 15))
  # Day 11 = Wednesday: 3 days from Sol 8, 4 days from Sol 15 -> floor
  expect_equal(ifc_round(ifc_ymd(2024, 7, 11), "week"), ifc_ymd(2024, 7,  8))
  # Day 1 = Sunday: already on boundary
  expect_equal(ifc_round(ifc_ymd(2024, 7,  1), "week"), ifc_ymd(2024, 7,  1))
})

test_that("ifc_round month: rounds to nearer day-1 boundary", {
  # Day 14: 13 days from Sol 1, 15 days from Aug 1 -> floor
  expect_equal(ifc_round(ifc_ymd(2024, 7, 14), "month"), ifc_ymd(2024, 7, 1))
  # Day 15: 14 days from Sol 1, 14 days from Aug 1 -> tie -> floor
  expect_equal(ifc_round(ifc_ymd(2024, 7, 15), "month"), ifc_ymd(2024, 7, 1))
  # Day 16: 15 days from Sol 1, 13 days from Aug 1 -> ceiling
  expect_equal(ifc_round(ifc_ymd(2024, 7, 16), "month"), ifc_ymd(2024, 8, 1))
})

test_that("ifc_round year: rounds to nearer Jan 1", {
  # Sol 1 = roughly mid-year -> floor (closer to Jan 1 2024 than Jan 1 2025)
  expect_equal(ifc_round(ifc_ymd(2024, 7,  1), "year"), ifc_ymd(2024, 1, 1))
  # Dec 28 -> last day, much closer to next Jan 1
  expect_equal(ifc_round(ifc_ymd(2024, 13, 28), "year"), ifc_ymd(2025, 1, 1))
})

test_that("ifc_round vectorises", {
  x <- ifc_ymd(2024, 7, c(1L, 14L, 28L))
  result <- ifc_round(x, "month")
  expect_equal(result[1], ifc_ymd(2024, 7, 1))
  expect_equal(result[2], ifc_ymd(2024, 7, 1))
  expect_equal(result[3], ifc_ymd(2024, 8, 1))
})

test_that("all three functions return ifc_date", {
  x <- ifc_ymd(2024, 7, 14)
  expect_s3_class(ifc_floor(x,   "month"), "ifc_date")
  expect_s3_class(ifc_ceiling(x, "month"), "ifc_date")
  expect_s3_class(ifc_round(x,   "month"), "ifc_date")
})

test_that("invalid unit errors clearly", {
  x <- ifc_ymd(2024, 7, 14)
  expect_error(ifc_floor(x,   "day"),  "must be one of")
  expect_error(ifc_ceiling(x, "hour"), "must be one of")
})

test_that("floor <= x <= ceiling for all inputs", {
  dates <- c(
    ifc_ymd(2024, 1:13, 14),
    ifc_year_day(2024),
    ifc_leap_day(2024)
  )
  for (unit in c("week", "month", "year")) {
    fl <- ifc_floor(dates, unit)
    cl <- ifc_ceiling(dates, unit)
    expect_true(all(vec_data(fl) <= vec_data(dates)))
    expect_true(all(vec_data(dates) <= vec_data(cl)))
  }
})
