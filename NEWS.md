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
