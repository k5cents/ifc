# Add IFC calendar units to a date

Add a whole number of weeks, months, or years to an `ifc_date` vector
using IFC calendar arithmetic. Both `x` and `n` are recycled to a common
length.

## Usage

``` r
add_weeks(x, n)

add_months(x, n)

add_years(x, n)
```

## Arguments

- x:

  An `ifc_date` vector.

- n:

  Integer number of units to add (may be negative).

## Value

An `ifc_date` vector.

## Details

- `add_weeks(x, n)`: adds `n * 7L` days (always exact).

- `add_months(x, n)`: calendar arithmetic — preserves the IFC
  day-of-month and advances the month by `n`, wrapping across year
  boundaries. This correctly handles the June/Sol boundary in leap
  years.

- `add_years(x, n)`: calendar arithmetic — preserves the IFC month and
  day, advancing the year by `n`. For Leap Day inputs, the result is the
  Leap Day of the target year; a non-leap target year produces an error.

Negative `n` moves backwards.

## Examples

``` r
add_weeks(ifc_ymd(2024, 1, 1), 4)    # Feb 1, 2024 (+28 days)
#> <ifc_date[1]>
#> [1] "2024-02-01"
add_months(ifc_ymd(2024, 1, 1), 6)   # Sol 1, 2024 (skips Leap Day)
#> <ifc_date[1]>
#> [1] "2024-07-01"
add_months(ifc_ymd(2024, 13, 1), 1)  # Jan 1, 2025 (wraps to next year)
#> <ifc_date[1]>
#> [1] "2025-01-01"
add_years(ifc_ymd(2024, 7, 1), 1)    # Sol 1, 2025
#> <ifc_date[1]>
#> [1] "2025-07-01"
add_years(ifc_ymd(2024, 7, 1), -1)   # Sol 1, 2023
#> <ifc_date[1]>
#> [1] "2023-07-01"
```
