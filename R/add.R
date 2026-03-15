#' Add IFC calendar units to a date
#'
#' Add a whole number of weeks, months, or years to an `ifc_date` vector using
#' IFC calendar arithmetic. Both `x` and `n` are recycled to a common length.
#'
#' - `add_weeks(x, n)`: adds `n * 7L` days (always exact).
#' - `add_months(x, n)`: calendar arithmetic — preserves the IFC day-of-month
#'   and advances the month by `n`, wrapping across year boundaries. This
#'   correctly handles the June/Sol boundary in leap years.
#' - `add_years(x, n)`: calendar arithmetic — preserves the IFC month and
#'   day, advancing the year by `n`. For Leap Day inputs, the result is the
#'   Leap Day of the target year; a non-leap target year produces an error.
#'
#' Negative `n` moves backwards.
#'
#' @param x An `ifc_date` vector.
#' @param n Integer number of units to add (may be negative).
#'
#' @return An `ifc_date` vector.
#' @name ifc_add
NULL

#' @rdname ifc_add
#' @export
#' @examples
#' add_weeks(ifc_ymd(2024, 1, 1), 4)    # Feb 1, 2024 (+28 days)
add_weeks <- function(x, n) {
  vec_assert(x, new_ifc_date())
  args <- vec_recycle_common(epoch = vec_data(x), n = as.integer(n))
  new_ifc_date(args$epoch + args$n * 7L)
}

#' @rdname ifc_add
#' @export
#' @examples
#' add_months(ifc_ymd(2024, 1, 1), 6)   # Sol 1, 2024 (skips Leap Day)
#' add_months(ifc_ymd(2024, 13, 1), 1)  # Jan 1, 2025 (wraps to next year)
add_months <- function(x, n) {
  vec_assert(x, new_ifc_date())
  d    <- ifc_decompose(x)
  args <- vec_recycle_common(
    year  = d$year,
    month = d$month,
    day   = d$day,
    yd    = d$is_year_day,
    ld    = d$is_leap_day,
    n     = as.integer(n)
  )

  # Intercalary days have no month — propagate NA
  special <- args$yd | args$ld
  epoch   <- integer(length(args$year))

  if (any(!special)) {
    yr <- args$year[!special]
    mo <- args$month[!special]
    dy <- args$day[!special]
    nn <- args$n[!special]

    total     <- (yr * 13L + (mo - 1L)) + nn
    new_year  <- total %/% 13L
    new_month <- total %% 13L + 1L

    doy_new      <- ifc_to_doy(new_year, new_month, dy, FALSE, FALSE)
    epoch[!special] <- doy_to_epoch(new_year, doy_new)
  }

  if (any(special)) {
    epoch[special] <- NA_integer_
  }

  new_ifc_date(epoch)
}

#' @rdname ifc_add
#' @export
#' @examples
#' add_years(ifc_ymd(2024, 7, 1), 1)    # Sol 1, 2025
#' add_years(ifc_ymd(2024, 7, 1), -1)   # Sol 1, 2023
add_years <- function(x, n) {
  vec_assert(x, new_ifc_date())
  d    <- ifc_decompose(x)
  args <- vec_recycle_common(
    year  = d$year,
    month = d$month,
    day   = d$day,
    yd    = d$is_year_day,
    ld    = d$is_leap_day,
    n     = as.integer(n)
  )

  new_year <- args$year + args$n
  epoch    <- integer(length(new_year))

  # Year Day -> Year Day of target year
  if (any(args$yd)) {
    yr <- new_year[args$yd]
    epoch[args$yd] <- doy_to_epoch(yr, 365L + as.integer(is_leap_year(yr)))
  }

  # Leap Day -> Leap Day of target year (must be a leap year)
  if (any(args$ld)) {
    yr  <- new_year[args$ld]
    bad <- !is_leap_year(yr)
    if (any(bad)) {
      cli_abort(
        "Cannot add {args$n[args$ld][bad]} year{?s} to Leap Day: \\
         {yr[bad]} is not a leap year.",
        call = caller_env()
      )
    }
    epoch[args$ld] <- doy_to_epoch(yr, 169L)
  }

  # Regular days
  reg <- !args$yd & !args$ld
  if (any(reg)) {
    doy_new    <- ifc_to_doy(new_year[reg], args$month[reg], args$day[reg], FALSE, FALSE)
    epoch[reg] <- doy_to_epoch(new_year[reg], doy_new)
  }

  new_ifc_date(epoch)
}
