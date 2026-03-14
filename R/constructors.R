#' Convert to an IFC date
#'
#' Convert a `Date`, `POSIXct`, `POSIXlt`, or `character` (ISO 8601) to an
#' `ifc_date` object.
#'
#' @param x A date-like object: `Date`, `POSIXct`, `POSIXlt`, `character`
#'   (parsed as ISO 8601), or an existing `ifc_date`. Numeric values are
#'   treated as epoch days (days since 1970-01-01), matching base R's `Date`.
#'
#' @return An `ifc_date` vector.
#' @export
#' @examples
#' ifc_date(Sys.Date())
#' ifc_date("2024-06-18")  # IFC Sol 1 in 2024
ifc_date <- function(x) {
  UseMethod("ifc_date")
}

#' @export
ifc_date.ifc_date <- function(x) x

#' @export
ifc_date.Date <- function(x) {
  new_ifc_date(as.integer(unclass(x)))
}

#' @export
ifc_date.POSIXct <- function(x) {
  ifc_date(as.Date(x))
}

#' @export
ifc_date.POSIXlt <- function(x) {
  ifc_date(as.Date(x))
}

#' @export
ifc_date.character <- function(x) {
  d <- suppressWarnings(as.Date(x))
  bad <- is.na(d) & !is.na(x)
  if (any(bad)) {
    cli_abort(
      "Cannot parse {.val {x[bad]}} as a date. Expected ISO 8601 {.val YYYY-MM-DD}.",
      call = caller_env()
    )
  }
  ifc_date(d)
}

#' @export
ifc_date.numeric <- function(x) {
  new_ifc_date(as.integer(x))
}

#' Create an IFC date from year, month, and day components
#'
#' Construct an `ifc_date` from IFC calendar year, month (1–13), and day
#' (1–28). Arguments are recycled to a common length.
#'
#' @param year Integer. Calendar year (same as Gregorian year).
#' @param month Integer 1–13. IFC month number
#'   (7 = Sol, 8 = July, ..., 13 = December).
#' @param day Integer 1–28. Day of the IFC month.
#'
#' @return An `ifc_date` vector.
#' @export
#' @examples
#' ifc_ymd(2024, 7, 1)   # IFC Sol 1, 2024 (= Gregorian 2024-06-18)
#' ifc_ymd(2024, 1, 1)   # IFC January 1, 2024 (= Gregorian 2024-01-01)
ifc_ymd <- function(year, month, day) {
  args <- vec_recycle_common(
    year  = as.integer(year),
    month = as.integer(month),
    day   = as.integer(day)
  )

  bad_mo <- !is.na(args$month) & (args$month < 1L | args$month > 13L)
  if (any(bad_mo)) {
    cli_abort("{.arg month} must be between 1 and 13, not {args$month[bad_mo]}.")
  }
  bad_dy <- !is.na(args$day) & (args$day < 1L | args$day > 28L)
  if (any(bad_dy)) {
    cli_abort("{.arg day} must be between 1 and 28, not {args$day[bad_dy]}.")
  }

  doy   <- ifc_to_doy(args$year, args$month, args$day,
                       is_year_day = FALSE, is_leap_day = FALSE)
  epoch <- doy_to_epoch(args$year, doy)
  new_ifc_date(epoch)
}

#' Create an IFC Year Day
#'
#' Year Day is the intercalary day at the end of each year. It is not part of
#' any month or week in the IFC system.
#'
#' @param year Integer. Calendar year.
#' @return An `ifc_date` vector.
#' @export
#' @examples
#' ifc_year_day(2024)   # = Gregorian 2024-12-31
ifc_year_day <- function(year) {
  year <- as.integer(year)
  leap <- is_leap_year(year)
  doy  <- 365L + as.integer(leap)
  new_ifc_date(doy_to_epoch(year, doy))
}

#' Today's date in the IFC
#'
#' A convenience wrapper around `ifc_date(Sys.Date())`.
#'
#' @return An `ifc_date` of length 1 representing today.
#' @export
#' @examples
#' ifc_today()
ifc_today <- function() {
  ifc_date(Sys.Date())
}

#' Create an IFC Leap Day
#'
#' Leap Day is the intercalary day inserted after IFC June 28 in leap years.
#' It is not part of any month or week in the IFC system.
#'
#' @param year Integer. A leap year.
#' @return An `ifc_date` vector.
#' @export
#' @examples
#' ifc_leap_day(2024)   # = Gregorian 2024-06-17
ifc_leap_day <- function(year) {
  year <- as.integer(year)
  leap <- is_leap_year(year)
  if (any(!leap)) {
    cli_abort(
      "Year {.val {year[!leap]}} is not a leap year; Leap Day does not exist."
    )
  }
  new_ifc_date(doy_to_epoch(year, 169L))
}
