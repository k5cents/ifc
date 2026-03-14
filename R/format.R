#' Format an IFC date as a string
#'
#' Converts an `ifc_date` to a character vector using a format string with
#' IFC-aware tokens. Supported tokens:
#'
#' | Token | Meaning |
#' |-------|---------|
#' | `%Y`  | 4-digit year |
#' | `%y`  | 2-digit year (zero-padded) |
#' | `%m`  | Month number 01–13 (or empty for special days) |
#' | `%d`  | Day 01–28 (or empty for special days) |
#' | `%B`  | Full month name (e.g. "Sol") |
#' | `%b`  | Abbreviated month name (e.g. "Sol") |
#' | `%j`  | Day of year 001–366 |
#' | `%A`  | Full weekday name |
#' | `%a`  | Abbreviated weekday name |
#' | `%u`  | Weekday as integer (1=Sunday, 7=Saturday) |
#' | `%%`  | Literal `%` |
#'
#' For Year Day and Leap Day, month/day/weekday tokens produce an empty string.
#' Those rows always display their special label using the `special_fmt`
#' argument.
#'
#' @param x An `ifc_date` vector.
#' @param format Character string of format tokens. Default: `"%Y-%m-%d"`.
#' @param special_fmt Named character vector with entries `"year_day"` and
#'   `"leap_day"` giving the format used for special days. The only token
#'   available in `special_fmt` is `%Y`. Default: `c(year_day = "%Y Year Day",
#'   leap_day = "%Y Leap Day")`.
#' @param ... Ignored; included for S3 consistency.
#'
#' @return Character vector the same length as `x`.
#' @export
#' @examples
#' x <- ifc_ymd(2024, 7, 14)
#' format(x)                         # "2024-07-14"
#' format(x, "%B %d, %Y")            # "Sol 14, 2024"
#' format(ifc_year_day(2024))        # "2024 Year Day"
format.ifc_date <- function(
    x,
    format       = "%Y-%m-%d",
    special_fmt  = c(year_day = "%Y Year Day", leap_day = "%Y Leap Day"),
    ...) {

  if (length(x) == 0L) return(character(0L))

  d   <- ifc_decompose(x)
  n   <- length(x)
  yr4 <- formatC(d$year, width = 4, flag = "0", mode = "integer")
  yr2 <- substr(yr4, 3, 4)
  mo  <- fmt_int(d$month, 2)
  dy  <- fmt_int(d$day, 2)
  mof <- ifelse(is.na(d$month), "", IFC_MONTH_NAMES[d$month])
  mob <- ifelse(is.na(d$month), "", IFC_MONTH_ABBR[d$month])
  jdy <- formatC(d$doy, width = 3, flag = "0", mode = "integer")
  wdn <- as.character((d$day - 1L) %% 7L + 1L)   # NA -> "NA", fixed below
  wdn[is.na(d$day)] <- ""
  wda <- ifelse(is.na(d$day), "", IFC_WDAY_ABBR[(d$day - 1L) %% 7L + 1L])
  wdf <- ifelse(is.na(d$day), "", IFC_WDAY_NAMES[(d$day - 1L) %% 7L + 1L])

  tokens <- list(
    "%Y" = yr4, "%y" = yr2,
    "%m" = mo,  "%d" = dy,
    "%B" = mof, "%b" = mob,
    "%j" = jdy,
    "%u" = wdn, "%a" = wda, "%A" = wdf
  )

  out <- rep(format, n)
  for (nm in names(tokens)) {
    vals <- tokens[[nm]]
    out  <- mapply(
      FUN = function(s, v) sub(nm, v, s, fixed = TRUE),
      out, vals,
      SIMPLIFY = TRUE, USE.NAMES = FALSE
    )
  }
  out <- gsub("%%", "%", out, fixed = TRUE)

  # Overwrite special days with their own format
  yd_fmt  <- special_fmt[["year_day"]]
  ld_fmt  <- special_fmt[["leap_day"]]

  apply_special <- function(mask, fmt_str) {
    if (!is.null(fmt_str) && any(mask)) {
      out[mask] <<- sub("%Y", yr4[mask], fmt_str, fixed = TRUE)
    }
  }
  apply_special(d$is_year_day, yd_fmt)
  apply_special(d$is_leap_day, ld_fmt)

  out
}

#' @export
print.ifc_date <- function(x, ...) {
  cat(format(new_vctr(integer(0L), class = "ifc_date")), sep = "")
  cat("<ifc_date[", length(x), "]>\n", sep = "")
  if (length(x) > 0L) {
    out <- format(x)
    print(out)
  }
  invisible(x)
}

