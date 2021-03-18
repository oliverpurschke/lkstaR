# lkstaR - Analysis of Loewenkids Symptom Diary in R
![alt tag](https://github.com/oliverpurschke/lkstaR/blob/main/lkstaR.png "Loewenkids Logo")

Installing the package
================

``` r
remotes::install_github("oliverpurschke/lkstaR")
```

Load required packages
======================

``` r
library(haven)
library(tidyverse)
library(lubridate)
library(openxlsx)
library(doSNOW)
library(parallel)
library(eeptools)
```

Loading Data
============

sPlot species data
------------------

Loading a reduced version of 'splot\_20161025\_species', DT2\_small, that just contains the columns 'PlotObservationID', 'species' and 'Relative.cover':

``` r
load("/home/oliver/Dokumente/PhD/PostPhD/IDiv/sDiv/sPlot/Analyses/Data/Species/sPlot/
sPlot_2017_08_04/splot_20161025_species_small.Rdata")
gc()
```

``` r
dim(DT2_small)
```
