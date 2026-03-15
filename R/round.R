#' Round an IFC date to a unit boundary
#'
#' Round, floor, or ceiling an `ifc_date` to the nearest `"week"`, `"month"`,
#' or `"year"` boundary. IFC's fixed-length units make these operations exact:
#' every week is 7 days, every month 28 days.
#'
#' Boundary definitions:
#' - **week**: the Sunday (day 1 of a week) that starts the 7-day period.
#' - **month**: day 1 of the IFC month.
#' - **year**: January 1 of the IFC year.
#'
#' Intercalary day behaviour:
#' - Year Day and Leap Day always follow a Saturday (day 28 of a month), so
#'   their week floor is 7 days back (the preceding Sunday) and their month
#'   floor is 28 days back (day 1 of the preceding month).
#' - Ceiling always advances to the next regular boundary: Leap Day ceiling =
#'   Sol 1; Year Day ceiling = January 1 of the following year.
#'
#' `ifc_round()` picks whichever boundary is closer. Ties (e.g. day 15 for
#' `"month"`) round toward the floor.
#'
#' @param x An `ifc_date` vector.
#' @param unit A string: `"week"`, `"month"`, or `"year"`.
#'
#' @return An `ifc_date` vector the same length as `x`.
#' @name ifc_round
NULL

#' @rdname ifc_round
#' @export
#' @examples
#' x <- ifc_ymd(2024, 7, 14)
#' ifc_floor(x, "week")    # Sol 8  (Sunday of the same week)
#' ifc_floor(x, "month")   # Sol 1
#' ifc_floor(x, "year")    # Jan 1, 2024
ifc_floor <- function(x, unit) {
  vec_assert(x, new_ifc_date())
  unit  <- .check_round_unit(unit)
  d     <- ifc_decompose(x)
  epoch <- vec_data(x)
  out   <- epoch
  reg   <- !d$is_year_day & !d$is_leap_day
  spl   <- d$is_year_day | d$is_leap_day

  if (unit == "week") {
    if (any(reg)) out[reg] <- epoch[reg] - (d$day[reg] - 1L) %% 7L
    # Intercalary days follow a day-28 (Saturday); week floor = 7 days back
    if (any(spl)) out[spl] <- epoch[spl] - 7L
  } else if (unit == "month") {
    if (any(reg)) out[reg] <- epoch[reg] - (d$day[reg] - 1L)
    # Intercalary days follow day 28; month floor = 28 days back (= day 1)
    if (any(spl)) out[spl] <- epoch[spl] - 28L
  } else {
    # year: Jan 1 of current year
    out <- doy_to_epoch(d$year, 1L)
  }

  new_ifc_date(as.integer(out))
}

#' @rdname ifc_round
#' @export
#' @examples
#' ifc_ceiling(x, "week")  # Sol 15 (next Sunday)
#' ifc_ceiling(x, "month") # Aug 1  (day 1 of next month)
#' ifc_ceiling(x, "year")  # Jan 1, 2025
ifc_ceiling <- function(x, unit) {
  vec_assert(x, new_ifc_date())
  unit <- .check_round_unit(unit)

  fl           <- ifc_floor(x, unit)
  at_boundary  <- vec_data(x) == vec_data(fl)
  out          <- vec_data(x)

  if (any(!at_boundary)) {
    stepped               <- .ifc_add_one_unit(fl[!at_boundary], unit)
    out[!at_boundary]     <- vec_data(stepped)
  }

  new_ifc_date(as.integer(out))
}

#' @rdname ifc_round
#' @export
#' @examples
#' ifc_round(x, "week")    # Sol 15 (day 14 = Saturday, 1 day from Sol 15)
#' ifc_round(x, "month")   # Sol 1  (day 14 is in the first half; ties go to floor)
#' ifc_round(x, "year")    # Jan 1, 2024
ifc_round <- function(x, unit) {
  vec_assert(x, new_ifc_date())
  unit <- .check_round_unit(unit)

  fl           <- ifc_floor(x, unit)
  cl           <- ifc_ceiling(x, unit)
  dist_floor   <- vec_data(x) - vec_data(fl)
  dist_ceiling <- vec_data(cl) - vec_data(x)

  # Ties go to floor (dist_ceiling strictly less than to prefer ceiling)
  new_ifc_date(as.integer(ifelse(dist_ceiling < dist_floor, vec_data(cl), vec_data(fl))))
}

# ---- helpers ----------------------------------------------------------------

.check_round_unit <- function(unit) {
  valid <- c("week", "month", "year")
  if (!is.character(unit) || length(unit) != 1L || !unit %in% valid) {
    cli_abort(
      "{.arg unit} must be one of {.or {.val {valid}}}, not {.val {unit}}.",
      call = caller_env()
    )
  }
  unit
}

# Add exactly one unit to x, skipping any intercalary day the result lands on.
.ifc_add_one_unit <- function(x, unit) {
  result <- switch(unit,
    week  = x + 7L,
    month = add_months(x, 1L),
    year  = add_years(x, 1L)
  )
  # If we landed on an intercalary day (can happen with week + Dec/Jun),
  # advance one more — the next day is always a Sunday or Jan 1.
  d   <- ifc_decompose(result)
  spl <- d$is_year_day | d$is_leap_day
  if (any(spl)) {
    ep       <- vec_data(result)
    ep[spl]  <- ep[spl] + 1L
    result   <- new_ifc_date(ep)
  }
  result
}
