# Package index

## Construct

Create `ifc_date` vectors.

- [`ifc_date()`](https://k5cents.github.io/ifc/reference/ifc_date.md) :
  Convert to an IFC date
- [`ifc_ymd()`](https://k5cents.github.io/ifc/reference/ifc_ymd.md) :
  Create an IFC date from year, month, and day components
- [`ifc_year_day()`](https://k5cents.github.io/ifc/reference/ifc_year_day.md)
  : Create an IFC Year Day
- [`ifc_leap_day()`](https://k5cents.github.io/ifc/reference/ifc_leap_day.md)
  : Create an IFC Leap Day

## Access

Extract components from an `ifc_date`.

- [`ifc_year()`](https://k5cents.github.io/ifc/reference/ifc_accessors.md)
  [`ifc_month()`](https://k5cents.github.io/ifc/reference/ifc_accessors.md)
  [`ifc_day()`](https://k5cents.github.io/ifc/reference/ifc_accessors.md)
  [`ifc_yday()`](https://k5cents.github.io/ifc/reference/ifc_accessors.md)
  [`ifc_wday()`](https://k5cents.github.io/ifc/reference/ifc_accessors.md)
  [`is_year_day()`](https://k5cents.github.io/ifc/reference/ifc_accessors.md)
  [`is_leap_day()`](https://k5cents.github.io/ifc/reference/ifc_accessors.md)
  : Extract components from an IFC date

## Format and coerce

- [`format(`*`<ifc_date>`*`)`](https://k5cents.github.io/ifc/reference/format.ifc_date.md)
  : Format an IFC date as a string
- [`as.Date(`*`<ifc_date>`*`)`](https://k5cents.github.io/ifc/reference/ifc_coerce.md)
  [`as.POSIXct(`*`<ifc_date>`*`)`](https://k5cents.github.io/ifc/reference/ifc_coerce.md)
  [`as.POSIXlt(`*`<ifc_date>`*`)`](https://k5cents.github.io/ifc/reference/ifc_coerce.md)
  [`as.integer(`*`<ifc_date>`*`)`](https://k5cents.github.io/ifc/reference/ifc_coerce.md)
  [`as.double(`*`<ifc_date>`*`)`](https://k5cents.github.io/ifc/reference/ifc_coerce.md)
  [`as.character(`*`<ifc_date>`*`)`](https://k5cents.github.io/ifc/reference/ifc_coerce.md)
  : Coerce an IFC date to a base R date type

## Constants

IFC month and weekday name vectors.

- [`IFC_MONTH_NAMES`](https://k5cents.github.io/ifc/reference/IFC_MONTH_NAMES.md)
  : IFC month names (1–13)
- [`IFC_MONTH_ABBR`](https://k5cents.github.io/ifc/reference/IFC_MONTH_ABBR.md)
  : IFC month abbreviations (1–13)
- [`IFC_WDAY_NAMES`](https://k5cents.github.io/ifc/reference/IFC_WDAY_NAMES.md)
  : IFC weekday names (Sunday = 1, Saturday = 7)
- [`IFC_WDAY_ABBR`](https://k5cents.github.io/ifc/reference/IFC_WDAY_ABBR.md)
  : IFC weekday abbreviations
