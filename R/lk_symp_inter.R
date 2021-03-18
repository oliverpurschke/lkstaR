#' Generates acute respiratory episodes (ARE)
#'
#' @description lk_symp_inter() classifies each entry in the symptom diary to a acute respiratory episodes (ARE).
#'
#' @param lk_dat Input data (takes output from lk_krank_klass)
#' @param thresh_inter ...
#' @param thresh_d threshold for gaps
#' @param scenario liberal or conservative scenario 
#' @param write_table Should the output be written to a xlsx-table (TRUE or FALSE)
#'
#' @return A data.frame including the output from lk_klass as well as the additional columns for ARE and ARE-Type
#' @keywords symptom diary
#' @export
#' @examples
#' lk_symp_inter()


lk_symp_inter <-
  function(lk_dat,
           thresh_inter,
           thresh_d,
           scenario,
           write_table = T) {
    message(
      paste0(
        "Die ARE werden soeben gerechnet. Bitte überprüfe die Ergebnisse in der Ausgabetabelle ",
        "Symp_intervalle_",
        scenario,
        "_",
        today(),
        ".xlsx"
      )
    )
    krank <- ifelse(scenario == "lib", "krank_lib", "krank_kons")
    n_symp <-
      ifelse(scenario == "lib", "n_symp_b_lib", "n_symp_b_kons")
    symp_a_klass <-
      ifelse(scenario == "lib", "symp_a_lib_klass", "symp_a_kons_klass")
    Symp_intervalle <- lk_dat %>%
      select(id_s, date_sta, krank, n_symp, symp_a_klass) %>%
      group_by(id_s) %>%
      mutate(
        inter_dat_2 = cumsum((date_sta - lag(date_sta)) > thresh_inter  &
                               !is.na(lag(date_sta))),
        krank_a_b = ifelse(eval(as.name(krank)) == 1, 1, eval(as.name(n_symp)))
      ) %>%
      group_by(id_s, inter_dat_2) %>%
      mutate(
        ARE = are_group_fun(var = krank_a_b, thresh_d = thresh_d),
        ARE_break = cumsum((ARE - lag(ARE)) %in% c(-1, 1)  &
                             !is.na(lag(ARE)))
      ) %>%
      group_by(id_s, inter_dat_2, ARE_break) %>%
      mutate(ARE_Type = ifelse((
        ARE == 1 &
          all(eval(as.name(n_symp)) == 1, na.rm = T) &
          all(eval(as.name(symp_a_klass)) == 0, na.rm = T)
      ),
      2, ARE))
    Symp_intervalle_2 <- Symp_intervalle %>%
      inner_join(
        x = (lk_dat %>% select(-c(
          krank, n_symp, symp_a_klass
        ))),
        y = Symp_intervalle,
        by = c("id_s" = "id_s", "date_sta" = "date_sta")
      ) %>%
      select(
        -c(
          fieber_messung_sonstiges,
          Erbrechen,
          Durchfall,
          arzt_ag:notizen,
          Med_1_Tage:Verdacht_Arzt_aG,
          gr
        )
      )
    if (write_table == T) {
      write.xlsx(
        x = Symp_intervalle_2,
        file = paste0("Symp_intervalle_", scenario, "_", today(), ".xlsx"),
        asTable = T,
        colWidths = "auto"
      )
    }
    Symp_intervalle_2
  }