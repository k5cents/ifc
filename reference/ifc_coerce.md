# Coerce an IFC date to a base R date type

Coerce an IFC date to a base R date type

## Usage

``` r
# S3 method for class 'ifc_date'
as.Date(x, ...)

# S3 method for class 'ifc_date'
as.POSIXct(x, tz = "UTC", ...)

# S3 method for class 'ifc_date'
as.POSIXlt(x, tz = "UTC", ...)

# S3 method for class 'ifc_date'
as.integer(x, ...)

# S3 method for class 'ifc_date'
as.double(x, ...)

# S3 method for class 'ifc_date'
as.character(x, ...)
```

## Arguments

- x:

  An `ifc_date` vector.

- ...:

  Ignored.

- tz:

  Time zone string passed to `as.POSIXct` / `as.POSIXlt`.

## Value

The corresponding base R type.
