# Create an IFC Year Day

Year Day is the intercalary day at the end of each year. It is not part
of any month or week in the IFC system.

## Usage

``` r
ifc_year_day(year)
```

## Arguments

- year:

  Integer. Calendar year.

## Value

An `ifc_date` vector.

## Examples

``` r
ifc_year_day(2024)   # = Gregorian 2024-12-31
#> <ifc_date[1]>
#> [1] "2024 Year Day"
```
