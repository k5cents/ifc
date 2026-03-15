# Round an IFC date to a unit boundary

Round, floor, or ceiling an `ifc_date` to the nearest `"week"`,
`"month"`, or `"year"` boundary. IFC's fixed-length units make these
operations exact: every week is 7 days, every month 28 days.

## Usage

``` r
ifc_floor(x, unit)

ifc_ceiling(x, unit)

ifc_round(x, unit)
```

## Arguments

- x:

  An `ifc_date` vector.

- unit:

  A string: `"week"`, `"month"`, or `"year"`.

## Value

An `ifc_date` vector the same length as `x`.

## Details

Boundary definitions:

- **week**: the Sunday (day 1 of a week) that starts the 7-day period.

- **month**: day 1 of the IFC month.

- **year**: January 1 of the IFC year.

Intercalary day behaviour:

- Year Day and Leap Day always follow a Saturday (day 28 of a month), so
  their week floor is 7 days back (the preceding Sunday) and their month
  floor is 28 days back (day 1 of the preceding month).

- Ceiling always advances to the next regular boundary: Leap Day ceiling
  = Sol 1; Year Day ceiling = January 1 of the following year.

`ifc_round()` picks whichever boundary is closer. Ties (e.g. day 15 for
`"month"`) round toward the floor.

## Examples

``` r
x <- ifc_ymd(2024, 7, 14)
ifc_floor(x, "week")    # Sol 8  (Sunday of the same week)
#> <ifc_date[1]>
#> [1] "2024-07-08"
ifc_floor(x, "month")   # Sol 1
#> <ifc_date[1]>
#> [1] "2024-07-01"
ifc_floor(x, "year")    # Jan 1, 2024
#> <ifc_date[1]>
#> [1] "2024-01-01"
ifc_ceiling(x, "week")  # Sol 15 (next Sunday)
#> <ifc_date[1]>
#> [1] "2024-07-15"
ifc_ceiling(x, "month") # Aug 1  (day 1 of next month)
#> <ifc_date[1]>
#> [1] "2024-08-01"
ifc_ceiling(x, "year")  # Jan 1, 2025
#> <ifc_date[1]>
#> [1] "2025-01-01"
ifc_round(x, "week")    # Sol 15 (day 14 = Saturday, 1 day from Sol 15)
#> <ifc_date[1]>
#> [1] "2024-07-15"
ifc_round(x, "month")   # Sol 1  (day 14 is in the first half; ties go to floor)
#> <ifc_date[1]>
#> [1] "2024-07-01"
ifc_round(x, "year")    # Jan 1, 2024
#> <ifc_date[1]>
#> [1] "2024-01-01"
```
