# Type coercion: vec_cast methods + base R as.* generics
#
# vec_cast.ifc_date(x, to) is the dispatcher for "cast x TO ifc_date".
# It dispatches on class(x) using UseMethod, so:
#   vec_cast.ifc_date.Date      handles: cast Date -> ifc_date
#   vec_cast.ifc_date.character handles: cast character -> ifc_date
#
# For casting FROM ifc_date TO other types, implement as.X.ifc_date() methods.
# vctrs will use those automatically in its cast fallback.

# ---- vec_cast ----------------------------------------------------------------

#' @export
#' @method vec_cast ifc_date
vec_cast.ifc_date <- function(x, to, ...) UseMethod("vec_cast.ifc_date")

# ifc_date -> ifc_date
#' @export
#' @method vec_cast.ifc_date ifc_date
vec_cast.ifc_date.ifc_date <- function(x, to, ...) x

# Date -> ifc_date
#' @export
#' @method vec_cast.ifc_date Date
vec_cast.ifc_date.Date <- function(x, to, ...) {
  ifc_date(x)
}

# character -> ifc_date
#' @export
#' @method vec_cast.ifc_date character
vec_cast.ifc_date.character <- function(x, to, ...) {
  ifc_date(x)
}

# double -> ifc_date (treat as epoch days)
#' @export
#' @method vec_cast.ifc_date double
vec_cast.ifc_date.double <- function(x, to, ...) {
  new_ifc_date(as.integer(x))
}

# integer -> ifc_date (treat as epoch days)
#' @export
#' @method vec_cast.ifc_date integer
vec_cast.ifc_date.integer <- function(x, to, ...) {
  new_ifc_date(x)
}

# ---- Base R coercion methods -------------------------------------------------
# These handle casting FROM ifc_date TO base types.
# vctrs uses as.X() internally when vec_cast can't find a registered method.

#' Coerce an IFC date to a base R date type
#'
#' @param x An `ifc_date` vector.
#' @param tz Time zone string passed to `as.POSIXct` / `as.POSIXlt`.
#' @param ... Ignored.
#' @return The corresponding base R type.
#' @name ifc_coerce
NULL

#' @rdname ifc_coerce
#' @export
as.Date.ifc_date <- function(x, ...) {
  structure(as.double(vec_data(x)), class = "Date")
}

#' @rdname ifc_coerce
#' @export
as.POSIXct.ifc_date <- function(x, tz = "UTC", ...) {
  as.POSIXct(as.Date(x), tz = tz, ...)
}

#' @rdname ifc_coerce
#' @export
as.POSIXlt.ifc_date <- function(x, tz = "UTC", ...) {
  as.POSIXlt(as.Date(x), tz = tz, ...)
}

#' @rdname ifc_coerce
#' @export
as.integer.ifc_date <- function(x, ...) {
  vec_data(x)
}

#' @rdname ifc_coerce
#' @export
as.double.ifc_date <- function(x, ...) {
  as.double(vec_data(x))
}

#' @rdname ifc_coerce
#' @export
as.character.ifc_date <- function(x, ...) {
  format(x, ...)
}
