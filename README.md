# lkstaR - Analysis of the Loewenkids Symptom Diary in R <img src='https://github.com/oliverpurschke/lkstaR/blob/main/lkstaR_small.png' align="center" height="330"/>

To cite the package use:

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4915826.svg)](https://doi.org/10.5281/zenodo.4915826)

Installing the package
================

``` r
install.packages("remotes")
remotes::install_github("oliverpurschke/lkstaR")
library(lkstaR)
library(help=lkstaR)
?lk_klass
```

Load additional packages
================

``` r
library(haven)
library(tidyverse)
library(lubridate)
library(openxlsx)
library(doSNOW)
library(parallel)
library(eeptools)
```

Load Data
================

``` r
path_data <- "P:/IMEBI/LöwenKIDS_Studie/8_Studiendaten/8.3_Data_GebKo_Work/8.3.2_Symptomtagebuch/SAS_Datensatz_permanent/"
lk_data_23_05_25 <- read_sas(paste0(path_data, "sta_gesamt25may23.sas7bdat"))
save(lk_data_23_05_25, file = "lk_data_23_05_25.Rdata")
load("lk_data_23_05_25.Rdata")
```

Using the package
================

Classification and filtering of symptom diary entries
------------------

lk_klass() filters records for each id_s in the symptom diary according to a predefined duration (months of living) and classifies each entry according to predefined fever categories. In addition, age (in days as well as in months of life) for each individual are calculated.
e. g. for 1 until 12 months of life:

``` r
?lk_klass

lk_lebmon_fieber_klass <- lk_klass(
  lk_dat = lk_data_23_05_25,
  lebmon_min = 0,
  lebmon_max = 12,
  f_niedrig = 37.5,
  f_hoch = 38.4
)
```

Classification of symptom diary entries into acute respiratory A- and B-symptoms
------------------

lk_krank_klass() classifies each record in the symptom diary into A-symptoms, and counts the number of B-symptoms, according to two scenarios (conservative and liberal).

``` r
?lk_krank_klass

res <- lk_krank_klass(
  lk_dat = lk_lebmon_fieber_klass,
  diag_num = c(1, 2, 3, 4, 5, 6, 9),
  symp_a_vec = c("keuchen_atmend", "husten_aw"),
  symp_resp_weitere_vec = c(
    "husten_tr",
    "husten_wn",
    "Nase",
    "hals"
  ), 
  symp_b_lib_vec = c(
    "husten_tr",
    "husten_wn",
    "Nase",
    "Schuettelfrost",
    "hals",
    "appetit",
    "schlafbeduerfnis",
    "Anhaenglichkeit"
  ),
  write_table = F
)
```

Generate acute respiratory episodes (ARE)
------------------

lk_symp_inter() classifies each entry in the symptom diary into acute respiratory episodes (ARE). E. g. for the liberal scenario:

``` r

?lk_symp_inter

Symp_intervalle_lib <- lk_symp_inter(
  lk_dat = res,
  thresh_inter = 2,
  thresh_d = 2,
  scenario = "lib",
  write_table = T
)

```

Generate episodes data set
------------------

lk_symp_episod() generates an episodes data set containing time spans for each ARE/ARE-Type. E. g. for the liberal scenario:

``` r
?lk_symp_episod

Symp_episoden_lib <-
  lk_symp_episod(lk_dat = Symp_intervalle_lib,
                 scenario = "lib",
                 write_table = T)
```

Calculate outcome variables
------------------

lk_symp_outcome() generates a set of outcome variables. E. g. for the liberal scenario:

``` r
?lk_symp_outcome

Symp_outcome_lib <-
  lk_symp_outcome(lk_inter_dat = Symp_intervalle_lib,
                  lk_epi_dat = Symp_episoden_lib,
                  scenario = "lib",
                  lebmon = 12,
                  write_table = T)
```
