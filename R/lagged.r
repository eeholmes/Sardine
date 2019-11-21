#' Create a k-lagged time series
#'
#' Helper function to create a lagged version of a vector.
#' 
#' @param x a vector
#' @param k the lag to use
#' 
#' @return A lagged version of the vector
#' 
#' @examples
#' lagged(1:10, 1)
#' lagged(1:10, -1)
#' lagged(1:10, 0)
lagged = function(x, k){
  if(k>=0) return(c(rep(NA,k),x[1:(length(x)-k)]))
  if(k<0) return(c(x[(1-k):length(x)],rep(NA,-k)))
}
