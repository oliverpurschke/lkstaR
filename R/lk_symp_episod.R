#' Generating episodes data set
#'
#' @description lk_symp_episod() generates episodes data set comprised of time spans for each ARE/ARE-Type.
#'
#' @param lk_dat Input data (takes output from lk_symp_inter)
#' @param scenario liberal or conservative scenario 
#' @param write_table Should the output be written to a xlsx-table (TRUE or FALSE)
#'
#' @return A data.frame containing start and end date as well as duration in days for each ARE
#' @keywords symptom diary
#' @export
#' @examples
#' lk_symp_episod()


lk_symp_episod <-
  function(lk_dat,
           scenario,
           write_table = T) {
    Symp_episoden <- lk_dat %>%
      group_by(id_s, inter_dat_2, ARE_break, ARE_Type) %>%
      summarise(
        Min = min(date_sta),
        Max = max(date_sta),
        Days = difftime(Max, Min, units = "days") + 1
      )
    if (write_table == T) {
      write.xlsx(
        x = Symp_episoden,
        file = paste0("Symp_episoden_", scenario, "_", today(), ".xlsx"),
        asTable = T,
        colWidths = "auto"
      )
    }
    Symp_episoden
  }