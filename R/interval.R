# ifc_interval — span between two ifc_date values
#
# Stores start and end as parallel ifc_date vectors (recycled to common length).
# Division by a unit string returns the span in that unit:
#   iv / "day"   -> integer days
#   iv / "week"  -> days / 7
#   iv / "month" -> days / 28

# Low-level constructor — start and end must be validated ifc_date vectors of
# the same length.
new_ifc_interval <- function(start, end) {
  structure(list(start = start, end = end), class = "ifc_interval")
}

#' Create an interval between two IFC dates
#'
#' `ifc_interval()` records the span between a `start` and `end` `ifc_date`.
#' Dividing by a unit string returns the number of complete or fractional units
#' in the span.
#'
#' IFC's fixed-length units (7 days/week, 28 days/month) mean that spans
#' between regular IFC dates divide exactly with no fractional remainder —
#' an advantage over Gregorian intervals where month lengths vary.
#'
#' @param start,end `ifc_date` vectors (or anything coercible to `ifc_date`).
#'   Recycled to a common length.
#'
#' @return An `ifc_interval` object.
#' @export
#' @examples
#' iv <- ifc_interval(ifc_ymd(2024, 1, 1), ifc_ymd(2024, 7, 1))
#' iv / "day"    # integer days between the two dates
#' iv / "week"   # days / 7
#' iv / "month"  # days / 28
ifc_interval <- function(start, end) {
  start <- vec_cast(start, new_ifc_date())
  end   <- vec_cast(end,   new_ifc_date())
  args  <- vec_recycle_common(start = start, end = end)
  new_ifc_interval(args$start, args$end)
}

#' @export
format.ifc_interval <- function(x, ...) {
  days <- as.integer(x$end) - as.integer(x$start)
  paste0(format(x$start), " -- ", format(x$end), " [", days, " day",
         ifelse(days == 1L, "", "s"), "]")
}

#' @export
print.ifc_interval <- function(x, ...) {
  cat(format(x, ...), sep = "\n")
  invisible(x)
}

#' Divide an IFC interval by a time unit
#'
#' @param e1 An `ifc_interval`.
#' @param e2 A string: `"day"`, `"week"`, or `"month"`.
#' @return A numeric vector of the span expressed in the given unit.
#' @export
#' @method / ifc_interval
`/.ifc_interval` <- function(e1, e2) {
  days <- as.integer(e1$end) - as.integer(e1$start)
  switch(
    e2,
    day   = days,
    week  = days / 7,
    month = days / 28,
    cli_abort(
      "Unknown unit {.val {e2}}. Must be one of {.val day}, {.val week}, or {.val month}."
    )
  )
}
