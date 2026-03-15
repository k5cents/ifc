# Internal IFC <-> Gregorian calendar math
# None of these functions are exported.

#' IFC month names (1–13)
#' @export
IFC_MONTH_NAMES <- c(
  "January", "February", "March", "April", "May", "June",
  "Sol",
  "July", "August", "September", "October", "November", "December"
)

#' IFC month abbreviations (1–13)
#' @export
IFC_MONTH_ABBR <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun",
  "Sol",
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)

#' IFC weekday names (Sunday = 1, Saturday = 7)
#' @export
IFC_WDAY_NAMES <- c(
  "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
)

#' IFC weekday abbreviations
#' @export
IFC_WDAY_ABBR <- c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")

# Check if year(s) are leap years (vectorised)
is_leap_year <- function(year) {
  (year %% 4L == 0L & year %% 100L != 0L) | year %% 400L == 0L
}

# Convert integer epoch days to year + day-of-year (vectorised)
# Delegates to base R Date formatting — the only place we touch it.
epoch_to_ydoy <- function(n) {
  d   <- structure(as.double(n), class = "Date")
  yr  <- as.integer(format(d, "%Y"))
  doy <- as.integer(format(d, "%j"))
  list(year = yr, doy = doy)
}

# Convert year + DOY back to epoch integer (vectorised)
doy_to_epoch <- function(year, doy) {
  s <- sprintf("%04d-%03d", as.integer(year), as.integer(doy))
  as.integer(as.Date(s, format = "%Y-%j"))
}

# Convert Gregorian DOY to IFC month/day (vectorised)
# Returns a list: month (1-13, NA for special), day (1-28, NA for special),
# is_year_day (logical), is_leap_day (logical)
doy_to_ifc <- function(year, doy) {
  n       <- length(doy)
  na_mask <- is.na(doy) | is.na(year)
  leap    <- is_leap_year(year)
  n_days  <- 365L + as.integer(leap)

  is_yd  <- !na_mask & doy == n_days   # Year Day
  is_ld  <- !na_mask & leap & doy == 169L  # Leap Day
  special <- is_yd | is_ld

  # For regular days, collapse the leap-day gap
  doy_adj <- doy - as.integer(leap & doy > 169L)

  month <- integer(n)
  day   <- integer(n)

  reg <- !special & !na_mask
  if (any(reg)) {
    month[reg] <- as.integer(ceiling(doy_adj[reg] / 28))
    day[reg]   <- as.integer((doy_adj[reg] - 1L) %% 28L + 1L)
  }

  month[special | na_mask] <- NA_integer_
  day[special | na_mask]   <- NA_integer_

  list(
    month       = month,
    day         = day,
    is_year_day = is_yd,
    is_leap_day = is_ld
  )
}

# Convert IFC year/month/day to Gregorian DOY (vectorised)
# is_year_day and is_leap_day are logical flags for special days
ifc_to_doy <- function(year, month, day, is_year_day, is_leap_day) {
  leap <- is_leap_year(year)
  n    <- length(year)
  doy  <- integer(n)

  # Year Day
  if (any(is_year_day)) {
    doy[is_year_day] <- 365L + as.integer(leap[is_year_day])
  }

  # Leap Day — must be a leap year
  if (any(is_leap_day)) {
    bad <- is_leap_day & !leap
    if (any(bad)) {
      cli_abort("{.arg year} {year[bad]} is not a leap year; cannot create Leap Day.")
    }
    doy[is_leap_day] <- 169L
  }

  # Regular days
  reg <- !is_year_day & !is_leap_day
  if (any(reg)) {
    doy_adj  <- (month[reg] - 1L) * 28L + day[reg]
    doy[reg] <- doy_adj + as.integer(leap[reg] & month[reg] > 6L)
  }

  doy
}

# Decompose an ifc_date integer vector into all components at once.
# Returns a list: year, doy, month, day, is_year_day, is_leap_day
ifc_decompose <- function(x) {
  n    <- vec_data(x)
  ydoy <- epoch_to_ydoy(n)
  ifc  <- doy_to_ifc(ydoy$year, ydoy$doy)
  c(ydoy, ifc)
}

# Safe integer formatting that handles NAs without producing "NA" strings
fmt_int <- function(x, width) {
  out      <- character(length(x))
  ok       <- !is.na(x)
  out[ok]  <- formatC(x[ok], width = width, flag = "0", mode = "integer")
  out[!ok] <- ""
  out
}
