# Determine the Join Value

Returns a non-`NA`/non-`NULL` value based on the inputs. If either value
is `NA` or `NULL`, it returns the non-`NA`/non-`NULL` value. If both
values are equal, it returns that value.

## Usage

``` r
get_join_value(x, y)
```

## Arguments

- x:

  A value to be compared.

- y:

  A value to be compared.

## Value

A non-`NA`/non-`NULL` value or the common value if `x` equals `y`.
Returns `NULL` if the values differ and neither is `NA` or `NULL`.
