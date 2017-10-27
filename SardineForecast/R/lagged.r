#How to include lagged variables
#define a lagged function
lagged = function(x, k){
  if(k>=0) return(c(rep(NA,k),x[1:(length(x)-k)]))
  if(k<0) return(c(x[(1-k):length(x)],rep(NA,-k)))
}