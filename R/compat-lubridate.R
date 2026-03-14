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
  m <- ifc_month(x)
  if (!label) return(m)
  nm <- if (abbr) IFC_MONTH_ABBR else IFC_MONTH_NAMES
  ifelse(is.na(m), NA_character_, nm[m])
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
