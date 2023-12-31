#' Calculates variable-wise proportion of usable cases (missing and observed)
#'
#' Calculates variable-wise proportion of usable cases (missing and observed) as in Molenberghs et al. (2014).
#'
#' missForest builds models for each variable using the observed values of that variable as outcome
#' of a random forest model. It then imputes the missing part of the variable using the learned models.
#'
#' If all values of a predictor are missing among the observed value of the outcome,
#' the value of \code{p_obs} will be 1 and the model built will rely heavily on the initialized values.
#' If all values of a predictor are observed among the observed values of the outcome, \code{p_obs} will be 0
#' and the model will rely on observed values. Low values of \code{p_obs} are preferred.
#'
#' Similarly, if all values of a predictor are missing among the missing values of the outcome,
#' \code{p_miss} will have a value of 0 and the imputations (predictions) will heavily rely on the initialized values.
#' If all values of a predictor are observed among the missing value of the outcome, \code{p_miss} will have a value of 1
#' and the imputations (predictions) will rely on real values. High values of \code{p_miss} are preferred.
#'
#' Each row represents a variable to be imputed and each column a predictor.
#'
#' @param data dataframe to be imputed
#'
#' @return a list with two elements: \code{p_obs} and \code{p_miss}
#'     \item{\code{p_obs}}{the proportion of missing \eqn{Y_k} among observed \eqn{Y_j}; j in rows, k in columns}
#'     \item{\code{p_miss}}{the proportion of observed \eqn{Y_k} among missing \eqn{Y_j}; j in rows, k in columns}
#' @references
#' \itemize{
#'     \item Molenberghs, G., Fitzmaurice, G., Kenward, M. G., Tsiatis, A., & Verbeke, G. (Eds.). (2014). Handbook of missing data methodology. CRC Press. Chapter "Multiple Imputation"
#'   }
#' @export

prop_usable_cases <- function(data){
  NA_loc <- !is.na(data) # observed indicator

  rr <- t(NA_loc) %*% NA_loc
  mm <- t(!NA_loc) %*% !NA_loc
  mr <- t(NA_loc) %*% !NA_loc
  rm <- t(!NA_loc) %*% NA_loc

  p_miss <- t(mr / (mr + mm)) # transpose to keep in rows the var to be imputed
  p_obs <- t(rm / (rm + rr))


  list(p_obs = p_obs, p_miss = p_miss)
}
