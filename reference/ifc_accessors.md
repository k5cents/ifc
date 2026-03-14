# Extract components from an IFC date

Extract components from an IFC date

## Usage

``` r
ifc_year(x)

ifc_month(x)

ifc_day(x)

ifc_yday(x)

ifc_wday(x, label = FALSE, abbr = TRUE)

is_year_day(x)

is_leap_day(x)
```

## Arguments

- x:

  An `ifc_date` vector.

- label:

  If `TRUE`, return a character label instead of an integer.

- abbr:

  If `TRUE` (and `label = TRUE`), use abbreviated names.

## Value

`ifc_year()`: integer year (same as Gregorian year).

`ifc_month()`: integer month 1–13, or `NA` for Year Day / Leap Day.

`ifc_day()`: integer day 1–28, or `NA` for Year Day / Leap Day.

`ifc_yday()`: integer day of year 1–366.

`ifc_wday()`: weekday as integer 1 (Sunday) – 7 (Saturday), or `NA` for
Year Day / Leap Day. In the IFC, weekday is fully determined by
`(day - 1) %% 7 + 1`.

`is_year_day()`: logical, `TRUE` if the date is Year Day.

`is_leap_day()`: logical, `TRUE` if the date is Leap Day.

## Examples

``` r
x <- ifc_ymd(2024, 7, 14)
ifc_year(x)
#> [1] 2024
ifc_month(x)  # 7 (Sol)
#> [1] 7
ifc_day(x)  # 14
#> [1] 14
ifc_yday(x)
#> [1] 183
ifc_wday(x)           # 7 (Saturday: day 14 = (14-1)%%7+1 = 7)
#> [1] 7
ifc_wday(x, label = TRUE)   # "Sat"
#> [1] "Sat"
is_year_day(ifc_year_day(2024))  # TRUE
#> [1] TRUE
is_leap_day(ifc_leap_day(2024))  # TRUE
#> [1] TRUE
```
