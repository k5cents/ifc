.onLoad <- function(libname, pkgname) {
  # ifc_date compat
  vctrs::s3_register("lubridate::year",        "ifc_date")
  vctrs::s3_register("lubridate::month",       "ifc_date")
  vctrs::s3_register("lubridate::mday",        "ifc_date")
  vctrs::s3_register("lubridate::wday",        "ifc_date")
  vctrs::s3_register("lubridate::yday",        "ifc_date")
  vctrs::s3_register("lubridate::as_date",     "ifc_date")
  vctrs::s3_register("lubridate::as_datetime", "ifc_date")
  vctrs::s3_register("lubridate::tz",          "ifc_date")

  # ifc_datetime compat
  vctrs::s3_register("lubridate::year",        "ifc_datetime")
  vctrs::s3_register("lubridate::month",       "ifc_datetime")
  vctrs::s3_register("lubridate::mday",        "ifc_datetime")
  vctrs::s3_register("lubridate::wday",        "ifc_datetime")
  vctrs::s3_register("lubridate::yday",        "ifc_datetime")
  vctrs::s3_register("lubridate::as_date",     "ifc_datetime")
  vctrs::s3_register("lubridate::tz",          "ifc_datetime")
  vctrs::s3_register("lubridate::with_tz",     "ifc_datetime")
  vctrs::s3_register("lubridate::force_tz",    "ifc_datetime")
}
