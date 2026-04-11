# CLAUDE.md

This file provides context for Claude Code when working on the `ifc` R package.

## Package Overview

`ifc` implements the [International Fixed Calendar](https://en.wikipedia.org/wiki/International_Fixed_Calendar)
as a vctrs-based S3 class (`ifc_date`). The IFC has 13 months of 28 days each,
plus two intercalary days: Year Day (end of every year) and Leap Day (after IFC
June 28 in leap years). Because every month starts on Sunday and ends on
Saturday, the weekday of any date is fully deterministic from its day-of-month.

## Source Files

| File | Contents |
|------|----------|
| `R/math.R` | Internal calendar math: `doy_to_ifc()`, `ifc_to_doy()`, `epoch_to_ydoy()`, `ifc_decompose()`. Exported constants: `IFC_MONTH_NAMES`, `IFC_MONTH_ABBR`, `IFC_WDAY_NAMES`, `IFC_WDAY_ABBR`. |
| `R/class.R` | vctrs infrastructure: `new_ifc_date()`, `vec_ptype2.*`, `vec_ptype_abbr/full`. |
| `R/constructors.R` | User-facing constructors: `ifc_date()`, `ifc_ymd()`, `ifc_year_day()`, `ifc_leap_day()`, `ifc_today()`. |
| `R/accessors.R` | Component extractors: `ifc_year()`, `ifc_month()`, `ifc_day()`, `ifc_yday()`, `ifc_wday()`, `is_year_day()`, `is_leap_day()`. |
| `R/arithmetic.R` | vctrs double-dispatch: `vec_arith.ifc_date.*` and `vec_arith.numeric.ifc_date`. |
| `R/coerce.R` | `vec_cast.ifc_date.*` (cast TO ifc_date) and `as.Date/POSIXct/POSIXlt/integer/double/character` methods. |
| `R/format.R` | `format.ifc_date()` with strftime-style tokens; `print.ifc_date()`. |
| `R/pillar.R` | tibble column display: `pillar_shaft.ifc_date()`, `type_sum.ifc_date()`. |
| `R/compat-lubridate.R` | S3 methods for lubridate generics (year, month, mday, wday, yday, as_date). |
| `R/zzz.R` | `.onLoad()` — registers lubridate compat methods via `vctrs::s3_register()`. |
| `R/ifc-package.R` | Package-level `@importFrom` declarations (the `## usethis namespace:` block). |

## Tests

Tests live in `tests/testthat/`. Each source file has a corresponding test file:

```
tests/testthat/test-math.R
tests/testthat/test-constructors.R
tests/testthat/test-accessors.R
tests/testthat/test-arithmetic.R
tests/testthat/test-coerce.R
tests/testthat/test-format.R
tests/testthat/test-compat-lubridate.R
```

Run all tests:

```r
devtools::test()
```

Run a single file:

```r
testthat::test_file("tests/testthat/test-math.R")
```

## Key Design Decisions

- **Integer-backed**: `ifc_date` wraps an integer of days since Unix epoch
  (1970-01-01), identical to base R `Date`. This makes arithmetic and
  Gregorian round-trips trivial.

- **Gregorian bridge**: All calendar math goes through DOY (day-of-year).
  `epoch_to_ydoy()` extracts year + DOY from the integer using `format(Date,
  "%Y"/%j")`. `doy_to_ifc()` converts DOY to IFC month/day by collapsing the
  Leap Day gap: `doy_adj <- doy - (is_leap & doy > 169L)`.

- **Special days**: Year Day and Leap Day have `month = NA` and `day = NA`.
  `is_year_day` and `is_leap_day` logical flags distinguish them.

- **vctrs double-dispatch**: `vec_arith.ifc_date` dispatches on `y` via
  `UseMethod("vec_arith.ifc_date", y)`. The reverse direction
  `vec_arith.numeric.ifc_date` requires `importFrom(vctrs, vec_arith.numeric)`
  in the namespace (not auto-imported).

- **lubridate compat**: Registered via `vctrs::s3_register()` in `.onLoad()`
  rather than NAMESPACE, keeping lubridate in Suggests only.

## NAMESPACE / Roxygen Notes

- Run `devtools::document()` to regenerate `NAMESPACE` from roxygen2 tags.
- The `## usethis namespace: start/end` block in `ifc-package.R` must not be
  broken across lines by `use_lifecycle()` or other usethis helpers.
- `vec_arith.numeric` and `vec_ptype2.Date` must be explicitly listed in
  `@importFrom vctrs` — they are not auto-importable.

## Development Workflow

```r
devtools::load_all()   # load package
devtools::check()      # full R CMD check
devtools::document()   # regenerate docs + NAMESPACE
devtools::test()       # run tests
```

## Session Start Checklist

At the beginning of every session, before touching any code:

1. **Scan open GitHub issues** — especially the v1.1.0 milestone:
   ```bash
   gh issue list --state open
   gh issue list --milestone v1.1.0
   ```

2. **Check CI status** — confirm all workflows are green before adding new work:
   ```bash
   gh run list --limit 5
   ```

## Available Skills (Posit Plugins)

Claude Code has access to the following skills installed from Posit. Use them proactively rather than doing the equivalent work manually:

| Skill | When to use |
|-------|-------------|
| `posit-dev:critical-code-reviewer` | Before any PR or release — adversarial review of R source, tests, and docs |
| `r-lib:cran-extrachecks` | Before CRAN submission — catches URL validation, `Authors@R` format, `\dontrun` policy, etc. |
| `r-lib:testing-r-packages` | When writing or expanding tests — testthat 3 best practices, snapshots, fixtures |
| `r-lib:r-package-development` | General devtools/roxygen2/usethis questions |
| `r-lib:cli` | When adding or improving user-facing messages with `cli_abort`/`cli_warn` |
| `r-lib:lifecycle` | When deprecating or superseding functions |
| `open-source:create-release-checklist` | When starting a new release — generates a GitHub issue checklist |
| `open-source:release-post` | When writing a release announcement blog post |
