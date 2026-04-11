# Convert to an IFC datetime

Convert a `POSIXct`, `POSIXlt`, `character` (ISO 8601 datetime),
`ifc_date`, or numeric (seconds since epoch) to an `ifc_datetime`
object.

## Usage

``` r
ifc_datetime(x, tz = "UTC")
```

## Arguments

- x:

  A datetime-like object.

- tz:

  Time zone string (e.g. `"UTC"`, `"America/New_York"`). For `POSIXct`
  input and `tz` is not supplied, defaults to the timezone already
  stored in `x`. For `ifc_date` input, the datetime is placed at
  midnight in `tz`.

## Value

An `ifc_datetime` vector.

## Examples

``` r
ifc_datetime("2024-07-14 09:30:00", tz = "America/New_York")
#> <ifc_datetime[1] tz=America/New_York>
#> [1] "2024-07-27 09:30:00 EDT"
ifc_datetime(ifc_ymd(2024, 7, 14), tz = "UTC")
#> <ifc_datetime[1] tz=UTC>
#> [1] "2024-07-14 00:00:00 UTC"
ifc_datetime(Sys.time())
#> <ifc_datetime[1] tz=UTC>
#> [1] "2026-04-17 02:56:41 UTC"
```
