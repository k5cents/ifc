# Parse IFC date strings

Converts character strings to `ifc_date` objects using a format string
with IFC-aware tokens. The default format `"%Y-%m-%d"` matches the
output of
[`format.ifc_date()`](https://k5cents.github.io/ifc/reference/format.ifc_date.md),
making `format(x) |> ifc_parse(x)` an exact round-trip for all
`ifc_date` values.

## Usage

``` r
ifc_parse(x, format = "%Y-%m-%d")
```

## Arguments

- x:

  Character vector of IFC date strings.

- format:

  Format string. Default: `"%Y-%m-%d"`.

## Value

An `ifc_date` vector the same length as `x`.

## Details

Intercalary days are always recognised by their canonical strings
(`"YYYY Year Day"` and `"YYYY Leap Day"`) regardless of `format`.

Supported tokens (same set as
[`format.ifc_date()`](https://k5cents.github.io/ifc/reference/format.ifc_date.md)):

|       |                                         |
|-------|-----------------------------------------|
| Token | Meaning                                 |
| `%Y`  | 4-digit year                            |
| `%y`  | 2-digit year (interpreted as 2000-2099) |
| `%m`  | Month number 1-13                       |
| `%d`  | Day 1-28                                |
| `%B`  | Full month name (e.g. `"Sol"`)          |
| `%b`  | Abbreviated month name (e.g. `"Sol"`)   |
| `%j`  | Day of year 1-366                       |
| `%%`  | Literal `%`                             |

## Examples

``` r
ifc_parse("2024-07-14")                    # IFC Sol 14, 2024
#> <ifc_date[1]>
#> [1] "2024-07-14"
ifc_parse("Sol 14, 2024", "%B %d, %Y")
#> <ifc_date[1]>
#> [1] "2024-07-14"
ifc_parse("2024 Year Day")
#> <ifc_date[1]>
#> [1] "2024 Year Day"
ifc_parse("2024 Leap Day")
#> <ifc_date[1]>
#> [1] "2024 Leap Day"
# round-trip
x <- ifc_ymd(2024, 7, 14)
identical(ifc_parse(format(x)), x)
#> [1] TRUE
```
