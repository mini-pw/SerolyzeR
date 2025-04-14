# SerolyzeR - an R package for automated analysis of serological data

<!-- badges: start -->
[![R-CMD-check](https://github.com/mini-pw/SerolyzeR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/mini-pw/SerolyzeR/actions/workflows/R-CMD-check.yaml)
![Downloads](https://cranlogs.r-pkg.org/badges/SerolyzeR)
[![codecov](https://codecov.io/gh/mini-pw/SerolyzeR/graph/badge.svg?token=11EVHXMHDO)](https://app.codecov.io/gh/mini-pw/SerolyzeR)
<!-- badges: end -->


## Overview
This package is a simple tool that handles various raw data formats produced in Multiplex Bead Assay (MBA). In short, it reads the unstructured, raw data from, e.g., the Luminex device and outputs normalised and well-structured data, which can be used later in more advanced downstream analysis.

The package includes three main steps for preprocessing the data:

1.  data reading and manipulation
2.  quality control
3.  data normalisation


The graphical overview of the package can be seen in the image below:

<img src="https://github.com/mini-pw/SerolyzeR/blob/main/inst/img/overview.png?raw=true" alt="overview" />

`SerolyzeR` package is developed within the [PvSTATEM](https://www.pvstatem.eu/) initiative. The project has received funding from the European Union’s Horizon Europe research and innovation program under grant agreement No 101057665.



Previously, this package was named `PvSTATEM`, but it has been rebranded to `SerolyzeR` to better reflect its purpose and scope.

## Installation

The easiest way to install the package is using the CRAN repository:
``` r
install.packages("SerolyzeR")
require(SerolyzeR) # load the installed package
```
Now, you are ready to use the package to read your files!

Please note that since uploading the package to the CRAN repository requires the volunteers' time to manually run checks on the packages, the **package version currently released on CRAN might not be the latest**.

The package is under heavy development, with new features being released weekly. Therefore, if you'd like to test the latest package functionalities, we recommend installing it in the development version. It can be done using a simple command `install_github` available in the `devtools` library:

``` r
require(devtools)
install_github("mini-pw/SerolyzeR")
require(SerolyzeR) # load the installed package
```

The first command loads the `devtools` library (you might need to install it first - using the command `install_packages("devtools")`), and the second one sources the git repository with the code of our package and automatically installs it.

## Examples and instructions

The example use of the package and its functionalities can be found in [the vignettes](https://mini-pw.github.io/SerolyzeR/articles/example_script.html).
For more detailed documentation, check [the package website](https://mini-pw.github.io/SerolyzeR/).


## Contributing and issues

As a project in the development phase, we are open to any suggestions, bug reports, and contributions. If you have any ideas or issues, please report them in the [Issues](https://github.com/mini-pw/SerolyzeR/issues) section. Our team of developers will address them as soon as possible.


## Acknowledgements


Funded by the European Union. Views and opinions expressed are, however, those of the author(s) only and do not necessarily reflect those of the European Union or HaDEA. Neither the European Union nor the granting authority can be held responsible for them. 


The package was developed as a Bachelor's thesis by Jakub Grzywaczewski, Tymoteusz Kwieciński and Mateusz Nizwantowski on Warsaw University of Technology, Faculty of Mathematics and Information Science, supervised by prof. dr hab. inż. Przemysław Biecek.


<div style="width: 100%; margin-top: 2em;">
  <div style="display: flex; justify-content: space-evenly; align-items: center; max-width: 1000px; margin: 0 auto;">
  <a href="https://www.pvstatem.eu/" target="_blank">
  <img src="https://github.com/mini-pw/SerolyzeR/blob/main/inst/img/PvSTATEM.png?raw=true" alt="PvSTATEM logo" style="height: 100px;"/>
  </a>
  <img src="https://github.com/mini-pw/SerolyzeR/blob/main/inst/img/EU.jpg?raw=true" alt="EU logo" style="height: 100px;"/>
  <a href="https://www.pw.edu.pl/" target="_blank">
  <img src="https://github.com/mini-pw/SerolyzeR/blob/main/inst/img/WUT.png?raw=true" alt="WUT logo" style="height: 100px; "/>
  </a>
  </div>
</div>

</br> </br>
