# pillar / tibble integration for ifc_date

#' @importFrom pillar pillar_shaft new_pillar_shaft_simple type_sum
NULL

#' @export
type_sum.ifc_date <- function(x) {
  "ifc"
}

#' @export
pillar_shaft.ifc_date <- function(x, ...) {
  d  <- ifc_decompose(x)
  n  <- length(x)

  yr4 <- formatC(d$year, width = 4, flag = "0", mode = "integer")
  mo  <- ifelse(is.na(d$month), "", IFC_MONTH_ABBR[d$month])
  dy  <- fmt_int(d$day, 2)

  # Build display strings
  out <- character(n)

  # Regular days: "2024 Sol 14"
  reg <- !d$is_year_day & !d$is_leap_day
  if (any(reg)) {
    out[reg] <- paste(yr4[reg], mo[reg], dy[reg])
  }

  # Special days
  if (any(d$is_year_day)) {
    out[d$is_year_day] <- paste(yr4[d$is_year_day], "Year Day")
  }
  if (any(d$is_leap_day)) {
    out[d$is_leap_day] <- paste(yr4[d$is_leap_day], "Leap Day")
  }

  # Width: "2024 September 28" = 18 chars (longest regular)
  # "2024 Year Day" = 13 chars
  new_pillar_shaft_simple(out, align = "right", min_width = 11L)
}
