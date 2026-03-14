# Create an IFC date from year, month, and day components

Construct an `ifc_date` from IFC calendar year, month (1–13), and day
(1–28). Arguments are recycled to a common length.

## Usage

``` r
ifc_ymd(year, month, day)
```

## Arguments

- year:

  Integer. Calendar year (same as Gregorian year).

- month:

  Integer 1–13. IFC month number (7 = Sol, 8 = July, ..., 13 =
  December).

- day:

  Integer 1–28. Day of the IFC month.

## Value

An `ifc_date` vector.

## Examples

``` r
ifc_ymd(2024, 7, 1)   # IFC Sol 1, 2024 (= Gregorian 2024-06-18)
#> <ifc_date[1]>
#> [1] "2024-07-01"
ifc_ymd(2024, 1, 1)   # IFC January 1, 2024 (= Gregorian 2024-01-01)
#> <ifc_date[1]>
#> [1] "2024-01-01"
```
