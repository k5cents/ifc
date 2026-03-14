# vctrs class infrastructure for ifc_date

# Low-level constructor — x must be a validated integer vector of epoch days.
# Not exported; user-facing constructors are in constructors.R.
new_ifc_date <- function(x = integer()) {
  vec_assert(x, integer())
  new_vctr(x, class = "ifc_date")
}

# ---- vctrs type abbreviations ----

#' @export
vec_ptype_abbr.ifc_date <- function(x, ...) "ifc"

#' @export
vec_ptype_full.ifc_date <- function(x, ...) "ifc_date"

# ---- vctrs type hierarchy (vec_ptype2) ----
#
# roxygen @method tag: "@method <generic> <class>"
#   vec_ptype2.ifc_date is the outer dispatcher: generic=vec_ptype2, class=ifc_date
#   vec_ptype2.ifc_date.ifc_date: generic=vec_ptype2.ifc_date, class=ifc_date
#   vec_ptype2.Date.ifc_date: generic=vec_ptype2.Date, class=ifc_date

#' @export
#' @method vec_ptype2 ifc_date
vec_ptype2.ifc_date <- function(x, y, ...) UseMethod("vec_ptype2.ifc_date")

#' @export
#' @method vec_ptype2.ifc_date ifc_date
vec_ptype2.ifc_date.ifc_date <- function(x, y, ...) new_ifc_date()

#' @export
#' @method vec_ptype2.ifc_date Date
vec_ptype2.ifc_date.Date <- function(x, y, ...) new_ifc_date()

#' @export
#' @method vec_ptype2.Date ifc_date
vec_ptype2.Date.ifc_date <- function(x, y, ...) new_ifc_date()
