#' Parse IFC date strings
#'
#' Converts character strings to `ifc_date` objects using a format string with
#' IFC-aware tokens. The default format `"%Y-%m-%d"` matches the output of
#' [format.ifc_date()], making `format(x) |> ifc_parse(x)` an exact round-trip
#' for all `ifc_date` values.
#'
#' Intercalary days are always recognised by their canonical strings
#' (`"YYYY Year Day"` and `"YYYY Leap Day"`) regardless of `format`.
#'
#' Supported tokens (same set as [format.ifc_date()]):
#'
#' | Token | Meaning |
#' |-------|---------|
#' | `%Y`  | 4-digit year |
#' | `%y`  | 2-digit year (interpreted as 2000-2099) |
#' | `%m`  | Month number 1-13 |
#' | `%d`  | Day 1-28 |
#' | `%B`  | Full month name (e.g. `"Sol"`) |
#' | `%b`  | Abbreviated month name (e.g. `"Sol"`) |
#' | `%j`  | Day of year 1-366 |
#' | `%%`  | Literal `%` |
#'
#' @param x Character vector of IFC date strings.
#' @param format Format string. Default: `"%Y-%m-%d"`.
#'
#' @return An `ifc_date` vector the same length as `x`.
#' @export
#' @examples
#' ifc_parse("2024-07-14")                    # IFC Sol 14, 2024
#' ifc_parse("Sol 14, 2024", "%B %d, %Y")
#' ifc_parse("2024 Year Day")
#' ifc_parse("2024 Leap Day")
#' # round-trip
#' x <- ifc_ymd(2024, 7, 14)
#' identical(ifc_parse(format(x)), x)
ifc_parse <- function(x, format = "%Y-%m-%d") {
  if (!is.character(x)) {
    cli_abort("{.arg x} must be a character vector, not {.cls {class(x)}}.")
  }
  if (length(x) == 0L) return(new_ifc_date(integer(0L)))

  n   <- length(x)
  out <- integer(n)

  # --- intercalary days (detected before format parsing) --------------------
  yd_re <- "^([0-9]{4}) Year Day$"
  ld_re <- "^([0-9]{4}) Leap Day$"

  is_yd <- grepl(yd_re, x, perl = TRUE)
  is_ld <- grepl(ld_re, x, perl = TRUE)

  if (any(is_yd)) {
    yr <- as.integer(sub(yd_re, "\\1", x[is_yd], perl = TRUE))
    out[is_yd] <- doy_to_epoch(yr, 365L + as.integer(is_leap_year(yr)))
  }

  if (any(is_ld)) {
    yr  <- as.integer(sub(ld_re, "\\1", x[is_ld], perl = TRUE))
    bad <- !is_leap_year(yr)
    if (any(bad)) {
      cli_abort(
        "{.val {yr[bad]}} is not a leap year; {.str Leap Day} does not exist.",
        call = caller_env()
      )
    }
    out[is_ld] <- doy_to_epoch(yr, 169L)
  }

  # --- regular dates --------------------------------------------------------
  reg_idx <- which(!is_yd & !is_ld)
  if (length(reg_idx) == 0L) return(new_ifc_date(out))

  reg_x   <- x[reg_idx]
  fmt_obj <- .ifc_fmt_to_regex(format)
  pat     <- fmt_obj$pattern
  fields  <- fmt_obj$fields

  m <- regmatches(reg_x, regexec(pat, reg_x, perl = TRUE))

  failed <- vapply(m, length, integer(1L)) == 0L
  if (any(failed)) {
    cli_abort(
      "Cannot parse {.val {reg_x[failed]}} with format {.val {format}}.",
      call = caller_env()
    )
  }

  year  <- rep(NA_integer_, length(reg_idx))
  month <- rep(NA_integer_, length(reg_idx))
  day   <- rep(NA_integer_, length(reg_idx))
  doy   <- rep(NA_integer_, length(reg_idx))

  for (i in seq_along(reg_idx)) {
    caps <- m[[i]][-1L]   # drop full-match; keep capture groups
    for (fi in seq_along(fields)) {
      fld <- fields[[fi]]
      val <- caps[[fi]]
      if (fld == "Y") {
        year[[i]]  <- as.integer(val)
      } else if (fld == "y") {
        year[[i]]  <- 2000L + as.integer(val)
      } else if (fld == "m") {
        month[[i]] <- as.integer(val)
      } else if (fld == "d") {
        day[[i]]   <- as.integer(val)
      } else if (fld == "j") {
        doy[[i]]   <- as.integer(val)
      } else if (fld == "B") {
        month[[i]] <- match(val, IFC_MONTH_NAMES)
      } else if (fld == "b") {
        month[[i]] <- match(val, IFC_MONTH_ABBR)
      }
    }
  }

  if (anyNA(year)) {
    cli_abort(
      "Format {.val {format}} must contain a year token ({.code %Y} or {.code %y}).",
      call = caller_env()
    )
  }

  if (!anyNA(month) && !anyNA(day)) {
    bad_mo <- month < 1L | month > 13L
    bad_dy <- day   < 1L | day   > 28L
    if (any(bad_mo)) {
      cli_abort("IFC month {.val {month[bad_mo]}} is out of range (1-13).", call = caller_env())
    }
    if (any(bad_dy)) {
      cli_abort("IFC day {.val {day[bad_dy]}} is out of range (1-28).", call = caller_env())
    }
    reg_doy <- ifc_to_doy(year, month, day, is_year_day = FALSE, is_leap_day = FALSE)
    out[reg_idx] <- doy_to_epoch(year, reg_doy)
  } else if (!anyNA(doy)) {
    out[reg_idx] <- doy_to_epoch(year, doy)
  } else {
    cli_abort(
      "Format {.val {format}} must include either {{%m + %d}} or {{%j}} tokens.",
      call = caller_env()
    )
  }

  new_ifc_date(out)
}

# Build a regex pattern from an IFC format string.
# Returns list(pattern = "^...$", fields = character vector of field codes).
.ifc_fmt_to_regex <- function(fmt) {
  chars  <- strsplit(fmt, "", fixed = TRUE)[[1L]]
  nc     <- length(chars)
  parts  <- character(0L)
  fields <- character(0L)
  i      <- 1L

  month_name_pat <- paste(IFC_MONTH_NAMES, collapse = "|")
  month_abbr_pat <- paste(IFC_MONTH_ABBR,  collapse = "|")

  while (i <= nc) {
    if (chars[[i]] == "%" && i < nc) {
      tok <- chars[[i + 1L]]
      i   <- i + 2L
      if (tok == "%") {
        parts <- c(parts, "%")
      } else if (tok == "Y") {
        parts  <- c(parts, "([0-9]{4})")
        fields <- c(fields, "Y")
      } else if (tok == "y") {
        parts  <- c(parts, "([0-9]{2})")
        fields <- c(fields, "y")
      } else if (tok == "m") {
        parts  <- c(parts, "([0-9]{1,2})")
        fields <- c(fields, "m")
      } else if (tok == "d") {
        parts  <- c(parts, "([0-9]{1,2})")
        fields <- c(fields, "d")
      } else if (tok == "j") {
        parts  <- c(parts, "([0-9]{1,3})")
        fields <- c(fields, "j")
      } else if (tok == "B") {
        parts  <- c(parts, paste0("(", month_name_pat, ")"))
        fields <- c(fields, "B")
      } else if (tok == "b") {
        parts  <- c(parts, paste0("(", month_abbr_pat, ")"))
        fields <- c(fields, "b")
      } else {
        # Unknown token — treat as literal characters
        parts <- c(parts, .regex_escape("%"), .regex_escape(tok))
      }
    } else {
      parts <- c(parts, .regex_escape(chars[[i]]))
      i     <- i + 1L
    }
  }

  list(
    pattern = paste0("^", paste(parts, collapse = ""), "$"),
    fields  = fields
  )
}

# Escape a single character for use as a regex literal.
.regex_escape <- function(ch) {
  gsub("([.+*?^${}|()\\[\\]\\\\])", "\\\\\\1", ch, perl = TRUE)
}
