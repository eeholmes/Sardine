# SardineForecast

To install SardineForecast, you will need to install the following package:

* devtools

If you are on a Windows machine, you will also need to install Rtools from <https://cran.r-project.org/bin/windows/Rtools/>.  

Once you have installed these packages, install SardineForecast using

```
library(devtools)
install_github("eeholmes/SardineForecast")
```

The SardineForecast package and the required packages should automatically install when you install.  However, if they do not for some reason, you need to install them yourself from CRAN before installing SardineForecast:

* stringr
* forecast
* rmarkdown
* knitr
* bibtex
* gbRd
* mgcv
* maps
* mapdata


# Setting up R and RStudio

This page steps you through installing R, RStudio, Rtools, and devtools: <https://github.com/genomicsclass/windows>.  These are the 4 pieces you need to install packages from GitHub if you are on a Windows machine.  If you are on a mac, you can skip Rtools installation.

# Creating PDFs

You will need to install LaTex to make PDFs: <https://www.latex-project.org/get/>