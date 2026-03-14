test_that("ifc_date + integer advances by days", {
  x <- ifc_ymd(2024, 1, 1)
  y <- x + 27L
  expect_s3_class(y, "ifc_date")
  expect_identical(ifc_day(y),   28L)
  expect_identical(ifc_month(y), 1L)
})

test_that("adding crosses month boundary", {
  x <- ifc_ymd(2024, 1, 28)
  y <- x + 1L
  expect_identical(ifc_month(y), 2L)
  expect_identical(ifc_day(y),   1L)
})

test_that("double + ifc_date works (commutative)", {
  x <- ifc_ymd(2024, 1, 1)
  y <- 1 + x   # numeric (not integer literal) uses vec_arith.numeric.ifc_date
  expect_s3_class(y, "ifc_date")
  expect_identical(ifc_day(y), 2L)
})

test_that("ifc_date - integer subtracts days", {
  x <- ifc_ymd(2024, 1, 28)
  y <- x - 27L
  expect_identical(ifc_day(y), 1L)
  expect_identical(ifc_month(y), 1L)
})

test_that("ifc_date - ifc_date returns integer days", {
  x <- ifc_ymd(2024, 1, 1)
  y <- ifc_ymd(2024, 1, 28)
  expect_identical(y - x, 27L)
  expect_type(y - x, "integer")
})

test_that("ifc_date - as.integer(Date) returns integer", {
  x <- ifc_ymd(2024, 1, 28)
  d <- as.integer(as.Date("2024-01-01"))
  diff <- x - d
  expect_s3_class(diff, "ifc_date")  # subtracting integer from ifc gives ifc_date
})

test_that("manual subtraction of epoch integers gives correct day diff", {
  x <- ifc_ymd(2024, 1, 28)
  d <- ifc_date(as.Date("2024-01-01"))
  expect_identical(x - d, 27L)
})

test_that("addition with double works", {
  x <- ifc_ymd(2024, 1, 1)
  y <- x + 1
  expect_s3_class(y, "ifc_date")
  expect_identical(ifc_day(y), 2L)
})
