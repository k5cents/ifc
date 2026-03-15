test_that("default format parses YYYY-MM-DD", {
  expect_equal(ifc_parse("2024-07-14"), ifc_ymd(2024, 7, 14))
})

test_that("round-trip: format() |> ifc_parse() is identity for regular dates", {
  dates <- c(
    ifc_ymd(2024, 1, 1),
    ifc_ymd(2024, 7, 14),
    ifc_ymd(2024, 13, 28),
    ifc_ymd(2023, 6, 28)
  )
  expect_equal(ifc_parse(format(dates)), dates)
})

test_that("round-trip works for Year Day", {
  yd <- ifc_year_day(2024)
  expect_equal(ifc_parse(format(yd)), yd)
})

test_that("round-trip works for Leap Day", {
  ld <- ifc_leap_day(2024)
  expect_equal(ifc_parse(format(ld)), ld)
})

test_that("Year Day detected regardless of format argument", {
  expect_equal(ifc_parse("2024 Year Day", "%Y-%m-%d"), ifc_year_day(2024))
  expect_equal(ifc_parse("2023 Year Day", "%B %d, %Y"), ifc_year_day(2023))
})

test_that("Leap Day detected regardless of format argument", {
  expect_equal(ifc_parse("2024 Leap Day", "%Y-%m-%d"), ifc_leap_day(2024))
})

test_that("Leap Day in non-leap year errors", {
  expect_error(ifc_parse("2023 Leap Day"), "not a leap year")
})

test_that("%B token parses full month names", {
  expect_equal(ifc_parse("Sol 14, 2024", "%B %d, %Y"), ifc_ymd(2024, 7, 14))
  expect_equal(ifc_parse("January 01, 2024", "%B %d, %Y"), ifc_ymd(2024, 1, 1))
  expect_equal(ifc_parse("December 28, 2024", "%B %d, %Y"), ifc_ymd(2024, 13, 28))
})

test_that("%b token parses abbreviated month names", {
  expect_equal(ifc_parse("Sol 14 2024", "%b %d %Y"), ifc_ymd(2024, 7, 14))
  expect_equal(ifc_parse("Jan 01 2024", "%b %d %Y"), ifc_ymd(2024, 1, 1))
})

test_that("%j token parses day-of-year", {
  x <- ifc_ymd(2024, 1, 1)
  expect_equal(ifc_parse("2024-001", "%Y-%j"), x)
})

test_that("%y token parses 2-digit year as 2000s", {
  expect_equal(ifc_parse("24-07-14", "%y-%m-%d"), ifc_ymd(2024, 7, 14))
})

test_that("zero-padded and non-padded month/day both parse", {
  expect_equal(ifc_parse("2024-7-4",  "%Y-%m-%d"), ifc_ymd(2024, 7, 4))
  expect_equal(ifc_parse("2024-07-04", "%Y-%m-%d"), ifc_ymd(2024, 7, 4))
})

test_that("vectorised over multiple strings", {
  x <- c("2024-01-01", "2024-07-14", "2024-13-28")
  expected <- c(ifc_ymd(2024, 1, 1), ifc_ymd(2024, 7, 14), ifc_ymd(2024, 13, 28))
  expect_equal(ifc_parse(x), expected)
})

test_that("mixed regular and intercalary in same vector", {
  x <- c("2024-01-01", "2024 Year Day", "2024 Leap Day")
  expected <- c(ifc_ymd(2024, 1, 1), ifc_year_day(2024), ifc_leap_day(2024))
  expect_equal(ifc_parse(x), expected)
})

test_that("length-0 input returns length-0 ifc_date", {
  result <- ifc_parse(character(0))
  expect_s3_class(result, "ifc_date")
  expect_length(result, 0L)
})

test_that("unparseable string errors with clear message", {
  expect_error(ifc_parse("not a date"), "Cannot parse")
})

test_that("out-of-range month errors", {
  expect_error(ifc_parse("2024-14-01"), "out of range")
})

test_that("out-of-range day errors", {
  expect_error(ifc_parse("2024-01-29"), "out of range")
})

test_that("non-character input errors", {
  expect_error(ifc_parse(20240101L), "must be a character vector")
})

test_that("format without year token errors", {
  expect_error(ifc_parse("07-14", "%m-%d"), "year token")
})

test_that("format without month/day or doy errors", {
  expect_error(ifc_parse("2024", "%Y"), "must include")
})

test_that("%% literal percent in format is handled", {
  expect_equal(ifc_parse("2024%07%14", "%Y%%%m%%%d"), ifc_ymd(2024, 7, 14))
})
