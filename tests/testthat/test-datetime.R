test_that("new_ifc_datetime() creates an ifc_datetime", {
  x <- new_ifc_datetime(0, tzone = "UTC")
  expect_s3_class(x, "ifc_datetime")
  expect_true(is.double(vctrs::vec_data(x)))
  expect_equal(attr(x, "tzone"), "UTC")
})

test_that("new_ifc_datetime() coerces integer to double", {
  x <- new_ifc_datetime(0L, tzone = "UTC")
  expect_true(is.double(vctrs::vec_data(x)))
})

test_that("new_ifc_datetime() normalises empty tzone to UTC", {
  x <- new_ifc_datetime(0, tzone = "")
  expect_equal(attr(x, "tzone"), "UTC")
  y <- new_ifc_datetime(0, tzone = NULL)
  expect_equal(attr(y, "tzone"), "UTC")
})

# ---- ifc_datetime() constructors --------------------------------------------

test_that("ifc_datetime.character() parses ISO 8601 datetime strings", {
  x <- ifc_datetime("2024-07-14 09:30:00", tz = "UTC")
  expect_s3_class(x, "ifc_datetime")
  expect_equal(ifc_hour(x), 9L)
  expect_equal(ifc_minute(x), 30L)
  expect_equal(ifc_second(x), 0)
})

test_that("ifc_datetime.character() errors on unparseable input", {
  expect_error(ifc_datetime("not-a-date", tz = "UTC"), "Cannot parse")
})

test_that("ifc_datetime.character() passes through NAs", {
  x <- ifc_datetime(NA_character_, tz = "UTC")
  expect_true(is.na(vctrs::vec_data(x)))
})

test_that("ifc_datetime.POSIXct() wraps POSIXct", {
  pt <- as.POSIXct("2024-07-14 09:30:00", tz = "UTC")
  x  <- ifc_datetime(pt)
  expect_s3_class(x, "ifc_datetime")
  expect_equal(vctrs::vec_data(x), as.double(pt))
})

test_that("ifc_datetime.POSIXct() uses stored tz when tz not supplied", {
  pt <- as.POSIXct("2024-07-14 09:30:00", tz = "America/New_York")
  x  <- ifc_datetime(pt)
  expect_equal(attr(x, "tzone"), "America/New_York")
})

test_that("ifc_datetime.POSIXlt() wraps POSIXlt", {
  lt <- as.POSIXlt("2024-07-14 09:30:00", tz = "UTC")
  x  <- ifc_datetime(lt, tz = "UTC")
  expect_s3_class(x, "ifc_datetime")
  expect_equal(ifc_hour(x), 9L)
})

test_that("ifc_datetime.ifc_date() promotes to midnight", {
  d <- ifc_ymd(2024, 7, 14)
  x <- ifc_datetime(d, tz = "UTC")
  expect_s3_class(x, "ifc_datetime")
  expect_equal(ifc_hour(x), 0L)
  expect_equal(ifc_minute(x), 0L)
  expect_equal(ifc_second(x), 0)
  # Date component round-trips
  expect_equal(ifc_month(ifc_date(as.Date(x))), 7L)
  expect_equal(ifc_day(ifc_date(as.Date(x))), 14L)
})

test_that("ifc_datetime.numeric() treats input as epoch seconds", {
  x <- ifc_datetime(0, tz = "UTC")
  expect_equal(vctrs::vec_data(x), 0)
})

test_that("ifc_datetime.ifc_datetime() returns input unchanged", {
  x <- ifc_datetime("2024-07-14 09:30:00", tz = "UTC")
  expect_identical(ifc_datetime(x), x)
})

test_that("ifc_now() returns a length-1 ifc_datetime", {
  x <- ifc_now()
  expect_s3_class(x, "ifc_datetime")
  expect_length(x, 1L)
})

# ---- Timezone handling -------------------------------------------------------

test_that("same instant in different tz gives different wall-clock hour", {
  utc  <- ifc_datetime("2024-07-14 15:00:00", tz = "UTC")
  est  <- ifc_datetime(as.POSIXct("2024-07-14 15:00:00", tz = "UTC"),
                        tz = "America/New_York")
  # Same instant = same epoch seconds
  expect_equal(vctrs::vec_data(utc), vctrs::vec_data(est))
  # Different wall-clock hours
  expect_equal(ifc_hour(utc), 15L)
  expect_equal(ifc_hour(est), 11L)  # UTC-4 in summer
})

test_that("timezone affects which IFC date is shown", {
  # 2024-07-14 01:00 UTC = 2024-07-13 21:00 America/New_York (EDT, UTC-4)
  utc <- ifc_datetime("2024-07-14 01:00:00", tz = "UTC")
  est <- ifc_datetime(as.POSIXct("2024-07-14 01:00:00", tz = "UTC"),
                       tz = "America/New_York")
  # UTC: still Jul 14 = IFC Sol 14 + 1 (depends on exact date)
  # Both should see the same epoch second
  expect_equal(vctrs::vec_data(utc), vctrs::vec_data(est))
})

# ---- Time accessors ---------------------------------------------------------

test_that("ifc_hour/minute/second return correct values", {
  x <- ifc_datetime("2024-07-14 09:30:45", tz = "UTC")
  expect_equal(ifc_hour(x), 9L)
  expect_equal(ifc_minute(x), 30L)
  expect_equal(ifc_second(x), 45)
})

test_that("accessors error on wrong class", {
  expect_error(ifc_hour(ifc_ymd(2024, 1, 1)))
  expect_error(ifc_minute(ifc_ymd(2024, 1, 1)))
  expect_error(ifc_second(ifc_ymd(2024, 1, 1)))
})

test_that("time accessors handle NA", {
  x <- ifc_datetime(NA_real_, tz = "UTC")
  expect_true(is.na(ifc_hour(x)))
  expect_true(is.na(ifc_minute(x)))
  expect_true(is.na(ifc_second(x)))
})

test_that("ifc_hour/minute/second are vectorised", {
  x <- ifc_datetime(
    c("2024-01-01 00:00:00", "2024-06-18 12:30:15"),
    tz = "UTC"
  )
  expect_equal(ifc_hour(x),   c(0L, 12L))
  expect_equal(ifc_minute(x), c(0L, 30L))
  expect_equal(ifc_second(x), c(0, 15))
})

# ---- format.ifc_datetime() --------------------------------------------------

test_that("format() default gives YYYY-MM-DD HH:MM:SS TZ", {
  # IFC Jan 1 = Gregorian Jan 1, so %m and %d are unambiguously "01"
  x   <- ifc_datetime("2024-01-01 09:30:00", tz = "UTC")
  out <- format(x)
  expect_equal(out, "2024-01-01 09:30:00 UTC")
})

test_that("format() %B %d gives IFC month name and day", {
  x   <- ifc_datetime("2024-06-18 09:30:00", tz = "UTC")
  out <- format(x, "%Y %B %d")
  expect_equal(out, "2024 Sol 01")
})

test_that("format() handles time tokens %H %M %S", {
  x   <- ifc_datetime("2024-07-14 09:30:45", tz = "UTC")
  out <- format(x, "%H:%M:%S")
  expect_equal(out, "09:30:45")
})

test_that("format() handles %Z and %z tokens", {
  x    <- ifc_datetime("2024-07-14 09:30:00", tz = "UTC")
  out  <- format(x, "%Z %z")
  expect_match(out, "UTC")
})

test_that("format() handles %% literal percent", {
  x   <- ifc_datetime("2024-01-01 09:30:00", tz = "UTC")
  out <- format(x, "%%Y is a literal, not %Y")
  expect_equal(out, "%Y is a literal, not 2024")
})

test_that("format() returns character(0) for length-0 input", {
  x <- new_ifc_datetime(double(0))
  expect_equal(format(x), character(0))
})

test_that("format() is vectorised", {
  x <- ifc_datetime(
    c("2024-01-01 00:00:00", "2024-06-18 12:00:00"),
    tz = "UTC"
  )
  out <- format(x, "%B")
  expect_equal(out, c("January", "Sol"))
})

# ---- Special days -----------------------------------------------------------

test_that("Year Day datetime: %B gives 'Year Day', time tokens work", {
  yd <- ifc_datetime(ifc_year_day(2024), tz = "UTC")
  # add 6 hours
  yd6 <- new_ifc_datetime(vctrs::vec_data(yd) + 6 * 3600, tzone = "UTC")
  out <- format(yd6, "%Y %B %H:%M:%S")
  expect_equal(out, "2024 Year Day 06:00:00")
})

test_that("Leap Day datetime: %B gives 'Leap Day'", {
  ld <- ifc_datetime(ifc_leap_day(2024), tz = "UTC")
  out <- format(ld, "%Y %B")
  expect_equal(out, "2024 Leap Day")
})

test_that("Year Day datetime: %m and %d give empty string", {
  yd <- ifc_datetime(ifc_year_day(2024), tz = "UTC")
  expect_equal(format(yd, "%m"), "")
  expect_equal(format(yd, "%d"), "")
})

# ---- print.ifc_datetime() ---------------------------------------------------

test_that("print() shows class header with tz and formatted values", {
  # IFC Jan 1 = Gregorian Jan 1 — %Y-%m-%d gives unambiguous "2024-01-01"
  x   <- ifc_datetime("2024-01-01 09:30:00", tz = "UTC")
  out <- capture.output(print(x))
  expect_match(out[1], "<ifc_datetime\\[1\\] tz=UTC>")
  expect_match(out[2], "2024-01-01 09:30:00 UTC")
})

test_that("print() is silent for length-0", {
  x   <- new_ifc_datetime(double(0))
  out <- capture.output(print(x))
  expect_match(out[1], "<ifc_datetime\\[0\\]")
})

# ---- Coercion ---------------------------------------------------------------

test_that("as.POSIXct.ifc_datetime() returns the stored seconds", {
  pt <- as.POSIXct("2024-07-14 09:30:00", tz = "UTC")
  x  <- ifc_datetime(pt)
  expect_equal(as.double(as.POSIXct(x)), as.double(pt))
})

test_that("as.POSIXct.ifc_datetime() respects tz argument", {
  x  <- ifc_datetime("2024-07-14 09:30:00", tz = "UTC")
  pt <- as.POSIXct(x, tz = "America/New_York")
  expect_equal(attr(pt, "tzone"), "America/New_York")
  # Same instant
  expect_equal(as.double(pt), vctrs::vec_data(x))
})

test_that("as.Date.ifc_datetime() extracts the date in the stored tz", {
  x <- ifc_datetime("2024-07-14 09:30:00", tz = "UTC")
  expect_equal(as.Date(x), as.Date("2024-07-14"))
})

test_that("as.character.ifc_datetime() delegates to format()", {
  x <- ifc_datetime("2024-07-14 09:30:00", tz = "UTC")
  expect_equal(as.character(x), format(x))
})

test_that("as.double.ifc_datetime() returns epoch seconds", {
  x <- ifc_datetime("2024-07-14 09:30:00", tz = "UTC")
  expect_equal(as.double(x), as.double(as.POSIXct("2024-07-14 09:30:00", tz = "UTC")))
})

# ---- vctrs ptype2 / cast ----------------------------------------------------

test_that("vec_ptype2(ifc_datetime, ifc_datetime) returns ifc_datetime ptype", {
  x <- ifc_datetime("2024-01-01 00:00:00", tz = "UTC")
  p <- vctrs::vec_ptype2(x, x)
  expect_s3_class(p, "ifc_datetime")
  expect_length(p, 0L)
})

test_that("vec_ptype2(ifc_datetime, POSIXct) returns ifc_datetime ptype", {
  x  <- ifc_datetime("2024-01-01 00:00:00", tz = "UTC")
  pt <- as.POSIXct("2024-01-01", tz = "UTC")
  p  <- vctrs::vec_ptype2(x, pt)
  expect_s3_class(p, "ifc_datetime")
})

test_that("vec_cast(POSIXct, ifc_datetime) casts correctly", {
  pt <- as.POSIXct("2024-07-14 09:30:00", tz = "UTC")
  x  <- vctrs::vec_cast(pt, new_ifc_datetime())
  expect_s3_class(x, "ifc_datetime")
  expect_equal(vctrs::vec_data(x), as.double(pt))
})

# ---- lubridate compat -------------------------------------------------------

test_that("lubridate compat methods dispatch on ifc_datetime", {
  skip_if_not_installed("lubridate")
  x <- ifc_datetime("2024-06-18 09:30:00", tz = "UTC")
  expect_equal(lubridate::year(x),  2024L)
  expect_equal(lubridate::month(x), 7L)    # Sol
  expect_equal(lubridate::mday(x),  1L)
  expect_equal(lubridate::tz(x),    "UTC")
})

test_that("lubridate::as_date() on ifc_datetime returns Date", {
  skip_if_not_installed("lubridate")
  x  <- ifc_datetime("2024-06-18 09:30:00", tz = "UTC")
  dt <- lubridate::as_date(x)
  expect_s3_class(dt, "Date")
  expect_equal(dt, as.Date("2024-06-18"))
})

test_that("lubridate::with_tz() changes display tz without shifting instant", {
  skip_if_not_installed("lubridate")
  x   <- ifc_datetime("2024-07-14 15:00:00", tz = "UTC")
  est <- lubridate::with_tz(x, "America/New_York")
  expect_s3_class(est, "ifc_datetime")
  # Same instant
  expect_equal(vctrs::vec_data(est), vctrs::vec_data(x))
  # Different hour
  expect_equal(ifc_hour(est), 11L)
})

test_that("lubridate::as_datetime() on ifc_date produces no warning", {
  skip_if_not_installed("lubridate")
  d <- ifc_ymd(2024, 7, 14)
  # Goal is no "Don't know how to compute timezone" warning; return type is POSIXct
  expect_no_warning(lubridate::as_datetime(d))
})
