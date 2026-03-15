# Format an IFC datetime as a string

Converts an `ifc_datetime` to a character vector using a format string
with IFC-aware tokens. Supports all tokens from
[`format.ifc_date()`](https://k5cents.github.io/ifc/reference/format.ifc_date.md)
plus:

## Usage

``` r
# S3 method for class 'ifc_datetime'
format(x, format = "%Y-%m-%d %H:%M:%S %Z", ...)
```

## Arguments

- x:

  An `ifc_datetime` vector.

- format:

  Character string of format tokens. Default: `"%Y-%m-%d %H:%M:%S %Z"`.

- ...:

  Ignored; included for S3 consistency.

## Value

Character vector the same length as `x`.

## Details

|       |                                      |
|-------|--------------------------------------|
| Token | Meaning                              |
| `%H`  | Hour 00–23                           |
| `%M`  | Minute 00–59                         |
| `%S`  | Second 00–60 (zero-padded)           |
| `%Z`  | Timezone abbreviation (e.g. `"EDT"`) |
| `%z`  | UTC offset (e.g. `"+0000"`)          |

For Year Day and Leap Day, `%B` and `%b` produce `"Year Day"` or
`"Leap Day"` respectively; `%m`, `%d`, `%u`, `%a`, `%A` produce empty
strings. Time tokens are always applied normally.

## Examples

``` r
x <- ifc_datetime("2024-07-14 09:30:00", tz = "UTC")
format(x)                       # "2024-07-14 09:30:00 UTC"
#> [1] "2024-07-27 09:30:00 UTC"
format(x, "%Y %B %d %H:%M:%S") # "2024 Sol 14 09:30:00"
#> [1] "2024 Sol 27 09:30:00"
```
