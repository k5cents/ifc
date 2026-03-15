# Package index

## IFC dates

Construct and work with `ifc_date` vectors.

- [`ifc_date()`](https://k5cents.github.io/ifc/reference/ifc_date.md) :
  Convert to an IFC date
- [`ifc_ymd()`](https://k5cents.github.io/ifc/reference/ifc_ymd.md) :
  Create an IFC date from year, month, and day components
- [`ifc_year_day()`](https://k5cents.github.io/ifc/reference/ifc_year_day.md)
  : Create an IFC Year Day
- [`ifc_leap_day()`](https://k5cents.github.io/ifc/reference/ifc_leap_day.md)
  : Create an IFC Leap Day
- [`ifc_today()`](https://k5cents.github.io/ifc/reference/ifc_today.md)
  : Today's date in the IFC
- [`ifc_year()`](https://k5cents.github.io/ifc/reference/ifc_accessors.md)
  [`ifc_month()`](https://k5cents.github.io/ifc/reference/ifc_accessors.md)
  [`ifc_day()`](https://k5cents.github.io/ifc/reference/ifc_accessors.md)
  [`ifc_yday()`](https://k5cents.github.io/ifc/reference/ifc_accessors.md)
  [`ifc_wday()`](https://k5cents.github.io/ifc/reference/ifc_accessors.md)
  [`ifc_week()`](https://k5cents.github.io/ifc/reference/ifc_accessors.md)
  [`is_year_day()`](https://k5cents.github.io/ifc/reference/ifc_accessors.md)
  [`is_leap_day()`](https://k5cents.github.io/ifc/reference/ifc_accessors.md)
  : Extract components from an IFC date
- [`format(`*`<ifc_date>`*`)`](https://k5cents.github.io/ifc/reference/format.ifc_date.md)
  : Format an IFC date as a string
- [`as.Date(`*`<ifc_date>`*`)`](https://k5cents.github.io/ifc/reference/ifc_coerce.md)
  [`as.POSIXct(`*`<ifc_date>`*`)`](https://k5cents.github.io/ifc/reference/ifc_coerce.md)
  [`as.POSIXlt(`*`<ifc_date>`*`)`](https://k5cents.github.io/ifc/reference/ifc_coerce.md)
  [`as.integer(`*`<ifc_date>`*`)`](https://k5cents.github.io/ifc/reference/ifc_coerce.md)
  [`as.double(`*`<ifc_date>`*`)`](https://k5cents.github.io/ifc/reference/ifc_coerce.md)
  [`as.character(`*`<ifc_date>`*`)`](https://k5cents.github.io/ifc/reference/ifc_coerce.md)
  : Coerce an IFC date to a base R date type

## IFC datetimes

Construct and work with `ifc_datetime` vectors (date + time + timezone).

- [`ifc_datetime()`](https://k5cents.github.io/ifc/reference/ifc_datetime.md)
  : Convert to an IFC datetime
- [`ifc_now()`](https://k5cents.github.io/ifc/reference/ifc_now.md) :
  Current date-time in the IFC
- [`ifc_hour()`](https://k5cents.github.io/ifc/reference/ifc_datetime_accessors.md)
  [`ifc_minute()`](https://k5cents.github.io/ifc/reference/ifc_datetime_accessors.md)
  [`ifc_second()`](https://k5cents.github.io/ifc/reference/ifc_datetime_accessors.md)
  : Extract time components from an IFC datetime
- [`format(`*`<ifc_datetime>`*`)`](https://k5cents.github.io/ifc/reference/format.ifc_datetime.md)
  : Format an IFC datetime as a string
- [`as.POSIXct(`*`<ifc_datetime>`*`)`](https://k5cents.github.io/ifc/reference/ifc_datetime_coerce.md)
  [`as.POSIXlt(`*`<ifc_datetime>`*`)`](https://k5cents.github.io/ifc/reference/ifc_datetime_coerce.md)
  [`as.Date(`*`<ifc_datetime>`*`)`](https://k5cents.github.io/ifc/reference/ifc_datetime_coerce.md)
  [`as.character(`*`<ifc_datetime>`*`)`](https://k5cents.github.io/ifc/reference/ifc_datetime_coerce.md)
  [`as.double(`*`<ifc_datetime>`*`)`](https://k5cents.github.io/ifc/reference/ifc_datetime_coerce.md)
  : Coerce an IFC datetime to a base R datetime type

## Parse

Parse IFC-formatted strings back to `ifc_date`.

- [`ifc_parse()`](https://k5cents.github.io/ifc/reference/ifc_parse.md)
  : Parse IFC date strings

## Sequences and arithmetic

Generate sequences and perform calendar arithmetic on IFC dates.

- [`ifc_seq()`](https://k5cents.github.io/ifc/reference/ifc_seq.md) :
  Generate a sequence of IFC dates
- [`add_weeks()`](https://k5cents.github.io/ifc/reference/ifc_add.md)
  [`add_months()`](https://k5cents.github.io/ifc/reference/ifc_add.md)
  [`add_years()`](https://k5cents.github.io/ifc/reference/ifc_add.md) :
  Add IFC calendar units to a date

## Rounding

Round IFC dates to the nearest week, month, or year boundary.

- [`ifc_floor()`](https://k5cents.github.io/ifc/reference/ifc_round.md)
  [`ifc_ceiling()`](https://k5cents.github.io/ifc/reference/ifc_round.md)
  [`ifc_round()`](https://k5cents.github.io/ifc/reference/ifc_round.md)
  : Round an IFC date to a unit boundary

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
