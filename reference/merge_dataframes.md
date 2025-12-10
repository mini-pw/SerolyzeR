# Merge dataframes

Merges a list of dataframes by handling column collisions through
specified strategies: "intersection" or "union".

## Usage

``` r
merge_dataframes(
  dataframes,
  column_collision_strategy = "intersection",
  fill_value = NA
)
```

## Arguments

- dataframes:

  A list of dataframes to merge.

- column_collision_strategy:

  A string specifying how to handle column collisions. "intersection"
  keeps only columns present in all dataframes, "union" includes all
  columns from all dataframes, filling missing values.

- fill_value:

  Value to fill in missing columns if `column_collision_strategy` is
  "union".

## Value

Merged dataframe
