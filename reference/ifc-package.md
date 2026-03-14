# ifc: International Fixed Calendar Date Class

The `ifc` package implements the International Fixed Calendar as a
proper S3 vector class built on the [vctrs](https://vctrs.r-lib.org/)
framework. The IFC divides each year into 13 months of exactly 28 days,
with a Year Day appended at year's end (and a Leap Day after IFC June 28
in leap years). Because each month always starts on Sunday and ends on
Saturday, the day-of-week for any IFC date is fully deterministic from
the day-of-month number.

## See also

Useful links:

- <https://k5cents.github.io/ifc/>

- <https://github.com/k5cents/ifc>

- Report bugs at <https://github.com/k5cents/ifc/issues>

## Author

**Maintainer**: Kiernan Nicholls <k5cents@gmail.com>
([ORCID](https://orcid.org/0000-0002-9229-7897)) \[copyright holder\]
