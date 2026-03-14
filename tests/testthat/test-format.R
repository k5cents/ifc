test_that("default format is YYYY-MM-DD", {
  x <- ifc_ymd(2024, 7, 14)
  expect_equal(format(x), "2024-07-14")
})

test_that("format tokens work", {
  x <- ifc_ymd(2024, 7, 4)  # Sol 4 = Wednesday (day 4 -> (4-1)%%7+1 = 4 = Wed)
  expect_equal(format(x, "%Y"),      "2024")
  expect_equal(format(x, "%y"),      "24")
  expect_equal(format(x, "%m"),      "07")
  expect_equal(format(x, "%d"),      "04")
  expect_equal(format(x, "%B"),      "Sol")
  expect_equal(format(x, "%b"),      "Sol")
  expect_equal(format(x, "%a"),      "Wed")
  expect_equal(format(x, "%A"),      "Wednesday")
  expect_equal(format(x, "%u"),      "4")
  expect_equal(format(x, "%B %d, %Y"), "Sol 04, 2024")
  expect_equal(format(x, "%%"),      "%")
})

test_that("format %j returns zero-padded day of year", {
  x <- ifc_ymd(2024, 1, 1)
  expect_equal(format(x, "%j"), "001")
})

test_that("Year Day uses special format", {
  yd <- ifc_year_day(2024)
  expect_equal(format(yd), "2024 Year Day")
})

test_that("Leap Day uses special format", {
  ld <- ifc_leap_day(2024)
  expect_equal(format(ld), "2024 Leap Day")
})

test_that("special_fmt can be overridden", {
  yd <- ifc_year_day(2024)
  expect_equal(
    format(yd, special_fmt = c(year_day = "%Y-YD", leap_day = "%Y-LD")),
    "2024-YD"
  )
})

test_that("format returns character of same length as input", {
  x <- ifc_ymd(2024, 1:5, 1)
  expect_length(format(x), 5L)
})

test_that("format handles length-0 input", {
  x <- new_ifc_date(integer(0))
  expect_equal(format(x), character(0))
})

test_that("format vectorises over multiple dates", {
  x <- c(ifc_ymd(2024, 1, 1), ifc_year_day(2024))
  out <- format(x)
  expect_equal(out[1], "2024-01-01")
  expect_equal(out[2], "2024 Year Day")
})

test_that("Sol 14 is a Saturday (day 14 wday = 7)", {
  x <- ifc_ymd(2024, 7, 14)
  expect_equal(format(x, "%a"), "Sat")
  expect_equal(format(x, "%u"), "7")
})
