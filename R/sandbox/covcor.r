##Predicting the catch anomalies
##What covariates do best at explaining catch anomalies?
covcor = function(reg="Kerala", Qtr=3, TT=10, covname="CHL.3", months=1:3, year=0,type="log catch anomalies"){

  if(type=="log catch anomalies" | type=="catch anomalies"){
dat = data.frame(catch=oilsardine_qtr[[reg]], Year=oilsardine_qtr$Year, Qtr=oilsardine_qtr$Qtr)
if(type=="log catch anomalies") dat$catch=log(dat$catch)
TT=10
respdat=c()
startyear=min(dat$Year, na.rm=TRUE)
endyear=max(dat$Year, na.rm=TRUE)-TT
for(yr in startyear:endyear){
  dattmp=dat[dat$Year %in% yr:(yr+TT-1),]
  fit=lm(catch~Qtr-1, data=dattmp, na.action=na.exclude)
  respdat=rbind(respdat, c(yr, residuals(fit)))
}
colnames(respdat)=c("Year", paste("y",rep(1:TT,each=4),"q",rep(1:4,TT), sep=""))
respdat=as.data.frame(respdat)
  }
  if(type=="production per unit biomass"){
    dat = data.frame(catch=oilsardine_qtr[[reg]], Year=oilsardine_qtr$Year, Qtr=oilsardine_qtr$Qtr)
    if(type=="log catch anomalies") dat$catch=log(dat$catch)
    TT=10
    respdat=c()
    startyear=min(dat$Year, na.rm=TRUE)
    endyear=max(dat$Year, na.rm=TRUE)-TT
    for(yr in startyear:endyear){
      dattmp=dat[dat$Year %in% yr:(yr+TT-1),]
      fit=lm(catch~Qtr-1, data=dattmp, na.action=na.exclude)
      respdat=rbind(respdat, c(yr, residuals(fit)))
    }
    colnames(respdat)=c("Year", paste("y",rep(1:TT,each=4),"q",rep(1:4,TT), sep=""))
    respdat=as.data.frame(respdat)
  }
  
  
covnames=c("SSH.","CHL.","Wind.UPW.","SSTPH.UPW.","SSTAG.UPW.","PrecipTRMM","Precip.Kerala")
covnames="enso"
n=2 #max lag in cov to use
for(covname in covnames){
  for(ibox in c(1:13)){
    testcov=paste(covname,ibox,sep="")
    if(covname %in% c("Precip.Kerala","enso")) testcov=covname
    if(covname %in% c("Precip.Kerala","enso") & ibox>1) next
    if(covname %in% c("SSTPH.UPW.","SSTAG.UPW.") & ibox>5) next
    covdat=makedat(covname=covname, boxes=ibox, lag=0)
    pdf(file=paste("Covariate_figures/",testcov,".pdf",sep=""))
    par(mfrow=c(2,3))
    for(k in 1:6){
      corprecip=r2precip=c()
      for(yr in (startyear+n):endyear){ 
        #last training period year is yr; then use (yr+1):(yr+n+1) to test
        Yr.cov.yr0 = (yr:(yr+TT-1))-1 #prev year
        Yr.cov.yr1 = yr:(yr+TT-1) # current year
        if(k==1) filt=covdat$Year%in%Yr.cov.yr1&covdat$Qtr==4
        if(k==2) filt=covdat$Year%in%Yr.cov.yr1&covdat$Qtr==3
        if(k==3) filt=covdat$Year%in%Yr.cov.yr1&covdat$Qtr==2
        if(k==4) filt=covdat$Year%in%Yr.cov.yr1&covdat$Qtr==1
        if(k==5) filt=covdat$Year%in%Yr.cov.yr0&covdat$Qtr==4
        if(k==6) filt=covdat$Year%in%Yr.cov.yr0&covdat$Qtr==3
        covdat2=covdat[filt,]
        covdat2=covdat2[,testcov]
        tmp=c()
        for(j in c("q1","q2","q3","q4")){
          dat2=data.frame(y=unlist(anom[anom$Year==yr,str_detect(colnames(anom),j)]),x=covdat2)
          if(any(is.na(dat2$x))){ tmp=c(tmp,NA)
          }else{ fit=lm(y~x,data=dat2) 
          tmp=c(tmp,summary(fit)$r.squared)
          }
        }
        r2precip=rbind(r2precip,c(year=yr,tmp))
      }
      #matplot(corprecip[,1],corprecip[,2:5],type="l",ylim=c(-1,1))
      matplot(r2precip[,1],r2precip[,2:dim(r2precip)[2]],type="l",ylim=c(-.1,1),xlim=c(1980,2015),xlab="",ylab="r2")
      if(k==1) title(paste(testcov,"Q4 current year"))
      if(k==2) title(paste(testcov,"Q3 current year"))
      if(k==3) title(paste(testcov,"Q2 current year"))
      if(k==4) title(paste(testcov,"Q1 current year"))
      if(k==5) title(paste(testcov,"Q4 prev year"))
      if(k==6) title(paste(testcov,"Q3 prev year"))
      if(k==4) legend("topright", c("y1.3","y1.4","y2.1","y2.2"),col=1:4,lty=1:4)
    }
    dev.off()
    
  }
}
}