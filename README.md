# lkstaR - Analysis of Loewenkids Symptom Diary in R
![alt tag](https://github.com/oliverpurschke/lkstaR/blob/main/lkstaR.png "Loewenkids Logo")

Installing the package
------------------

``` r
remotes::install_github("oliverpurschke/lkstaR")
```

Load required packages
------------------

``` r
library(lkstaR)
library(haven)
library(tidyverse)
library(lubridate)
library(openxlsx)
library(doSNOW)
library(parallel)
library(eeptools)
```

Loading Data
------------------

``` r
path_data <- "P:/IMEBI/LöwenKIDS_Studie/8_Studiendaten/8.3_Data_GebKo_Work/8.3.2_Symptomtagebuch/SAS_Datensatz_permanent/"
lk_data <- read_sas(paste0(path_data, "sta_gesamt10mar21.sas7bdat"))
save(lk_data_21_03_10, file = "lk_data_21_03_10.Rdata")
load("lk_data_21_03_10.Rdata")
```


sPlot species data
------------------

Rulk_klass

``` r
load("/home/oliver/Dokumente/PhD/PostPhD/IDiv/sDiv/sPlot/Analyses/Data/Species/sPlot/
sPlot_2017_08_04/splot_20161025_species_small.Rdata")
gc()
```

``` r
dim(DT2_small)
```
