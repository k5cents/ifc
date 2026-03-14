<!-- README.md is generated from README.Rmd. Please edit that file -->

# ifc

<!-- badges: start -->
[![Lifecycle: experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN status](https://www.r-pkg.org/badges/version/ifc)](https://CRAN.R-project.org/package=ifc)
[![Codecov test coverage](https://codecov.io/gh/k5cents/ifc/graph/badge.svg)](https://app.codecov.io/gh/k5cents/ifc)
[![R build status](https://github.com/k5cents/ifc/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/k5cents/ifc/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The ifc package implements the [International Fixed Calendar](https://en.wikipedia.org/wiki/International_Fixed_Calendar)
as a proper S3 vector class. The IFC divides each year into 13 months of
exactly 28 days, with a Year Day appended at year's end (and a Leap Day after
IFC June 28 in leap years). Because each month always starts on Sunday and ends
on Saturday, the day-of-week for any IFC date is fully deterministic from the
day-of-month number.

## Installation

Install the development version from [GitHub](https://github.com/k5cents/ifc):

``` r
# install.packages("pak")
pak::pak("k5cents/ifc")
```

## Usage

``` r
library(ifc)
library(tibble)

# Convert from Gregorian
ifc_date("2024-06-18")
#> <ifc_date[1]>
#> [1] "2024-07-01"

# Construct from IFC components (Sol 1, 2024)
ifc_ymd(2024, 7, 1)
#> <ifc_date[1]>
#> [1] "2024-07-01"

# Intercalary days
ifc_year_day(2024)
#> <ifc_date[1]>
#> [1] "2024 Year Day"

ifc_leap_day(2024)
#> <ifc_date[1]>
#> [1] "2024 Leap Day"

# Accessors
x <- ifc_ymd(2024, 7, 14)
ifc_wday(x, label = TRUE)  # deterministic: day 14 = Saturday
#> [1] "Sat"

format(x, "%B %d, %Y")
#> [1] "Sol 14, 2024"

# Tibble display
tibble(
  gregorian = as.Date(c("2024-01-01", "2024-06-17", "2024-06-18", "2024-12-31")),
  ifc       = ifc_date(gregorian)
)
#> # A tibble: 4 × 2
#>   gregorian        ifc
#>   <date>         <ifc>
#> 1 2024-01-01 2024 Jan 01
#> 2 2024-06-17 2024 Leap Day
#> 3 2024-06-18 2024 Sol 01
#> 4 2024-12-31 2024 Year Day
```

## Code of Conduct

Please note that the ifc project is released with a
[Contributor Code of Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html).
By contributing to this project, you agree to abide by its terms.
