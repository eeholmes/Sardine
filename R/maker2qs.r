#' Get R2 values for linear regression of log catch anomalies vs covariates
#' 
#' This function gets the R2 values for a linear regression of 
#' log catch anomaly ~ covariate anomalies at lags of 0 to 10. Covariates are turned into 
#' anomalies by removing year and qtr effect and then lagged and z-scored.
#' Catch anomalies are logged and z-scored.  Note: this is an old function and not used after I
#' switched to using GAMs.
#' 
#' @param region region ("Kerala", "Karnataka", "Goa") in quotes.
#' @param covname name of the covariate.  Must be a colname in seio_covariates_qtr.  If one of the covariates
#'  is from the boxes, then specify the part of the name in front of the number.  For example "SST.".
#' @param boxes for covariate from a box, the box number or numbers to use
#' @param rm.trend remove year effect from catch and covariates
#' @param rm.season remove season effect from catch and covariates
#' 
#' @return A data.frame of R2's for each lag 0 to 10.
#'
#' @examples
#' maker2qs(region="Kerala", covname="SST.", boxes=5)
#' 
#' @keywords internal
maker2qs=function(region="Kerala", covname="Precip", boxes=1:14, rm.trend=TRUE, rm.season=TRUE){
  dat.sub=makedat(region=region, covname=covname, rm.trend=rm.trend, rm.season=rm.season)
  covnames=paste(rep(covname,each=length(boxes)),boxes,sep="")
  covnames=covnames[covnames%in%colnames(dat.sub)]
  precipcols=which(colnames(dat.sub)%in%covnames)
  rsqs=c()
  for(lag in 0:10){
    dat3=dat.sub[,c(region,"Year","Qtr")]
    for(j in lag){
      tmpprecip=dat.sub[,precipcols,drop=FALSE]
      for(i in 1:length(precipcols)){
        tmpprecip[,i]=lagged(dat.sub[,precipcols[i]],j)
        tmpprecip[,i]=(tmpprecip[,i]-mean(tmpprecip[,i],na.rm=TRUE))/sqrt(var(tmpprecip[,i],na.rm=TRUE))
      }
      newcols=paste(covnames,"lag",j,sep="")
      colnames(tmpprecip)=newcols
      dat3=cbind(dat3,tmpprecip)
    }
    
    fit = lm(Kerala ~ .-Year-Qtr, data = dat3)
    rsqs=rbind(rsqs,c(summary(fit)$r.squared, summary(fit)$adj.r.square,summary(fit)$df[2]))
  }
  return(rsqs)
}
