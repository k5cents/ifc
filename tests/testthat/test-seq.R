test_that("by=day with length.out is equivalent to +0:n days", {
  from <- ifc_ymd(2024, 1, 1)
  result <- ifc_seq(from, by = "day", length.out = 7)
  expect_equal(result, from + 0:6)
  expect_length(result, 7L)
})

test_that("by=week steps exactly 7 days", {
  from <- ifc_ymd(2024, 1, 1)
  result <- ifc_seq(from, by = "week", length.out = 4)
  expect_equal(result, from + c(0L, 7L, 14L, 21L))
})

test_that("by=month uses calendar arithmetic: same day, next month", {
  from <- ifc_ymd(2024, 1, 1)
  result <- ifc_seq(from, by = "month", length.out = 13)
  expect_length(result, 13L)
  # Each result is the 1st of months 1-13 in the same year
  expect_equal(ifc_month(result), 1:13)
  expect_equal(ifc_day(result),   rep(1L, 13L))
  expect_equal(ifc_year(result),  rep(2024L, 13L))
})

test_that("by=month with to", {
  from <- ifc_ymd(2024, 1, 1)
  to   <- ifc_ymd(2024, 13, 1)
  result <- ifc_seq(from, to, by = "month")
  expect_length(result, 13L)
  expect_equal(result[1],  ifc_ymd(2024, 1,  1))
  expect_equal(result[13], ifc_ymd(2024, 13, 1))
})

test_that("by=week with to", {
  from <- ifc_ymd(2024, 1, 1)
  to   <- ifc_ymd(2024, 4, 1)   # 84 days = exactly 12 weeks
  result <- ifc_seq(from, to, by = "week")
  expect_length(result, 13L)   # 0:12 weeks
  expect_equal(result[1],  from)
  expect_equal(result[13], to)
})

test_that("by=day with to", {
  from <- ifc_ymd(2024, 1, 1)
  to   <- ifc_ymd(2024, 1, 7)
  result <- ifc_seq(from, to, by = "day")
  expect_equal(result, from + 0:6)
})

test_that("by=year length.out preserves IFC calendar position", {
  from <- ifc_ymd(2024, 7, 1)
  result <- ifc_seq(from, by = "year", length.out = 4)
  expect_length(result, 4L)
  # Calendar position preserved: same month and day each year
  expect_equal(ifc_year(result),  2024:2027)
  expect_equal(ifc_month(result), rep(7L, 4L))
  expect_equal(ifc_day(result),   rep(1L, 4L))
})

test_that("by=year with to", {
  from <- ifc_ymd(2020, 1, 1)
  to   <- ifc_ymd(2025, 1, 1)
  result <- ifc_seq(from, to, by = "year")
  expect_length(result, 6L)
  expect_equal(ifc_year(result), 2020:2025)
  expect_equal(ifc_month(result), rep(1L, 6L))
  expect_equal(ifc_day(result),   rep(1L, 6L))
})

test_that("descending sequence with to", {
  from <- ifc_ymd(2024, 3, 1)
  to   <- ifc_ymd(2024, 1, 1)
  result <- ifc_seq(from, to, by = "month")
  expect_length(result, 3L)
  expect_equal(result[1], ifc_ymd(2024, 3, 1))
  expect_equal(result[3], ifc_ymd(2024, 1, 1))
})

test_that("descending by=day", {
  from <- ifc_ymd(2024, 1, 7)
  to   <- ifc_ymd(2024, 1, 1)
  result <- ifc_seq(from, to, by = "day")
  expect_equal(result, from - 0:6)
})

test_that("from == to returns length-1 sequence", {
  d <- ifc_ymd(2024, 7, 1)
  expect_equal(ifc_seq(d, d, by = "day"), d)
})

test_that("length.out = 1 returns from", {
  d <- ifc_ymd(2024, 7, 1)
  expect_equal(ifc_seq(d, by = "month", length.out = 1), d)
})

test_that("by=day sequence crosses Year Day naturally", {
  # Dec 27 + 7 days should cross Year Day (Dec 28 + Year Day + Jan 1)
  from <- ifc_ymd(2024, 13, 27)   # IFC Dec 27 = DOY 364
  result <- ifc_seq(from, by = "day", length.out = 5)
  expect_equal(result[2], ifc_ymd(2024, 13, 28))
  expect_equal(result[3], ifc_year_day(2024))
  expect_equal(result[4], ifc_ymd(2025, 1, 1))
  expect_equal(result[5], ifc_ymd(2025, 1, 2))
})

test_that("by=day sequence crosses Leap Day naturally", {
  # IFC June 28 + 1 day = Leap Day in 2024
  from <- ifc_ymd(2024, 6, 28)
  result <- ifc_seq(from, by = "day", length.out = 3)
  expect_equal(result[1], ifc_ymd(2024, 6, 28))
  expect_equal(result[2], ifc_leap_day(2024))
  expect_equal(result[3], ifc_ymd(2024, 7, 1))
})

test_that("ifc_seq returns ifc_date class", {
  result <- ifc_seq(ifc_ymd(2024, 1, 1), by = "day", length.out = 3)
  expect_s3_class(result, "ifc_date")
})

test_that("invalid by errors clearly", {
  expect_error(ifc_seq(ifc_ymd(2024, 1, 1), by = "hour", length.out = 3), "must be one of")
  expect_error(ifc_seq(ifc_ymd(2024, 1, 1), by = 7,      length.out = 3), "must be one of")
})

test_that("both to and length.out errors", {
  expect_error(
    ifc_seq(ifc_ymd(2024, 1, 1), ifc_ymd(2024, 3, 1), by = "month", length.out = 3),
    "Exactly one"
  )
})

test_that("neither to nor length.out errors", {
  expect_error(ifc_seq(ifc_ymd(2024, 1, 1), by = "month"), "Exactly one")
})

test_that("non-ifc_date from errors", {
  expect_error(ifc_seq(as.Date("2024-01-01"), by = "day", length.out = 3))
})
