# Convert to an IFC date

Convert a `Date`, `POSIXct`, `POSIXlt`, or `character` (ISO 8601) to an
`ifc_date` object.

## Usage

``` r
ifc_date(x)
```

## Arguments

- x:

  A date-like object: `Date`, `POSIXct`, `POSIXlt`, `character` (parsed
  as ISO 8601), or an existing `ifc_date`. Numeric values are treated as
  epoch days (days since 1970-01-01), matching base R's `Date`.

## Value

An `ifc_date` vector.

## Examples

``` r
ifc_date(Sys.Date())
#> <ifc_date[1]>
#> [1] "2026-03-25"
ifc_date("2024-06-18")  # IFC Sol 1 in 2024
#> <ifc_date[1]>
#> [1] "2024-07-01"
```
