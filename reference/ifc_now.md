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
#> [1] "2026-03-25 01:56:04 UTC"
ifc_now("America/New_York")
#> <ifc_datetime[1] tz=America/New_York>
#> [1] "2026-03-24 21:56:04 EDT"
```
