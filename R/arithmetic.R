# vctrs arithmetic dispatch for ifc_date
#
# Double-dispatch pattern:
#   vec_arith(op, x, y) dispatches on class(x) → vec_arith.ifc_date()
#   vec_arith.ifc_date() then dispatches on class(y) via UseMethod(..., y)
#
# For numeric + ifc_date, vctrs dispatches to vec_arith.numeric(op, numeric, ifc_date)
# which then dispatches on y=ifc_date via UseMethod("vec_arith.numeric", y).
# vec_arith.integer does NOT exist in vctrs; integer falls through to vec_arith.numeric.

#' @export
#' @method vec_arith ifc_date
vec_arith.ifc_date <- function(op, x, y, ...) {
  UseMethod("vec_arith.ifc_date", y)
}

# ifc_date +/- numeric (covers integer via inheritance)
#' @export
#' @method vec_arith.ifc_date numeric
vec_arith.ifc_date.numeric <- function(op, x, y, ...) {
  switch(
    op,
    "+" = new_ifc_date(vec_arith_base(op, vec_data(x), as.integer(y))),
    "-" = new_ifc_date(vec_arith_base(op, vec_data(x), as.integer(y))),
    stop_incompatible_op(op, x, y, ...)
  )
}

# numeric + ifc_date (vctrs calls vec_arith.numeric, integer inherits from numeric)
#' @export
#' @method vec_arith.numeric ifc_date
vec_arith.numeric.ifc_date <- function(op, x, y, ...) {
  switch(
    op,
    "+" = new_ifc_date(vec_arith_base(op, as.integer(x), vec_data(y))),
    stop_incompatible_op(op, x, y, ...)
  )
}

# ifc_date - ifc_date -> integer (days difference)
#' @export
#' @method vec_arith.ifc_date ifc_date
vec_arith.ifc_date.ifc_date <- function(op, x, y, ...) {
  switch(
    op,
    "-" = vec_arith_base(op, vec_data(x), vec_data(y)),
    stop_incompatible_op(op, x, y, ...)
  )
}

# Unary ops undefined for dates
#' @export
#' @method vec_arith.ifc_date MISSING
vec_arith.ifc_date.MISSING <- function(op, x, y, ...) {
  stop_incompatible_op(op, x, y, ...)
}

# Default fallback
#' @export
#' @method vec_arith.ifc_date default
vec_arith.ifc_date.default <- function(op, x, y, ...) {
  stop_incompatible_op(op, x, y, ...)
}
