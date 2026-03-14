test_that("as.Date.ifc_date round-trips", {
  d <- as.Date("2024-06-18")
  x <- ifc_date(d)
  expect_equal(as.Date(x), d)
})

test_that("as.POSIXct.ifc_date works", {
  x <- ifc_ymd(2024, 1, 1)
  p <- as.POSIXct(x)
  expect_s3_class(p, "POSIXct")
  expect_equal(as.Date(p), as.Date("2024-01-01"))
})

test_that("as.integer.ifc_date returns epoch days", {
  d <- as.Date("2024-01-01")
  x <- ifc_date(d)
  expect_identical(as.integer(x), as.integer(unclass(d)))
})

test_that("as.character.ifc_date uses format()", {
  x <- ifc_ymd(2024, 7, 1)
  expect_equal(as.character(x), format(x))
})

# vec_cast: FROM types TO ifc_date (these are the directions we support)
test_that("vec_cast: Date -> ifc_date", {
  d <- as.Date("2024-06-18")
  x <- vctrs::vec_cast(d, new_ifc_date())
  expect_s3_class(x, "ifc_date")
  expect_equal(as.Date(x), d)
})

test_that("vec_cast: character -> ifc_date", {
  x <- vctrs::vec_cast("2024-01-01", new_ifc_date())
  expect_s3_class(x, "ifc_date")
  expect_equal(ifc_year(x), 2024L)
})

test_that("vec_cast: integer -> ifc_date", {
  d <- as.Date("2024-01-01")
  epoch <- as.integer(unclass(d))
  x <- vctrs::vec_cast(epoch, new_ifc_date())
  expect_s3_class(x, "ifc_date")
  expect_equal(as.Date(x), d)
})

test_that("vec_ptype2: ifc_date + ifc_date = ifc_date", {
  x <- ifc_ymd(2024, 1, 1)
  pt <- vctrs::vec_ptype2(x, x)
  expect_s3_class(pt, "ifc_date")
})
