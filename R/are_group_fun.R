#' Helper function to generate acute respiratory episodes
#'
#' @description are_group_fun() is used in lk_symp_inter
#'
#' @param var variable name
#' @param thresh_d Threshold
#'
#' @return ...
#' @export
#' @examples
#' are_group_fun()

are_group_fun <- function(var, thresh_d) {
  y <- rle(var) %>%
    "attr<-"("class", "list") %>%
    as_tibble() %>%
    mutate(
      id = row_number(),
      group_3 = case_when(
        values == 0 & lengths > thresh_d ~ 0,
        values == 0 & id == 1 ~ 0,
        values == 0 & id == nrow(.) ~ 0,
        TRUE ~ 1
      )
    )
  rep(x = y$group_3, times = y$lengths)
}
