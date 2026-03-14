#' ifc: International Fixed Calendar Date Class
#'
#' The `ifc` package implements the International Fixed Calendar as a proper
#' S3 vector class built on the [vctrs](https://vctrs.r-lib.org/) framework. The IFC divides each year
#' into 13 months of exactly 28 days, with a Year Day appended at year's end
#' (and a Leap Day after IFC June 28 in leap years). Because each month always
#' starts on Sunday and ends on Saturday, the day-of-week for any IFC date
#' is fully deterministic from the day-of-month number.
#'
#' @keywords internal
"_PACKAGE"

## usethis namespace: start
#' @importFrom cli cli_abort cli_warn
#' @importFrom pillar pillar_shaft new_pillar_shaft_simple type_sum
#' @importFrom rlang caller_env
#' @importFrom vctrs vec_arith vec_arith_base vec_arith.numeric vec_cast
#'   vec_data new_vctr vec_ptype2 vec_ptype2.Date vec_ptype_abbr vec_ptype_full
#'   vec_assert vec_recycle_common stop_incompatible_op
## usethis namespace: end
NULL
