# This function gets the R2 values for a
# linear regression of log catch anomaly ~ covariate anomalies at different lags
# covariates are turned into anomalies by removing year and qtr effect
# covariate anomalies are lagged and z-scored
# catch anomalies are logged and z-scored

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
