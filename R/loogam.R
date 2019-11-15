#' Leave one out cross-validation on gam object
#'
#' Helper function to do a LOOCV on a gam model
#' 
#' @param mod A model returned by a gam fit
#' @param k samples. k=1 is LOO, k=2 is LTO
#' 
#' @return A list with predictions (fitted), actual, errors (fitted-actual), MAE and RMSE.
#' 
#' @examples
#' # some simulated data with one cov
#' dat <- mgcv::gamSim(6,n=100,scale=.5)[,1:2]
#' m <- mgcv::gam(y~s(x0), data=dat)
#' loogam(m)$MAE
loogam <- function(mod, k=1, n=100){
  dat <- mod$model
  mod.formula <- mod$formula
  pred <- actual <- NULL
  val <- utils::combn(dim(dat)[1], k)
  if(n < ncol(val)) val <- val[,sample(ncol(val), n)]
  for(j in 1:ncol(val)){
    i <- val[,j]
    m <- mgcv::gam(mod.formula, data=dat[-1*i,,drop=FALSE])
    pred <- c(pred, mgcv::predict.gam(m, newdata=dat[i,,drop=FALSE]))
    actual <- c(actual, dat[i,1])
  }
  err <- pred - actual
  list(pred=pred, actual=actual, err=err, MAE=mean(abs(err)), RMSE=sqrt(mean(err^2)), MdAE=median(abs(err)))
}