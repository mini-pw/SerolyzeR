# PlateBuilder

This class helps creating the Plate object. It is used to store the data
and validate the final fields.

## Active bindings

- `layout_as_vector`:

  Print the layout associated with the plate as a flattened vector of
  values.

## Methods

### Public methods

- [`PlateBuilder$new()`](#method-PlateBuilder-new)

- [`PlateBuilder$set_sample_locations()`](#method-PlateBuilder-set_sample_locations)

- [`PlateBuilder$set_dilutions()`](#method-PlateBuilder-set_dilutions)

- [`PlateBuilder$set_sample_types()`](#method-PlateBuilder-set_sample_types)

- [`PlateBuilder$set_sample_names()`](#method-PlateBuilder-set_sample_names)

- [`PlateBuilder$set_plate_datetime()`](#method-PlateBuilder-set_plate_datetime)

- [`PlateBuilder$set_data()`](#method-PlateBuilder-set_data)

- [`PlateBuilder$set_default_data_type()`](#method-PlateBuilder-set_default_data_type)

- [`PlateBuilder$set_batch_info()`](#method-PlateBuilder-set_batch_info)

- [`PlateBuilder$set_plate_name()`](#method-PlateBuilder-set_plate_name)

- [`PlateBuilder$set_layout()`](#method-PlateBuilder-set_layout)

- [`PlateBuilder$build()`](#method-PlateBuilder-build)

- [`PlateBuilder$clone()`](#method-PlateBuilder-clone)

------------------------------------------------------------------------

### Method `new()`

Initialize the PlateBuilder object

#### Usage

    PlateBuilder$new(sample_names, analyte_names, batch_name = "", verbose = TRUE)

#### Arguments

- `sample_names`:

  - vector of sample names measured during an examination in the same
    order as in the data. It should not contain any duplicates.

- `analyte_names`:

  - vector of analytes names measured during an examination in the same
    order as in the data

- `batch_name`:

  - name of the batch during which the plate was examined obtained from
    the plate info. An optional parameter, by default set to `""` - an
    empty string.

- `verbose`:

  - logical value indicating whether to print additional information.
    This parameter is stored as a private attribute of the object and
    reused in other methods

------------------------------------------------------------------------

### Method `set_sample_locations()`

Set the sample types used during the examination

#### Usage

    PlateBuilder$set_sample_locations(sample_locations)

#### Arguments

- `sample_locations`:

  vector of sample locations pretty name ie. A1, B2

------------------------------------------------------------------------

### Method `set_dilutions()`

Extract and set the dilutions from layout, sample names or use a
provided vector of values. The provided vector should be the same length
as the number of samples and should contain dilution factors saved as
strings

#### Usage

    PlateBuilder$set_dilutions(use_layout_dilutions = TRUE, values = NULL)

#### Arguments

- `use_layout_dilutions`:

  logical value indicating whether to use names extracted from layout
  files to extract dilutions. If set to `FALSE` the function uses the
  sample names as a source for dilution

- `values`:

  a vector of dilutions to overwrite the extraction process

  Set and extract sample types from the sample names. Optionally use the
  layout file to extract the sample types

------------------------------------------------------------------------

### Method `set_sample_types()`

#### Usage

    PlateBuilder$set_sample_types(use_layout_types = TRUE, values = NULL)

#### Arguments

- `use_layout_types`:

  logical value indicating whether to use names extracted from layout
  files to extract sample types

- `values`:

  a vector of sample types to overwrite the extraction process

------------------------------------------------------------------------

### Method `set_sample_names()`

Set the sample names used during the examination. If the layout is
provided, extract the sample names from the layout file. Otherwise, uses
the original sample names from the Luminex file

In case there are multiple samples with the same name, it prints a
warning and renames the samples, by adding a number.

#### Usage

    PlateBuilder$set_sample_names(use_layout_sample_names = TRUE)

#### Arguments

- `use_layout_sample_names`:

  logical value indicating whether to use names extracted from layout
  files. If set to false, this function only checks if the sample names
  are provided in the plate

------------------------------------------------------------------------

### Method `set_plate_datetime()`

Set the plate datetime for the plate

#### Usage

    PlateBuilder$set_plate_datetime(plate_datetime)

#### Arguments

- `plate_datetime`:

  a POSIXct datetime object representing the date and time of the
  examination

------------------------------------------------------------------------

### Method `set_data()`

Set the data used during the examination

#### Usage

    PlateBuilder$set_data(data)

#### Arguments

- `data`:

  a named list of data frames containing information about the samples
  and analytes. The list is named by the type of the data e.g. `Median`,
  `Net MFI`, etc. The data frames contain information about the samples
  and analytes The rows are different measures, whereas the columns
  represent different analytes Example of how `data$Median` looks like:

  |          |          |          |          |
  |----------|----------|----------|----------|
  | Sample   | Analyte1 | Analyte2 | Analyte3 |
  | Sample1  | 1.2      | 2.3      | 3.4      |
  | Sample2  | 4.5      | 5.6      | 6.7      |
  | ...      | ...      | ...      | ...      |
  | Sample96 | 7.8      | 8.9      | 9.0      |

------------------------------------------------------------------------

### Method `set_default_data_type()`

Set the data type used for calculations

#### Usage

    PlateBuilder$set_default_data_type(data_type = "Median")

#### Arguments

- `data_type`:

  a character value representing the type of data that is currently used
  for calculations. By default, it is set to Median

------------------------------------------------------------------------

### Method `set_batch_info()`

Set the batch info for the plate

#### Usage

    PlateBuilder$set_batch_info(batch_info)

#### Arguments

- `batch_info`:

  a raw list containing metadata about the plate read from the Luminex
  file

------------------------------------------------------------------------

### Method `set_plate_name()`

Set the plate name for the plate. The plate name is extracted from the
filepath

#### Usage

    PlateBuilder$set_plate_name(file_path)

#### Arguments

- `file_path`:

  a character value representing the path to the file

------------------------------------------------------------------------

### Method `set_layout()`

Set the layout matrix for the plate. This function performs basic
validation

- verifies if the plate is a matrix of shape 8x12 with 96 wells

#### Usage

    PlateBuilder$set_layout(layout_matrix)

#### Arguments

- `layout_matrix`:

  a matrix containing information about the sample names. dilutions,
  etc.

------------------------------------------------------------------------

### Method `build()`

Create a Plate object from the PlateBuilder object

#### Usage

    PlateBuilder$build(validate = TRUE, reorder = TRUE)

#### Arguments

- `validate`:

  logical value indicating whether to validate the fields

- `reorder`:

  logical value indicating whether to reorder the data according to the
  locations on the plate. If `FALSE`, the samples will be ordered in the
  same manner as in the CSV plate file.

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    PlateBuilder$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
