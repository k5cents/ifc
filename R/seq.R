#' Generate a sequence of IFC dates
#'
#' Creates a regular sequence of `ifc_date` values using IFC-native units.
#'
#' `by = "day"` and `by = "week"` use fixed epoch offsets (1 and 7 days).
#' `by = "month"` uses **calendar arithmetic**: the result preserves the same
#' IFC day-of-month, advancing one month at a time and wrapping across year
#' boundaries (month 13 wraps to month 1 of the next year). This correctly
#' skips Leap Day when crossing the June/Sol boundary in a leap year.
#' `by = "year"` similarly preserves IFC month and day, incrementing only the
#' year.
#'
#' Exactly one of `to` or `length.out` must be supplied. Direction (ascending
#' or descending) is inferred from `from` and `to` automatically.
#'
#' Year Day and Leap Day are included in sequences whenever the arithmetic
#' naturally lands on them (e.g. stepping by `"day"` across year-end will
#' pass through Year Day).
#'
#' @param from An `ifc_date` of length 1. The start of the sequence.
#' @param to An `ifc_date` of length 1, or `NULL`. The inclusive end of the
#'   sequence (reached exactly when evenly divisible; otherwise the sequence
#'   stops before overshooting).
#' @param by A string: one of `"day"`, `"week"`, `"month"`, or `"year"`.
#' @param length.out A positive integer giving the desired sequence length, or
#'   `NULL`.
#'
#' @return An `ifc_date` vector.
#' @export
#' @examples
#' # First day of all 13 months in 2024
#' ifc_seq(ifc_ymd(2024, 1, 1), by = "month", length.out = 13)
#'
#' # Weekly sequence between two dates
#' ifc_seq(ifc_ymd(2024, 1, 1), ifc_ymd(2024, 4, 1), by = "week")
#'
#' # Jan 1 for six consecutive years
#' ifc_seq(ifc_ymd(2020, 1, 1), ifc_ymd(2025, 1, 1), by = "year")
ifc_seq <- function(from, to = NULL, by, length.out = NULL) {
  vec_assert(from, new_ifc_date())
  if (length(from) != 1L) {
    cli_abort("{.arg from} must be a single {.cls ifc_date}, not length {length(from)}.")
  }

  valid_by <- c("day", "week", "month", "year")
  if (!is.character(by) || length(by) != 1L || !by %in% valid_by) {
    cli_abort(
      "{.arg by} must be one of {.or {.val {valid_by}}}, not {.val {by}}."
    )
  }

  if (is.null(to) == is.null(length.out)) {
    cli_abort("Exactly one of {.arg to} or {.arg length.out} must be supplied.")
  }

  from_int <- vec_data(from)

  if (!is.null(length.out)) {
    length.out <- as.integer(length.out)
    if (length.out < 1L) {
      cli_abort("{.arg length.out} must be a positive integer.")
    }
    if (length.out == 1L) return(from)
    epochs <- .ifc_seq_n(from, from_int, by, length.out)
  } else {
    to <- vec_cast(to, new_ifc_date())
    if (length(to) != 1L) {
      cli_abort("{.arg to} must be a single {.cls ifc_date}, not length {length(to)}.")
    }
    to_int <- vec_data(to)
    if (from_int == to_int) return(from)
    epochs <- .ifc_seq_to(from, from_int, to_int, by)
  }

  new_ifc_date(as.integer(epochs))
}

# ---- helpers ----------------------------------------------------------------

# Forward sequence of length n from `from`.
.ifc_seq_n <- function(from, from_int, by, n) {
  if (by %in% c("day", "week")) {
    step <- if (by == "day") 1L else 7L
    return(from_int + (seq_len(n) - 1L) * step)
  }

  # Calendar arithmetic for month / year
  d <- ifc_decompose(from)
  out <- integer(n)
  out[1L] <- from_int

  if (by == "month") {
    mo <- d$month
    yr <- d$year
    dy <- d$day
    for (i in seq_len(n - 1L)) {
      mo <- mo + 1L
      if (mo > 13L) { mo <- 1L; yr <- yr + 1L }
      doy_new  <- ifc_to_doy(yr, mo, dy, is_year_day = FALSE, is_leap_day = FALSE)
      out[i + 1L] <- doy_to_epoch(yr, doy_new)
    }
  } else {  # year
    mo <- d$month
    dy <- d$day
    yr <- d$year
    yd <- d$is_year_day
    ld <- d$is_leap_day
    for (i in seq_len(n - 1L)) {
      yr <- yr + 1L
      if (yd) {
        out[i + 1L] <- doy_to_epoch(yr, 365L + as.integer(is_leap_year(yr)))
      } else if (ld) {
        # Leap Day only exists in leap years; skip non-leap years silently
        while (!is_leap_year(yr)) yr <- yr + 1L
        out[i + 1L] <- doy_to_epoch(yr, 169L)
      } else {
        doy_new <- ifc_to_doy(yr, mo, dy, is_year_day = FALSE, is_leap_day = FALSE)
        out[i + 1L] <- doy_to_epoch(yr, doy_new)
      }
    }
  }
  out
}

# Sequence from `from` to `end` epoch; direction inferred from from vs end.
.ifc_seq_to <- function(from, from_int, end_int, by) {
  direction <- sign(end_int - from_int)

  if (by %in% c("day", "week")) {
    step <- (if (by == "day") 1L else 7L) * direction
    return(seq(from_int, end_int, by = step))
  }

  # Calendar arithmetic for month / year
  d  <- ifc_decompose(from)
  mo <- d$month
  dy <- d$day
  yr <- d$year
  yd <- d$is_year_day
  ld <- d$is_leap_day

  out <- from_int
  current_epoch <- from_int

  repeat {
    if (by == "month") {
      mo <- mo + direction
      if (mo > 13L) { mo <- 1L; yr <- yr + 1L }
      if (mo < 1L)  { mo <- 13L; yr <- yr - 1L }
      doy_new   <- ifc_to_doy(yr, mo, dy, is_year_day = FALSE, is_leap_day = FALSE)
      next_epoch <- doy_to_epoch(yr, doy_new)
    } else {  # year
      yr <- yr + direction
      if (yd) {
        next_epoch <- doy_to_epoch(yr, 365L + as.integer(is_leap_year(yr)))
      } else if (ld) {
        while (!is_leap_year(yr)) yr <- yr + direction
        next_epoch <- doy_to_epoch(yr, 169L)
      } else {
        doy_new    <- ifc_to_doy(yr, mo, dy, is_year_day = FALSE, is_leap_day = FALSE)
        next_epoch <- doy_to_epoch(yr, doy_new)
      }
    }

    if ((next_epoch - end_int) * direction > 0L) break  # overshot
    out <- c(out, next_epoch)
    current_epoch <- next_epoch
  }

  out
}
