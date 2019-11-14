#' AICc from gam object
#'
#' Helper function compute AICc from a gam object
#' 
#' @param object A model returned by a gam fit
#' 
#' @return an AICc value
#' 
#' @examples
#' # some simulated data with one cov
#' dat <- mgcv::gamSim(6,n=20,scale=.5)[,1:2]
#' m <- mgcv::gam(y~s(x0), data=dat)
#' AICcgam(m)
AICcgam <- function(object){
  k <- attributes(mgcv::logLik.gam(object))$df
  aic <- object$aic
  n <- nrow(object$model)
  return(aic+(2*k^2+2*k)/(n-k-1))
}