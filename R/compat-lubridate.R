# Compatibility methods for lubridate generics.
#
# lubridate's year(), month(), mday(), wday(), yday() fall back to as.POSIXlt()
# for unknown classes, which would return Gregorian values — wrong for ifc_date.
# These methods ensure correct IFC values are returned when lubridate is loaded.
#
# Registered in .onLoad() via vctrs::s3_register() so that lubridate does not
# need to be in Imports. If lubridate is not installed the registrations are
# silently skipped.

year.ifc_date <- function(x) {
  ifc_year(x)
}

# lubridate::month() signature: month(x, label = FALSE, abbr = TRUE, locale, ...)
month.ifc_date <- function(x, label = FALSE, abbr = TRUE, ...) {
  ifc_month(x, label = label, abbr = abbr)
}

# lubridate uses mday() for day-of-month; day() is an alias
mday.ifc_date <- function(x) {
  ifc_day(x)
}

# lubridate::wday() signature: wday(x, label = FALSE, abbr = TRUE, week_start, ...)
# IFC weeks are always Sunday-anchored so week_start is irrelevant.
wday.ifc_date <- function(x, label = FALSE, abbr = TRUE, week_start = NULL, ...) {
  ifc_wday(x, label = label, abbr = abbr)
}

yday.ifc_date <- function(x) {
  ifc_yday(x)
}

# lubridate::as_date() is the tidyverse-style cast to Date
as_date.ifc_date <- function(x, ...) {
  as.Date(x)
}

# ifc_date is a date-only class with no time component, so tz() returns ""
# (same as base R Date). Without this, lubridate::as_datetime() warns:
# "Don't know how to compute timezone for object of class ifc_date/vctrs_vctr"
tz.ifc_date <- function(x) {
  ""
}

# lubridate::as_datetime() promotes an ifc_date to ifc_datetime at midnight UTC
as_datetime.ifc_date <- function(x, tz = "UTC", ...) {
  ifc_datetime(x, tz = tz)
}

# ---- floor_date / ceiling_date / round_date compat --------------------------

# Map lubridate unit strings to IFC round units.
# lubridate accepts plurals ("weeks"), "N unit" forms ("2 weeks"), and aliases.
# Sub-day units and "day" collapse to "day" (ifc_date is day-precision).
# Unsupported units ("bimonth", "quarter", etc.) abort with a clear message.
.lubridate_to_ifc_unit <- function(unit) {
  u <- tolower(trimws(unit))
  # Strip leading count ("2 weeks" -> "weeks")
  u <- sub("^[0-9]+\\s+", "", u)
  # Strip trailing 's' for plurals ("weeks" -> "week")
  u <- sub("s$", "", u)
  switch(u,
    second = , minute = , hour = , day = "day",
    week  = "week",
    month = "month",
    year  = "year",
    cli_abort(
      paste0(
        "{.arg unit} {.val {unit}} is not supported for {.cls ifc_date}. ",
        "Use {.or {.val {c('day', 'week', 'month', 'year')}}}."
      ),
      call = caller_env()
    )
  )
}

floor_date.ifc_date <- function(x, unit = "second",
                                week_start = getOption("lubridate.week.start", 7),
                                ...) {
  u <- .lubridate_to_ifc_unit(unit)
  if (u == "day") return(x)
  ifc_floor(x, u)
}

ceiling_date.ifc_date <- function(x, unit = "second",
                                  change_on_boundary = NULL,
                                  week_start = getOption("lubridate.week.start", 7),
                                  ...) {
  u <- .lubridate_to_ifc_unit(unit)
  if (u == "day") return(x)
  ifc_ceiling(x, u)
}

round_date.ifc_date <- function(x, unit = "second",
                                week_start = getOption("lubridate.week.start", 7),
                                ...) {
  u <- .lubridate_to_ifc_unit(unit)
  if (u == "day") return(x)
  ifc_round(x, u)
}

# ---- ifc_datetime compat methods ----

year.ifc_datetime <- function(x) {
  ifc_year(ifc_date(as.Date(x)))
}

month.ifc_datetime <- function(x, label = FALSE, abbr = TRUE, ...) {
  ifc_month(ifc_date(as.Date(x)), label = label, abbr = abbr)
}

mday.ifc_datetime <- function(x) {
  ifc_day(ifc_date(as.Date(x)))
}

wday.ifc_datetime <- function(x, label = FALSE, abbr = TRUE,
                              week_start = NULL, ...) {
  ifc_wday(ifc_date(as.Date(x)), label = label, abbr = abbr)
}

yday.ifc_datetime <- function(x) {
  ifc_yday(ifc_date(as.Date(x)))
}

as_date.ifc_datetime <- function(x, ...) {
  as.Date(x)
}

# Return the stored timezone, matching lubridate::tz() behaviour for POSIXct
tz.ifc_datetime <- function(x) {
  tz <- attr(x, "tzone")
  if (is.null(tz)) "UTC" else tz
}

# with_tz() converts the displayed timezone without changing the instant
with_tz.ifc_datetime <- function(x, tzone = "UTC", ...) {
  if (is.null(tzone) || identical(tzone, "")) tzone <- "UTC"
  new_ifc_datetime(vec_data(x), tzone = tzone)
}

# force_tz() reinterprets the wall-clock time in a new timezone
force_tz.ifc_datetime <- function(x, tzone = "UTC", ...) {
  if (is.null(tzone) || identical(tzone, "")) tzone <- "UTC"
  old_tz  <- attr(x, "tzone") %||% "UTC"
  pt_old  <- structure(vec_data(x), class = c("POSIXct", "POSIXt"), tzone = old_tz)
  pt_new  <- lubridate::force_tz(pt_old, tzone = tzone)
  new_ifc_datetime(as.double(pt_new), tzone = tzone)
}
