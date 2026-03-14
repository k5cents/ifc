# ifc (development)

* `ifc_date()` now correctly errors on unparseable character strings such as
  `ifc_date("not-a-date")`. Previously, invalid strings silently produced an
  `ifc_date` wrapping `NA` because `as.Date()` returns `NA` with a warning
  rather than throwing an error.

* `format.ifc_date()` now correctly replaces all occurrences of a token when
  the same token appears more than once in the format string (e.g.
  `format(x, "%Y/%Y")` now returns `"2024/2024"`). Previously only the first
  occurrence was replaced.

* Accessor functions (`ifc_year()`, `ifc_month()`, etc.) now produce a proper
  vctrs type error when passed a non-`ifc_date` object instead of the opaque
  `stopifnot` message.

# ifc 0.1.0

* Initial release.
* `ifc_date()` converts `Date`, `POSIXct`, and `character` to `ifc_date`.
* `ifc_ymd()` constructs from IFC year, month (1–13), and day (1–28).
* `ifc_year_day()` and `ifc_leap_day()` create the two intercalary days.
* Accessors: `ifc_year()`, `ifc_month()`, `ifc_day()`, `ifc_yday()`,
  `ifc_wday()`, `is_year_day()`, `is_leap_day()`.
* `format.ifc_date()` supports strftime-style tokens including `%B` → month
  name (e.g. `"Sol"`) and deterministic `%a`/`%A` weekday tokens.
* Full vctrs and pillar integration for use in tibble columns.
