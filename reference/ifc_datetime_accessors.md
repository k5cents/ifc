# Extract time components from an IFC datetime

Extract time components from an IFC datetime

## Usage

``` r
ifc_hour(x)

ifc_minute(x)

ifc_second(x)
```

## Arguments

- x:

  An `ifc_datetime` vector.

## Value

`ifc_hour()`: integer 0–23.

`ifc_minute()`: integer 0–59.

`ifc_second()`: double 0–60 (60 for leap seconds).

## Examples

``` r
x <- ifc_datetime("2024-07-14 09:30:45", tz = "UTC")
ifc_hour(x)
#> [1] 9
ifc_minute(x)
#> [1] 30
ifc_second(x)
#> [1] 45
```
