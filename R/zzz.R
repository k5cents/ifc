.onLoad <- function(libname, pkgname) {
  vctrs::s3_register("lubridate::year",    "ifc_date")
  vctrs::s3_register("lubridate::month",   "ifc_date")
  vctrs::s3_register("lubridate::mday",    "ifc_date")
  vctrs::s3_register("lubridate::wday",    "ifc_date")
  vctrs::s3_register("lubridate::yday",    "ifc_date")
  vctrs::s3_register("lubridate::as_date", "ifc_date")
  vctrs::s3_register("lubridate::tz",      "ifc_date")
}
