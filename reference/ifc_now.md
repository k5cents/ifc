# Current date-time in the IFC

A convenience wrapper around `ifc_datetime(Sys.time(), tz = tz)`.

## Usage

``` r
ifc_now(tz = "UTC")
```

## Arguments

- tz:

  Time zone string. Defaults to `"UTC"`.

## Value

An `ifc_datetime` of length 1 representing right now.

## Examples

``` r
ifc_now()
#> <ifc_datetime[1] tz=UTC>
#> [1] "2026-04-17 02:50:03 UTC"
ifc_now("America/New_York")
#> <ifc_datetime[1] tz=America/New_York>
#> [1] "2026-04-16 22:50:03 EDT"
```
