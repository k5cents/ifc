# Coerce an IFC datetime to a base R datetime type

Coerce an IFC datetime to a base R datetime type

## Usage

``` r
# S3 method for class 'ifc_datetime'
as.POSIXct(x, tz = NULL, ...)

# S3 method for class 'ifc_datetime'
as.POSIXlt(x, tz = NULL, ...)

# S3 method for class 'ifc_datetime'
as.Date(x, tz = NULL, ...)

# S3 method for class 'ifc_datetime'
as.character(x, ...)

# S3 method for class 'ifc_datetime'
as.double(x, ...)
```

## Arguments

- x:

  An `ifc_datetime` vector.

- tz:

  Time zone string. If `NULL` (default), uses the timezone stored in
  `x`.

- ...:

  Ignored.

## Value

The corresponding base R type.
