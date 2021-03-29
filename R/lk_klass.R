#' Classification and filtering of symptom diary entries 
#'
#' @description lk_klass() filters records for each id_s in the symptom diary according to a predefined duration (months of living) and classifies each entry according to predefined fever categories. In addition, age (in days as well as in months of life) for each individual are calculated.
#'
#' @param lk_dat Input data set (Loewenkids symptom diary)
#' @param lebmon_min Minimum month of life
#' @param lebmon_max Maximum month of life
#' @param f_niedrig Low fever cut off
#' @param f_hoch High fever cut off
#'
#' @return A data.frame including the original symptom diary and the additional columns
#' @keywords symptom diary fever classification months of life
#' @export
#' @examples
#' lk_klass()


lk_klass <-
  function(lk_dat,
           #lebmon,
           lebmon_min,
           lebmon_max,
           f_niedrig,
           f_hoch) {
    lk_dat %>%
      group_by(id_s) %>%
      # filter(date_sta < gebdat_exakt %m+% months(lebmon)) %>%
      mutate(lebmon_int =
               between(
                 date_sta,
                 first(gebdat_exakt %m+% months(lebmon_min)),
                 first(gebdat_exakt %m+% months(lebmon_max) - 1
               ))) %>% 
      filter(lebmon_int == TRUE) %>%
      ungroup() %>%
      mutate(
        Fieber_Kat =
          case_when(
            fieber_grad < f_niedrig ~ paste0("<", f_niedrig),
            between(fieber_grad, f_niedrig, f_hoch) ~ paste(f_niedrig, f_hoch, sep = "-"),
            fieber_grad > f_hoch ~ paste0(">", f_hoch),
            TRUE ~ "NA"
          ),
        Fieber_Kat = factor(
          Fieber_Kat,
          levels = c(
            paste0("<", f_niedrig),
            paste(f_niedrig, f_hoch, sep = "-"),
            paste0(">", f_hoch)
          ),
          ordered = T
        ),
        fieber_Messung = factor(
          fieber_Messung,
          levels = sort(unique(lk_dat$fieber_Messung)),
          ordered = T
        ),
        fieber_Messung = recode_factor(
          fieber_Messung,
          `1` = "After",
          `2` = "Ohr",
          `3` = "Stirn",
          `4` = "Achsel",
          `5` = "Mund"
        ),
        Fieber_klass =
          ifelse((
            Fieber_Kat %in% c(paste(f_niedrig, f_hoch, sep = "-"), paste0(">", f_hoch))# |
            #Fieber %in% c(1, 2) in Version vom 10.07.2020, da kein bei App ursprünglich keine Temperaturmessungen
            #Fieber %in% c(2)
          ),
          1, 0),
        id_s = as.character(id_s),
        alter_d = age_calc(gebdat_exakt, enddate = date_sta, units = "days"),
        alter_lm = ceiling(age_calc(
          gebdat_exakt, enddate = date_sta, units = "months"
        ))
      )
  }