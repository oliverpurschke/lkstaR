#' Calculation of outcome variables
#'
#' @description lk_symp_outcome() generates a set of outcome variables.
#'
#' @param lk_inter_dat First input data (takes output from lk_symp_inter)
#' @param lk_epi_dat Second input data (takes output from lk_epi_dat) 
#' @param scenario Liberal or conservative scenario 
#' @param lebmon Duration of months of life considered in the analysis (e.g. 12 months)
#' @param write_table Should the output be written to a xlsx-table (TRUE or FALSE)
#'
#' @return A data.frame containing start and end date as well as duration in days for each ARE
#' @keywords symptom diary
#' @export
#' @examples
#' lk_symp_outcome()

lk_symp_outcome <-
  function(lk_inter_dat,
           lk_epi_dat,
           scenario,
           lebmon,
           write_table = T) {
    n_d_are_across <- lk_epi_dat %>%
      group_by(id_s) %>%
      summarise(
        n_are_total = sum(ARE_Type != 0),
        n_are_1 = sum(ARE_Type == 1),
        n_are_2 = sum(ARE_Type == 2),
        d_total = sum(Days),
        d_are_total = sum(Days * (ARE_Type != 0)),
        d_are_1 = sum(Days * (ARE_Type == 1)),
        d_are_2 = sum(Days * (ARE_Type == 2)),
        d_healthy = sum(Days * (ARE_Type == 0))
      )
    d_are_within <- lk_inter_dat %>%
      group_by(id_s) %>%
      summarise(
        d_ill_a_b = sum(krank_lib == 1 | n_symp_b_lib > 1),
        d_b1 = sum(krank_lib == 0 & n_symp_b_lib == 1),
        d_sf = sum(ARE_Type != 0 & krank_a_b == 0),
        d_are_total_2 = sum(ARE_Type != 0),
        
        dat_sta_min = min(date_sta),
        dat_sta_max = max(date_sta),
        d_sta_spanne = as.numeric(difftime(dat_sta_max, dat_sta_min, units = "days") + 1),
        d_eintrag = n(),
        perc_eintrag_spanne = round((d_eintrag / d_sta_spanne) * 100, 1),
        perc_eintrag_voll = round((d_eintrag / (
          round(30.4375 * lebmon, 2)
        )) * 100, 1)
      )
    Symp_outcome <- n_d_are_across %>%
      inner_join(d_are_within) %>%
      rowwise() %>%
      mutate(are_tot_eq_days = sum(c_across(d_ill_a_b:d_sf), na.rm = T) == d_are_total) %>%
      ungroup() %>%
      mutate(d_are_dat_gaps = d_are_total - d_are_total_2)
    if (write_table == T) {
      write.xlsx(
        x = Symp_outcome,
        file = paste0("Symp_outcome_", scenario, "_", today(), ".xlsx"),
        asTable = T,
        colWidths = "auto"
      )
    }
    Symp_outcome
  }

