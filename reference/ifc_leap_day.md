# Create an IFC Leap Day

Leap Day is the intercalary day inserted after IFC June 28 in leap
years. It is not part of any month or week in the IFC system.

## Usage

``` r
ifc_leap_day(year)
```

## Arguments

- year:

  Integer. A leap year.

## Value

An `ifc_date` vector.

## Examples

``` r
ifc_leap_day(2024)   # = Gregorian 2024-06-17
#> <ifc_date[1]>
#> [1] "2024 Leap Day"
```
