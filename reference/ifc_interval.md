# Create an interval between two IFC dates

`ifc_interval()` records the span between a `start` and `end`
`ifc_date`. Dividing by a unit string returns the number of complete or
fractional units in the span.

## Usage

``` r
ifc_interval(start, end)
```

## Arguments

- start, end:

  `ifc_date` vectors (or anything coercible to `ifc_date`). Recycled to
  a common length.

## Value

An `ifc_interval` object.

## Details

IFC's fixed-length units (7 days/week, 28 days/month) mean that spans
between regular IFC dates divide exactly with no fractional remainder —
an advantage over Gregorian intervals where month lengths vary.

## Examples

``` r
iv <- ifc_interval(ifc_ymd(2024, 1, 1), ifc_ymd(2024, 7, 1))
iv / "day"    # integer days between the two dates
#> [1] 169
iv / "week"   # days / 7
#> [1] 24.14286
iv / "month"  # days / 28
#> [1] 6.035714
```
