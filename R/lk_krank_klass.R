#' Classification into acute respiratory A- and B-symptoms of symptom diary entries 
#'
#' @description lk_krank_klass() classifies each record in the symptom diary into A-symptoms, and counts the number of B-symptoms, according to two scenarios (conservative and liberal).
#'
#' @param lk_dat Input data (takes output from lk_klass)
#' @param diag_num Vector of the Diagnose_Symptome-columns to be considered in the symptom diary
#' @param symp_a_vec Vector of A-Symptoms (conservative scenario)
#' @param symp_resp_weitere_vec Vector of additional A-Symptoms to be considered in the liberal scenario 
#' @param symp_b_lib_vec Vector of B-Symptoms to be considered in the liberal scenario
#' @param write_table Should the output be written to a xlsx-table (TRUE or FALSE)
#'
#' @return A data.frame including the output from lk_klass as well as the additional binary classification columns symp_a_lib_klass (A-Symptom, liberal scenario), symp_a_kons_klass (A-Symptom, conservative scenario) as well as n_symp_b_lib and n_symp_b_kons (number of B-Symptoms in liberal and conservative scenario, respectively)
#' @keywords symptom diary
#' @export
#' @examples
#' lk_krank_klass()


lk_krank_klass <-
  function(lk_dat,
           diag_num,
           symp_a_vec,
           symp_resp_weitere_vec,
           symp_b_lib_vec,
           write_table = F) {
    diag_7_vec <- paste("Diagnose_Symptome", diag_num, sep = "_")
    lk_dat_2 <-
      lk_dat %>%
      mutate(gr = stringr::str_sub(id_s, -2, -1))
    
    lk_dat_split <- split(lk_dat_2, lk_dat_2$gr)
    message(
      paste0(
        "Bitte etwas Geduld! Die Klassfikation der A-Symptome sowie Berechnung der Anzahl der B-Symptome für die einzelnen Szenarien kann für insgesamt ", nrow(lk_dat), " Einträge etwas Zeit in Anspruch nehmen. Zur Beschleunigung werden die Berechnungen auf ", detectCores() - 1, " virtuellen Kernen durchgeführt.")
    )
    cl <- makeCluster(detectCores() - 1)
    registerDoSNOW(cl)
    ntasks <- length(lk_dat_split)
    pb <- txtProgressBar(max = ntasks, style = 3)
    progress <- function(n)
      setTxtProgressBar(pb, n)
    opts <- list(progress = progress)
    lk_dat_parallel <-
      foreach(
        k = lk_dat_split,
        .packages = c("purrr", "dplyr", "doSNOW"),
        .combine = bind_rows,
        .options.snow = opts
      ) %dopar% {
        k %>%
          rowwise() %>%
          mutate(
            symp_a_lib_klass = ifelse(((
              any(c_across(all_of(diag_7_vec)) > 0, na.rm = T) |
                (any(c_across(
                  all_of(symp_a_vec)
                  
                ) > 0, na.rm = T))
            ) |
              Fieber_klass == 1),
            1, 0),
            symp_a_kons_klass = ifelse(((
              any(c_across(all_of(diag_7_vec)) > 0, na.rm = T) |
                (any(c_across(
                  all_of(symp_a_vec)
                ) > 0, na.rm = T))
            ) |
              (
                Fieber_klass == 1 &
                  any(c_across(all_of(
                    symp_resp_weitere_vec
                  )) > 0, na.rm = T)
              )),
            1, 0),
            n_symp_b_lib = sum(c_across(all_of(symp_b_lib_vec)) > 0, na.rm = T),
            n_symp_b_kons = sum(c_across(all_of(
              symp_resp_weitere_vec
            )) > 0, na.rm = T)
          )
      }
    stopCluster(cl)
    lk_dat_3 <-
      lk_dat_parallel %>%
      mutate(krank_lib = ifelse((symp_a_lib_klass == 1 |
                                   n_symp_b_lib > 1),
                                1, 0),
             krank_kons = ifelse((
               symp_a_kons_klass == 1 |
                 (n_symp_b_lib > 1 &
                    n_symp_b_kons > 0)
             ),
             1, 0))
    if (write_table == T) {
      write.xlsx(
        x = lk_dat_3,
        file = paste0("lk_dat_", today(), ".xlsx"),
        asTable = T,
        colWidths = "auto"
      )
    }
    lk_dat_3
  }
