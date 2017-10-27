forecast_figure1 = function(covname="Precip",qtr.cov=2, boxes=5, last.data=-1){

#Precip in qtr of catch; DESEASONED
tmp2=makedat(region="Kerala", covname=covname, boxes=boxes, rm.trend=FALSE, rm.season=TRUE, lag=0)
tmp2=cbind(tmp2, prevyrcov=NA)

#Precip in qtr 2 of previous yr BUT yr is qtr 3, 4, 1, 2
for(yr in (min(tmp2$Year)+1):max(tmp2$Year)){
      half2=tmp2[[paste(covname,boxes,sep="")]][tmp2$Year==yr & tmp2$Qtr==qtr.cov]
      half1=tmp2[[paste(covname,boxes,sep="")]][tmp2$Year==(yr-1) & tmp2$Qtr==qtr.cov]
      tmp2$prevyrcov[tmp2$Year==yr]=c(half1,half1,half2,half2)
}
#catch data without season removed
tmp1=makedat(region="Kerala",covname=covname,boxes=boxes,rm.trend=FALSE,rm.season=FALSE,lag=0)
tmp=cbind(tmp2, Kerala.last=lagged(tmp1$Kerala,4))
tmp$Kerala=tmp1$Kerala
original.dat=tmp
#for(jit in list(c(0,0),c(1,1),c(2,2),c(0,2))){
for(jit in list(c(0,0))){
    #tmp=na.omit(tmp)
  tmp=original.dat[original.dat$Year>=(1980+jit[1]),] #first year with prev yr precip data

  #plot(c(9,12),c(9,12),type="l",xlab="Actual catch", ylab="Predicted")
  plot(c(15,21),c(0.2,1.2),type="n",ylab="RMSE (root mean sq error)",xlab="number of training qtrs")
  text(15.5,.2,"n = ")
  rmse.last=c()
  for(n in c(16:20)){ #qtrs for training; 4 to 7 years
    pred.covprev=predm=predo=obs=pred.level=pred.qtr=pred.ets=c() #store fits here
    for(i in 1:(dim(tmp)[1]-n+last.data)){ #start for the training windows
      fit=lm(Kerala~.-Kerala.last-prevyrcov,data=tmp[(i+1):(i+n),]) #year + cov + qtr no year no last
      pred.cov=c(predm,(predict(fit, newdata=tmp[i+n-last.data,]))) #one prediction
      fit=lm(Kerala~Year+Qtr+prevyrcov,data=tmp[(i+1):(i+n),]) #prevcov + qtr no year
      pred.covprev=c(pred.covprev,(predict(fit, newdata=tmp[i+n-last.data,]))) #one prediction
      fit=lm(Kerala~1,data=tmp[(i+1):(i+n),]) #level model
      pred.level=c(pred.level,(predict(fit, newdata=tmp[i+n-last.data,])))
      fit=lm(Kerala~Year+Qtr,data=tmp[(i+1):(i+n),]) #trend+season model
      pred.qtr=c(pred.qtr,(predict(fit, newdata=tmp[i+n-last.data,])))
      predo=c(predo,(tmp$Kerala[i+n-last.data-4])) #prev year
      obs=c(obs,(tmp$Kerala[i+n-last.data])) #current year
      fit=ets(ts(tmp$Kerala[(i+1):(i+n)],start=tmp$Year[(i+1)],frequency=4),model="ANA")
      pred.ets=c(pred.ets,forecast(fit,h=-last.data)$mean[-last.data]) #get last forecast
    }
    rmse.covprev=sqrt(mean((pred.covprev-obs)^2,trim=.1))
    rmse.cov=sqrt(mean((pred.cov-obs)^2,trim=.1))
    rmse.level=sqrt(mean((pred.level-obs)^2,trim=.1))
    rmse.qtr=sqrt(mean((pred.qtr-obs)^2,trim=.1))
    rmseo=sqrt(mean((predo-obs)^2,trim=.1))
    rmse.last=c(rmse.last,rmseo) #hold vector for plotting
    rmse.ets=sqrt(mean((pred.ets-obs)^2,trim=.1))
    points(rep(n,5),c(rmseo, rmse.level, rmse.qtr, rmse.covprev, rmse.ets),pch=c(NA,2,3,5,6))
    text(n,.2,length(predo))
  }
  lines(16:20,rmse.last,lwd=2)
  legend(18,.6,c(
    paste("last year's catch",round(rmseo,digits=2)),
    paste("average of training data",round(rmse.level,digits=2)),
    paste("year + quarter",round(rmse.qtr,digits=2)),
    paste("precip qtr", qtr.cov, "last yr",round(rmse.covprev,digits=2)),
    paste("ets model",round(rmse.ets,digits=2))
    ),pch=c(NA,2,3,5,6),lty=c(1,NA,NA,NA,NA),cex=.75)
  title(paste("forecast performance",1980+jit[1],"to", 2013+jit[2]))
}

}
