# ifc_datetime — IFC date + time with timezone support
#
# Backed by a double of seconds since Unix epoch (1970-01-01 00:00:00 UTC),
# identical to base R POSIXct. The timezone is stored as a "tzone" attribute.

# ---- Low-level constructor ---------------------------------------------------

new_ifc_datetime <- function(x = double(), tzone = "UTC") {
  if (!is.double(x)) x <- as.double(x)
  if (is.null(tzone) || identical(tzone, "")) tzone <- "UTC"
  new_vctr(x, tzone = tzone, class = "ifc_datetime")
}

# ---- vctrs type abbreviations ------------------------------------------------

#' @export
vec_ptype_abbr.ifc_datetime <- function(x, ...) "ifcdt"

#' @export
vec_ptype_full.ifc_datetime <- function(x, ...) "ifc_datetime"

# ---- vctrs type hierarchy (vec_ptype2) --------------------------------------

#' @export
#' @method vec_ptype2 ifc_datetime
vec_ptype2.ifc_datetime <- function(x, y, ...) UseMethod("vec_ptype2.ifc_datetime")

#' @export
#' @method vec_ptype2.ifc_datetime ifc_datetime
vec_ptype2.ifc_datetime.ifc_datetime <- function(x, y, ...) new_ifc_datetime()

#' @export
#' @method vec_ptype2.ifc_datetime POSIXct
vec_ptype2.ifc_datetime.POSIXct <- function(x, y, ...) new_ifc_datetime()

#' @export
#' @method vec_ptype2.POSIXct ifc_datetime
vec_ptype2.POSIXct.ifc_datetime <- function(x, y, ...) new_ifc_datetime()

# ---- vctrs casting (vec_cast) ------------------------------------------------

#' @export
#' @method vec_cast ifc_datetime
vec_cast.ifc_datetime <- function(x, to, ...) UseMethod("vec_cast.ifc_datetime")

#' @export
#' @method vec_cast.ifc_datetime ifc_datetime
vec_cast.ifc_datetime.ifc_datetime <- function(x, to, ...) x

#' @export
#' @method vec_cast.ifc_datetime POSIXct
vec_cast.ifc_datetime.POSIXct <- function(x, to, ...) {
  tz <- attr(to, "tzone")
  if (is.null(tz) || identical(tz, "")) tz <- "UTC"
  new_ifc_datetime(as.double(x), tzone = tz)
}

# ---- Internal decompose helper -----------------------------------------------
#
# Extracts all IFC calendar components (year, month, day, doy, is_year_day,
# is_leap_day) PLUS time components (hour, minute, second) from an ifc_datetime.
# tzone is the effective timezone string.

.ifc_decompose_dt <- function(x) {
  tz  <- attr(x, "tzone")
  if (is.null(tz) || identical(tz, "")) tz <- "UTC"
  raw <- vec_data(x)
  pt  <- structure(raw, class = c("POSIXct", "POSIXt"), tzone = tz)
  dt  <- as.Date(pt, tz = tz)
  ep  <- as.integer(unclass(dt))
  d   <- ifc_decompose(new_ifc_date(ep))
  lt  <- as.POSIXlt(pt, tz = tz)
  d$hour   <- lt$hour
  d$minute <- lt$min
  d$second <- as.double(lt$sec)
  d$tzone  <- tz
  d
}

# ---- User-facing constructor -------------------------------------------------

#' Convert to an IFC datetime
#'
#' Convert a `POSIXct`, `POSIXlt`, `character` (ISO 8601 datetime), `ifc_date`,
#' or numeric (seconds since epoch) to an `ifc_datetime` object.
#'
#' @param x A datetime-like object.
#' @param tz Time zone string (e.g. `"UTC"`, `"America/New_York"`). For
#'   `POSIXct` input and `tz` is not supplied, defaults to the timezone already
#'   stored in `x`. For `ifc_date` input, the datetime is placed at midnight
#'   in `tz`.
#'
#' @return An `ifc_datetime` vector.
#' @export
#' @examples
#' ifc_datetime("2024-07-14 09:30:00", tz = "America/New_York")
#' ifc_datetime(ifc_ymd(2024, 7, 14), tz = "UTC")
#' ifc_datetime(Sys.time())
ifc_datetime <- function(x, tz = "UTC") {
  UseMethod("ifc_datetime")
}

#' @export
ifc_datetime.ifc_datetime <- function(x, tz = "UTC") x

#' @export
ifc_datetime.POSIXct <- function(x, tz = "UTC") {
  tz_use <- if (missing(tz)) {
    tz_x <- attr(x, "tzone")
    if (is.null(tz_x) || identical(tz_x, "")) "UTC" else tz_x
  } else {
    tz
  }
  pt <- as.POSIXct(x, tz = tz_use)
  new_ifc_datetime(as.double(pt), tzone = tz_use)
}

#' @export
ifc_datetime.POSIXlt <- function(x, tz = "UTC") {
  ifc_datetime(as.POSIXct(x), tz = tz)
}

#' @export
ifc_datetime.character <- function(x, tz = "UTC") {
  na_sentinel <- structure(
    rep(NA_real_, length(x)),
    class = c("POSIXct", "POSIXt"), tzone = tz
  )
  pt <- tryCatch(
    suppressWarnings(as.POSIXct(x, tz = tz)),
    error = function(e) na_sentinel
  )
  bad <- is.na(pt) & !is.na(x)
  if (any(bad)) {
    cli_abort(
      "Cannot parse {.val {x[bad]}} as a datetime. Expected ISO 8601.",
      call = caller_env()
    )
  }
  new_ifc_datetime(as.double(pt), tzone = tz)
}

#' @export
ifc_datetime.ifc_date <- function(x, tz = "UTC") {
  pt <- as.POSIXct(as.Date(x), tz = tz)
  new_ifc_datetime(as.double(pt), tzone = tz)
}

#' @export
ifc_datetime.numeric <- function(x, tz = "UTC") {
  new_ifc_datetime(as.double(x), tzone = tz)
}

#' @export
ifc_datetime.double <- function(x, tz = "UTC") {
  new_ifc_datetime(x, tzone = tz)
}

#' Current date-time in the IFC
#'
#' A convenience wrapper around `ifc_datetime(Sys.time(), tz = tz)`.
#'
#' @param tz Time zone string. Defaults to `"UTC"`.
#' @return An `ifc_datetime` of length 1 representing right now.
#' @export
#' @examples
#' ifc_now()
#' ifc_now("America/New_York")
ifc_now <- function(tz = "UTC") {
  ifc_datetime(Sys.time(), tz = tz)
}

# ---- Time component accessors ------------------------------------------------

# vec_assert compares ptypes by attribute identity, which fails when the stored
# tzone differs from the prototype. Use inherits() instead.
.assert_ifc_datetime <- function(x, arg = rlang::caller_arg(x),
                                  call = rlang::caller_env()) {
  if (!inherits(x, "ifc_datetime")) {
    cli_abort(
      "{.arg {arg}} must be an <ifc_datetime>, not {.cls {class(x)[1]}}.",
      call = call
    )
  }
  invisible(x)
}

#' Extract time components from an IFC datetime
#'
#' @param x An `ifc_datetime` vector.
#' @name ifc_datetime_accessors
NULL

#' @rdname ifc_datetime_accessors
#' @return `ifc_hour()`: integer 0--23.
#' @export
#' @examples
#' x <- ifc_datetime("2024-07-14 09:30:45", tz = "UTC")
#' ifc_hour(x)
ifc_hour <- function(x) {
  .assert_ifc_datetime(x)
  .ifc_decompose_dt(x)$hour
}

#' @rdname ifc_datetime_accessors
#' @return `ifc_minute()`: integer 0--59.
#' @export
#' @examples
#' ifc_minute(x)
ifc_minute <- function(x) {
  .assert_ifc_datetime(x)
  .ifc_decompose_dt(x)$minute
}

#' @rdname ifc_datetime_accessors
#' @return `ifc_second()`: double 0--60 (60 for leap seconds).
#' @export
#' @examples
#' ifc_second(x)
ifc_second <- function(x) {
  .assert_ifc_datetime(x)
  .ifc_decompose_dt(x)$second
}

# ---- Format ------------------------------------------------------------------

#' Format an IFC datetime as a string
#'
#' Converts an `ifc_datetime` to a character vector using a format string with
#' IFC-aware tokens. Supports all tokens from [format.ifc_date()] plus:
#'
#' | Token | Meaning |
#' |-------|---------|
#' | `%H`  | Hour 00--23 |
#' | `%M`  | Minute 00--59 |
#' | `%S`  | Second 00--60 (zero-padded) |
#' | `%Z`  | Timezone abbreviation (e.g. `"EDT"`) |
#' | `%z`  | UTC offset (e.g. `"+0000"`) |
#'
#' For Year Day and Leap Day, `%B` and `%b` produce `"Year Day"` or
#' `"Leap Day"` respectively; `%m`, `%d`, `%u`, `%a`, `%A` produce empty
#' strings. Time tokens are always applied normally.
#'
#' @param x An `ifc_datetime` vector.
#' @param format Character string of format tokens.
#'   Default: `"%Y-%m-%d %H:%M:%S %Z"`.
#' @param ... Ignored; included for S3 consistency.
#'
#' @return Character vector the same length as `x`.
#' @export
#' @examples
#' x <- ifc_datetime("2024-07-14 09:30:00", tz = "UTC")
#' format(x)                       # "2024-07-14 09:30:00 UTC"
#' format(x, "%Y %B %d %H:%M:%S") # "2024 Sol 14 09:30:00"
format.ifc_datetime <- function(x, format = "%Y-%m-%d %H:%M:%S %Z", ...) {
  if (length(x) == 0L) return(character(0L))

  d  <- .ifc_decompose_dt(x)
  n  <- length(x)
  tz <- d$tzone

  yr4 <- formatC(d$year, width = 4, flag = "0", mode = "integer")
  yr2 <- substr(yr4, 3, 4)
  mo  <- fmt_int(d$month, 2)
  dy  <- fmt_int(d$day, 2)
  jdy <- formatC(d$doy, width = 3, flag = "0", mode = "integer")
  wi  <- (d$day - 1L) %% 7L + 1L  # NA for special days
  wdn <- ifelse(is.na(wi), "", as.character(wi))
  wda <- ifelse(is.na(wi), "", IFC_WDAY_ABBR[wi])
  wdf <- ifelse(is.na(wi), "", IFC_WDAY_NAMES[wi])

  # Month name tokens: special days get the intercalary day label
  mof <- ifelse(is.na(d$month), "", IFC_MONTH_NAMES[d$month])
  mob <- ifelse(is.na(d$month), "", IFC_MONTH_ABBR[d$month])
  mof[d$is_year_day] <- "Year Day"
  mob[d$is_year_day] <- "Year Day"
  mof[d$is_leap_day] <- "Leap Day"
  mob[d$is_leap_day] <- "Leap Day"

  raw <- vec_data(x)
  pt  <- structure(raw, class = c("POSIXct", "POSIXt"), tzone = tz)
  hr  <- formatC(d$hour,   width = 2, flag = "0", mode = "integer")
  mn  <- formatC(d$minute, width = 2, flag = "0", mode = "integer")
  sc  <- formatC(as.integer(d$second), width = 2, flag = "0", mode = "integer")
  tz_abbr   <- format(pt, "%Z")
  tz_offset <- format(pt, "%z")

  tokens <- list(
    "%Y" = yr4, "%y" = yr2,
    "%m" = mo,  "%d" = dy,
    "%B" = mof, "%b" = mob,
    "%j" = jdy,
    "%u" = wdn, "%a" = wda, "%A" = wdf,
    "%H" = hr,  "%M" = mn,  "%S" = sc,
    "%Z" = tz_abbr, "%z" = tz_offset
  )

  sentinel <- "\x01"
  out <- gsub("%%", sentinel, rep(format, n), fixed = TRUE)
  for (nm in names(tokens)) {
    vals <- tokens[[nm]]
    out  <- mapply(
      FUN = function(s, v) gsub(nm, v, s, fixed = TRUE),
      out, vals,
      SIMPLIFY = TRUE, USE.NAMES = FALSE
    )
  }
  gsub(sentinel, "%", out, fixed = TRUE)
}

#' @export
print.ifc_datetime <- function(x, ...) {
  tz <- attr(x, "tzone")
  if (is.null(tz) || identical(tz, "")) tz <- "UTC"
  cat("<ifc_datetime[", length(x), "] tz=", tz, ">\n", sep = "")
  if (length(x) > 0L) print(format(x))
  invisible(x)
}

# ---- Coercion (FROM ifc_datetime) --------------------------------------------

#' Coerce an IFC datetime to a base R datetime type
#'
#' @param x An `ifc_datetime` vector.
#' @param tz Time zone string. If `NULL` (default), uses the timezone stored
#'   in `x`.
#' @param ... Ignored.
#' @return The corresponding base R type.
#' @name ifc_datetime_coerce
NULL

#' @rdname ifc_datetime_coerce
#' @export
as.POSIXct.ifc_datetime <- function(x, tz = NULL, ...) {
  tz_use <- tz %||% attr(x, "tzone") %||% "UTC"
  if (identical(tz_use, "")) tz_use <- "UTC"
  structure(vec_data(x), class = c("POSIXct", "POSIXt"), tzone = tz_use)
}

#' @rdname ifc_datetime_coerce
#' @export
as.POSIXlt.ifc_datetime <- function(x, tz = NULL, ...) {
  as.POSIXlt(as.POSIXct(x, tz = tz))
}

#' @rdname ifc_datetime_coerce
#' @export
as.Date.ifc_datetime <- function(x, tz = NULL, ...) {
  tz_use <- tz %||% attr(x, "tzone") %||% "UTC"
  if (identical(tz_use, "")) tz_use <- "UTC"
  as.Date(as.POSIXct(x, tz = tz_use), tz = tz_use)
}

#' @rdname ifc_datetime_coerce
#' @export
as.character.ifc_datetime <- function(x, ...) {
  format(x, ...)
}

#' @rdname ifc_datetime_coerce
#' @export
as.double.ifc_datetime <- function(x, ...) {
  vec_data(x)
}

# ---- pillar / tibble integration ---------------------------------------------

#' @export
type_sum.ifc_datetime <- function(x) {
  "ifcdt"
}

#' @export
pillar_shaft.ifc_datetime <- function(x, ...) {
  d  <- .ifc_decompose_dt(x)
  n  <- length(x)
  tz <- d$tzone

  yr4 <- formatC(d$year, width = 4, flag = "0", mode = "integer")
  mo  <- ifelse(is.na(d$month), "", IFC_MONTH_ABBR[d$month])
  mo[d$is_year_day] <- "Year Day"
  mo[d$is_leap_day] <- "Leap Day"
  dy  <- fmt_int(d$day, 2)
  hr  <- formatC(d$hour,   width = 2, flag = "0", mode = "integer")
  mn  <- formatC(d$minute, width = 2, flag = "0", mode = "integer")
  sc  <- formatC(as.integer(d$second), width = 2, flag = "0", mode = "integer")

  raw <- vec_data(x)
  pt  <- structure(raw, class = c("POSIXct", "POSIXt"), tzone = tz)
  tz_abbr <- format(pt, "%Z")

  time_str <- paste0(hr, ":", mn, ":", sc)

  out <- character(n)
  reg <- !d$is_year_day & !d$is_leap_day
  if (any(reg)) {
    out[reg] <- paste(yr4[reg], mo[reg], dy[reg], time_str[reg], tz_abbr[reg])
  }
  if (any(d$is_year_day)) {
    out[d$is_year_day] <- paste(
      yr4[d$is_year_day], "Year Day",
      time_str[d$is_year_day], tz_abbr[d$is_year_day]
    )
  }
  if (any(d$is_leap_day)) {
    out[d$is_leap_day] <- paste(
      yr4[d$is_leap_day], "Leap Day",
      time_str[d$is_leap_day], tz_abbr[d$is_leap_day]
    )
  }

  # "2024 September 28 09:30:00 EDT" = ~30 chars
  new_pillar_shaft_simple(out, align = "right", min_width = 19L)
}
