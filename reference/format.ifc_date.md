# Format an IFC date as a string

Converts an `ifc_date` to a character vector using a format string with
IFC-aware tokens. Supported tokens:

## Usage

``` r
# S3 method for class 'ifc_date'
format(
  x,
  format = "%Y-%m-%d",
  special_fmt = c(year_day = "%Y Year Day", leap_day = "%Y Leap Day"),
  ...
)
```

## Arguments

- x:

  An `ifc_date` vector.

- format:

  Character string of format tokens. Default: `"%Y-%m-%d"`.

- special_fmt:

  Named character vector with entries `"year_day"` and `"leap_day"`
  giving the format used for special days. The only token available in
  `special_fmt` is `%Y`. Default:
  `c(year_day = "%Y Year Day", leap_day = "%Y Leap Day")`.

- ...:

  Ignored; included for S3 consistency.

## Value

Character vector the same length as `x`.

## Details

|       |                                                |
|-------|------------------------------------------------|
| Token | Meaning                                        |
| `%Y`  | 4-digit year                                   |
| `%y`  | 2-digit year (zero-padded)                     |
| `%m`  | Month number 01–13 (or empty for special days) |
| `%d`  | Day 01–28 (or empty for special days)          |
| `%B`  | Full month name (e.g. "Sol")                   |
| `%b`  | Abbreviated month name (e.g. "Sol")            |
| `%j`  | Day of year 001–366                            |
| `%A`  | Full weekday name                              |
| `%a`  | Abbreviated weekday name                       |
| `%u`  | Weekday as integer (1=Sunday, 7=Saturday)      |
| `%%`  | Literal `%`                                    |

For Year Day and Leap Day, month/day/weekday tokens produce an empty
string. Those rows always display their special label using the
`special_fmt` argument.

## Examples

``` r
x <- ifc_ymd(2024, 7, 14)
format(x)                         # "2024-07-14"
#> [1] "2024-07-14"
format(x, "%B %d, %Y")            # "Sol 14, 2024"
#> [1] "Sol 14, 2024"
format(ifc_year_day(2024))        # "2024 Year Day"
#> [1] "2024 Year Day"
```
