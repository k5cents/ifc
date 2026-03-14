# Changelog

## ifc 0.1.0

- Initial release.
- [`ifc_date()`](https://k5cents.github.io/ifc/reference/ifc_date.md)
  converts `Date`, `POSIXct`, and `character` to `ifc_date`.
- [`ifc_ymd()`](https://k5cents.github.io/ifc/reference/ifc_ymd.md)
  constructs from IFC year, month (1–13), and day (1–28).
- [`ifc_year_day()`](https://k5cents.github.io/ifc/reference/ifc_year_day.md)
  and
  [`ifc_leap_day()`](https://k5cents.github.io/ifc/reference/ifc_leap_day.md)
  create the two intercalary days.
- Accessors:
  [`ifc_year()`](https://k5cents.github.io/ifc/reference/ifc_accessors.md),
  [`ifc_month()`](https://k5cents.github.io/ifc/reference/ifc_accessors.md),
  [`ifc_day()`](https://k5cents.github.io/ifc/reference/ifc_accessors.md),
  [`ifc_yday()`](https://k5cents.github.io/ifc/reference/ifc_accessors.md),
  [`ifc_wday()`](https://k5cents.github.io/ifc/reference/ifc_accessors.md),
  [`is_year_day()`](https://k5cents.github.io/ifc/reference/ifc_accessors.md),
  [`is_leap_day()`](https://k5cents.github.io/ifc/reference/ifc_accessors.md).
- [`format.ifc_date()`](https://k5cents.github.io/ifc/reference/format.ifc_date.md)
  supports strftime-style tokens including `%B` → month name
  (e.g. `"Sol"`) and deterministic `%a`/`%A` weekday tokens.
- Full vctrs and pillar integration for use in tibble columns.
