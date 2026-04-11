# ifc (development)

* New `ifc_datetime` class — an IFC-aware datetime backed by POSIXct seconds
  since epoch, with timezone support. Construct via `ifc_datetime(x, tz)` from
  `POSIXct`, `POSIXlt`, `character` (ISO 8601), `ifc_date` (promoted to
  midnight), or numeric epoch seconds. `ifc_now(tz)` returns the current
  instant. New time-component accessors `ifc_hour()`, `ifc_minute()`, and
  `ifc_second()` extract sub-day components. `format.ifc_datetime()` extends
  IFC date tokens with `%H`, `%M`, `%S`, `%Z`, and `%z`; intercalary days
  (`%B` / `%b`) render as `"Year Day"` or `"Leap Day"` while time tokens
  remain fully functional. Includes full tibble/pillar integration
  (`type_sum`, `pillar_shaft`) and coercion to `POSIXct`, `POSIXlt`, `Date`,
  and `character`. lubridate compat methods (`year`, `month`, `mday`, `wday`,
  `yday`, `tz`, `as_date`, `with_tz`, `force_tz`) are registered for
  `ifc_datetime`; `as_datetime.ifc_date` promotes an `ifc_date` to
  `ifc_datetime` at midnight in the specified timezone.

* `ifc_floor()`, `ifc_ceiling()`, and `ifc_round()` round an `ifc_date`
  to the nearest `"week"`, `"month"`, or `"year"` boundary. IFC's fixed-length
  units make these exact: week = 7 days, month = 28 days. Intercalary days
  are handled explicitly: their week floor is the preceding Sunday (7 days
  back), their month floor is day 1 of the preceding month (28 days back), and
  their ceiling always advances to the next regular boundary (Leap Day ->
  Sol 1; Year Day -> Jan 1 of following year). Ties in `ifc_round()` go to
  the floor.

* New `ifc_week()` accessor returns the IFC week-of-year (1–52) for regular
  dates, and `NA` for Year Day / Leap Day. Because every IFC month is exactly
  4 weeks, this is computed directly from month and day:
  `(month - 1) * 4 + ceiling(day / 7)`.

* New calendar arithmetic functions `add_months()`, `add_years()`, and
  `add_weeks()` for adding whole IFC units to a date. `add_months()` and
  `add_years()` use calendar arithmetic (same IFC day-of-month preserved),
  correctly handling the June/Sol boundary in leap years. All three functions
  recycle `x` and `n` to a common length.

* New `ifc_seq(from, to, by, length.out)` generates IFC-native date sequences.
  `by` accepts `"day"`, `"week"`, `"month"`, or `"year"`. Month and year
  stepping use calendar arithmetic (same IFC day-of-month preserved) rather
  than raw day offsets, so the June/Sol boundary in leap years is handled
  correctly. Direction is inferred automatically from `from` and `to`.

* New `ifc_parse(x, format = "%Y-%m-%d")` parses IFC date strings back to
  `ifc_date` objects, completing the round-trip with `format.ifc_date()`.
  Supports the same token set (`%Y`, `%m`, `%d`, `%B`, `%b`, `%j`, `%y`).
  Intercalary days (`"YYYY Year Day"`, `"YYYY Leap Day"`) are always recognised
  by their canonical string form regardless of `format`.

* Added `ifc_today()` as a convenience wrapper for `ifc_date(Sys.Date())`.

* `floor_date.ifc_date()`, `ceiling_date.ifc_date()`, and
  `round_date.ifc_date()` are registered as lubridate compat methods, delegating
  to `ifc_floor()`, `ifc_ceiling()`, and `ifc_round()`. Unit strings follow
  lubridate conventions including plurals (`"weeks"`) and `"N unit"` forms
  (`"2 months"`); sub-day units and `"day"` return the input unchanged.
  **Note:** lubridate >= 1.9 delegates these generics to the **timechange**
  package, which does not use S3 dispatch, so `lubridate::floor_date(x)`
  will not transparently dispatch for `ifc_date` objects under that version.
  Call `ifc_floor()` / `ifc_ceiling()` / `ifc_round()` directly as the
  reliable alternative.

* `ifc_date` now integrates with **lubridate**: `lubridate::year()`,
  `lubridate::month()`, `lubridate::mday()`, `lubridate::wday()`,
  `lubridate::yday()`, and `lubridate::as_date()` all return correct IFC values
  when called on an `ifc_date`. Previously, these functions fell back to
  `as.POSIXlt()` and returned Gregorian month/day values, which are wrong for
  IFC dates (e.g. `lubridate::month()` on an IFC Sol date would return 6 or 7
  depending on the Gregorian month, rather than 7). lubridate is not a hard
  dependency; the methods are registered at load time and only activate if
  lubridate is installed.

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
