# lkstaR - Analysis of Loewenkids Symptom Diary in R
![alt tag](https://github.com/oliverpurschke/lkstaR/blob/main/lkstaR.png "Loewenkids Logo")

Installing the package
================

``` r
library(ggplot2)
library(plyr)
library(dplyr)
library(reshape)
library(foreach)
```

This document describes the workflow of generating some figures that visualize the match between (i) global vegetation plot database sPlot version 2.1 and (ii) the global plant trait data base TRY version 3.

Load required packages
======================

``` r
library(ggplot2)
library(plyr)
library(dplyr)
library(reshape)
library(foreach)
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
