# lkstaR - Analysis of Loewenkids Symptom Diary in R
![alt tag](https://github.com/oliverpurschke/lkstaR/blob/main/lkstaR.png "Loewenkids Logo")

Installing the package
------------------

``` r
remotes::install_github("oliverpurschke/lkstaR")
library(lkstaR)
library(help=lkstaR)
?lk_klass
```

Load additional packages
------------------

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
------------------

``` r
path_data <- "P:/IMEBI/LöwenKIDS_Studie/8_Studiendaten/8.3_Data_GebKo_Work/8.3.2_Symptomtagebuch/SAS_Datensatz_permanent/"
lk_data <- read_sas(paste0(path_data, "sta_gesamt10mar21.sas7bdat"))
save(lk_data_21_03_10, file = "lk_data_21_03_10.Rdata")
load("lk_data_21_03_10.Rdata")
```


Classification and filtering of symptom diary entries
------------------
lk_klass() filters records for each id_s in the symptom diary according to a predefined duration (months of living) and classifies each entry according to predefined fever categories. In addition, age (in days as well as in months of life) for each individual are calculated.
e.g. for 1 until 12 months of life:

``` r
lk_lebmon_fieber_klass <- lk_klass(
  lk_dat = lk_data_21_03_10,
  #lebmon = 24,
  lebmon_min = 0,
  lebmon_max = 12,
  f_niedrig = 37.5,
  f_hoch = 38.4
)
```

``` r
dim(DT2_small)
```
