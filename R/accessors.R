#' Extract components from an IFC date
#'
#' @param x An `ifc_date` vector.
#' @name ifc_accessors
NULL

#' @rdname ifc_accessors
#' @return `ifc_year()`: integer year (same as Gregorian year).
#' @export
#' @examples
#' x <- ifc_ymd(2024, 7, 14)
#' ifc_year(x)
ifc_year <- function(x) {
  vec_assert(x, new_ifc_date())
  ifc_decompose(x)$year
}

#' @rdname ifc_accessors
#' @return `ifc_month()`: integer month 1–13, or `NA` for Year Day / Leap Day.
#'   If `label = TRUE`, returns the IFC month name (e.g. `"Sol"`) or
#'   abbreviated name (e.g. `"Sol"`); intercalary days return `NA_character_`.
#' @export
#' @examples
#' ifc_month(x)                          # 7
#' ifc_month(x, label = TRUE)            # "Sol"
#' ifc_month(x, label = TRUE, abbr = FALSE)  # "Sol"
ifc_month <- function(x, label = FALSE, abbr = TRUE) {
  vec_assert(x, new_ifc_date())
  m <- ifc_decompose(x)$month
  if (!label) return(m)
  nm <- if (abbr) IFC_MONTH_ABBR else IFC_MONTH_NAMES
  ifelse(is.na(m), NA_character_, nm[m])
}

#' @rdname ifc_accessors
#' @return `ifc_day()`: integer day 1–28, or `NA` for Year Day / Leap Day.
#' @export
#' @examples
#' ifc_day(x)  # 14
ifc_day <- function(x) {
  vec_assert(x, new_ifc_date())
  ifc_decompose(x)$day
}

#' @rdname ifc_accessors
#' @return `ifc_yday()`: integer day of year 1–366.
#' @export
#' @examples
#' ifc_yday(x)
ifc_yday <- function(x) {
  vec_assert(x, new_ifc_date())
  ifc_decompose(x)$doy
}

#' @rdname ifc_accessors
#' @param label If `TRUE`, return a character label instead of an integer.
#' @param abbr If `TRUE` (and `label = TRUE`), use abbreviated names.
#' @return `ifc_wday()`: weekday as integer 1 (Sunday) – 7 (Saturday), or
#'   `NA` for Year Day / Leap Day. In the IFC, weekday is fully determined
#'   by `(day - 1) %% 7 + 1`.
#' @export
#' @examples
#' ifc_wday(x)           # 7 (Saturday: day 14 = (14-1)%%7+1 = 7)
#' ifc_wday(x, label = TRUE)   # "Sat"
ifc_wday <- function(x, label = FALSE, abbr = TRUE) {
  vec_assert(x, new_ifc_date())
  d   <- ifc_decompose(x)
  day <- d$day
  n   <- (day - 1L) %% 7L + 1L  # NA propagates for special days
  if (!label) return(n)
  nm <- if (abbr) IFC_WDAY_ABBR else IFC_WDAY_NAMES
  nm[n]
}

#' @rdname ifc_accessors
#' @return `ifc_week()`: integer week-of-year 1–52, or `NA` for Year Day /
#'   Leap Day. Because every IFC month is exactly 4 weeks and every year has
#'   exactly 52 weeks, this is computed directly from month and day:
#'   `(month - 1) * 4 + ceiling(day / 7)`.
#' @export
#' @examples
#' ifc_week(ifc_ymd(2024, 7, 14))   # 26: 6 full months (24 weeks) + week 2 of Sol
#' ifc_week(ifc_year_day(2024))      # NA
ifc_week <- function(x) {
  vec_assert(x, new_ifc_date())
  d <- ifc_decompose(x)
  ifelse(
    is.na(d$month),
    NA_integer_,
    (d$month - 1L) * 4L + as.integer(ceiling(d$day / 7L))
  )
}

#' @rdname ifc_accessors
#' @return `is_year_day()`: logical, `TRUE` if the date is Year Day.
#' @export
#' @examples
#' is_year_day(ifc_year_day(2024))  # TRUE
is_year_day <- function(x) {
  vec_assert(x, new_ifc_date())
  ifc_decompose(x)$is_year_day
}

#' @rdname ifc_accessors
#' @return `is_leap_day()`: logical, `TRUE` if the date is Leap Day.
#' @export
#' @examples
#' is_leap_day(ifc_leap_day(2024))  # TRUE
is_leap_day <- function(x) {
  vec_assert(x, new_ifc_date())
  ifc_decompose(x)$is_leap_day
}
