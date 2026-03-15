test_that("ifc_week returns 1-52 for regular dates", {
  expect_equal(ifc_week(ifc_ymd(2024, 1,  1)),  1L)   # Jan 1 = week 1
  expect_equal(ifc_week(ifc_ymd(2024, 1,  7)),  1L)   # Jan 7 = week 1
  expect_equal(ifc_week(ifc_ymd(2024, 1,  8)),  2L)   # Jan 8 = week 2
  expect_equal(ifc_week(ifc_ymd(2024, 1, 28)),  4L)   # Jan 28 = week 4
  expect_equal(ifc_week(ifc_ymd(2024, 7, 14)), 26L)   # Sol 14 = week 26 (24+ceil(14/7)=24+2)
  expect_equal(ifc_week(ifc_ymd(2024, 7,  1)), 25L)   # Sol 1 = week 25
  expect_equal(ifc_week(ifc_ymd(2024, 13, 28)), 52L)  # Dec 28 = week 52
})

test_that("ifc_week formula: (month-1)*4 + ceiling(day/7)", {
  for (mo in 1:13) {
    for (dy in c(1L, 7L, 8L, 14L, 15L, 21L, 22L, 28L)) {
      expected <- (mo - 1L) * 4L + as.integer(ceiling(dy / 7L))
      expect_equal(ifc_week(ifc_ymd(2024, mo, dy)), expected)
    }
  }
})

test_that("ifc_week returns NA for Year Day and Leap Day", {
  expect_equal(ifc_week(ifc_year_day(2024)), NA_integer_)
  expect_equal(ifc_week(ifc_leap_day(2024)), NA_integer_)
})

test_that("ifc_week is consistent in leap and non-leap years", {
  # Same IFC position should have same week number
  expect_equal(ifc_week(ifc_ymd(2024, 7, 14)), ifc_week(ifc_ymd(2023, 7, 14)))
  expect_equal(ifc_week(ifc_ymd(2024, 1,  1)), ifc_week(ifc_ymd(2025, 1,  1)))
})

test_that("ifc_week vectorises", {
  x <- ifc_ymd(2024, 1:13, 1)
  expect_equal(ifc_week(x), seq(1L, 49L, by = 4L))
})
