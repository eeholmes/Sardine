#' Leave one out cross-validation on gam object
#'
#' Helper function to do a LOOCV on a gam model
#' 
#' @param mod A model returned by a gam fit
#' 
#' @return A list with predictions (fitted), actual, errors (fitted-actual), MAE and RMSE.
#' 
#' @examples
#' # some simulated data with one cov
#' dat <- mgcv::gamSim(6,n=100,scale=.5)[,1:2]
#' m <- mgcv::gam(y~s(x0), data=dat)
#' loogam(m)$MAE
loogam <- function(mod){
  dat <- mod$model
  mod.formula <- mod$formula
  pred <- NULL
  for(i in 1:dim(dat)[1]){
    m <- gam(mod.formula, dat=dat[-1*i,])
    pred <- c(pred, predict(m, newdata=dat[i,]))
  }
  err <- pred-dat[,1]
  list(pred=pred, actual=dat[,1], err=err, MAE=mean(abs(err)), RMSE=sqrt(mean(err^2)))
}