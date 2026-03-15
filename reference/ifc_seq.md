# Generate a sequence of IFC dates

Creates a regular sequence of `ifc_date` values using IFC-native units.

## Usage

``` r
ifc_seq(from, to = NULL, by, length.out = NULL)
```

## Arguments

- from:

  An `ifc_date` of length 1. The start of the sequence.

- to:

  An `ifc_date` of length 1, or `NULL`. The inclusive end of the
  sequence (reached exactly when evenly divisible; otherwise the
  sequence stops before overshooting).

- by:

  A string: one of `"day"`, `"week"`, `"month"`, or `"year"`.

- length.out:

  A positive integer giving the desired sequence length, or `NULL`.

## Value

An `ifc_date` vector.

## Details

`by = "day"` and `by = "week"` use fixed epoch offsets (1 and 7 days).
`by = "month"` uses **calendar arithmetic**: the result preserves the
same IFC day-of-month, advancing one month at a time and wrapping across
year boundaries (month 13 wraps to month 1 of the next year). This
correctly skips Leap Day when crossing the June/Sol boundary in a leap
year. `by = "year"` similarly preserves IFC month and day, incrementing
only the year.

Exactly one of `to` or `length.out` must be supplied. Direction
(ascending or descending) is inferred from `from` and `to`
automatically.

Year Day and Leap Day are included in sequences whenever the arithmetic
naturally lands on them (e.g. stepping by `"day"` across year-end will
pass through Year Day).

## Examples

``` r
# First day of all 13 months in 2024
ifc_seq(ifc_ymd(2024, 1, 1), by = "month", length.out = 13)
#> <ifc_date[13]>
#>  [1] "2024-01-01" "2024-02-01" "2024-03-01" "2024-04-01" "2024-05-01"
#>  [6] "2024-06-01" "2024-07-01" "2024-08-01" "2024-09-01" "2024-10-01"
#> [11] "2024-11-01" "2024-12-01" "2024-13-01"

# Weekly sequence between two dates
ifc_seq(ifc_ymd(2024, 1, 1), ifc_ymd(2024, 4, 1), by = "week")
#> <ifc_date[13]>
#>  [1] "2024-01-01" "2024-01-08" "2024-01-15" "2024-01-22" "2024-02-01"
#>  [6] "2024-02-08" "2024-02-15" "2024-02-22" "2024-03-01" "2024-03-08"
#> [11] "2024-03-15" "2024-03-22" "2024-04-01"

# Jan 1 for six consecutive years
ifc_seq(ifc_ymd(2020, 1, 1), ifc_ymd(2025, 1, 1), by = "year")
#> <ifc_date[6]>
#> [1] "2020-01-01" "2021-01-01" "2022-01-01" "2023-01-01" "2024-01-01"
#> [6] "2025-01-01"
```
