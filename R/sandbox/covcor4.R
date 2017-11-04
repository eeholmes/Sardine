  require(stringr)
    respdat=data.frame(
      spawners0=oilsardine_qtr[[reg]][oilsardine_qtr$Qtr==Qtr]
      )
    catch0=filter(oilsardine_qtr[[reg]],c(1,1,1,1),sides=1)[seq(6,dim(oilsardine_qtr)[1],4)]
    respdat$Catch0 = c(catch0,NA)
    respdat=log(respdat)
    
  covnames=c(
    "log.CHL.3","log.CHL.4","log.CHL.5",
    "log.CHL.3","log.CHL.4","log.CHL.5",
    "log.CHL.3","log.CHL.4","log.CHL.5",
    "SST.UPW.3","SST.UPW.4","SST.UPW.5",
    "SST.UPW.3","SST.UPW.4","SST.UPW.5",
    "SST.3","SST.4","SST.5",
    "SST.3","SST.4","SST.5",
    "SST.3","SST.4","SST.5",
    "precip.gpcp.kerala", "precip.gpcp.kerala")
  covmon=list(
     6:7, 6:7, 6:7,
     7:9,7:9,7:9,
     7:12, 7:12, 7:12,
     7:12, 7:12, 7:12,
     6:7,6:7,6:7,
     9:12,9:12,9:12,
     6:7,6:7,6:7,
     7:9,7:9,7:9,
     4:5,6:7)
  n=2 #max lag in cov to use
  for(i in 1:length(covnames)){
    covname=covnames[i]
    mon=covmon[[i]]
      varname=paste(covname,".mon",mon[1],"to",mon[length(mon)],".0",sep="")
      covdat=tapply(seio_covariates_mon[[covname]],seio_covariates_mon$Year,function(x){mean(x[mon],na.rm=TRUE)})
      respdat[[varname]]=covdat
  }
  #add lags
  for(i in colnames(respdat)){
    name=paste(str_sub(i, 1, str_length(i)-1),"1",sep="")
    respdat[[name]]=c(NA,respdat[[i]][1:(dim(respdat)[1]-1)])
    name=paste(str_sub(i, 1, str_length(i)-1),"2",sep="")
    respdat[[name]] = c(NA,NA,respdat[[i]][1:(dim(respdat)[1]-2)])
  }
  respdat$Year=oilsardine_qtr$Year[oilsardine_qtr$Qtr==Qtr]
  #add Catch - spawners
  respdat$nspawners0 = respdat$Catch0 - respdat$spawners0
  respdat$nspawners1 = respdat$Catch1 - respdat$spawners1
  respdat$nspawners2 = respdat$Catch2 - respdat$spawners2

m0=gam(spawners0 ~ 
         Year + Catch1 + 
         precip.gpcp.kerala.mon6to7.0 +
         precip.gpcp.kerala.mon4to5.0 +
         SST.4.mon7to9.0 +
         SST.UPW.4.mon6to7.0, data=respdat)
         

#Precipitation Models
#Model 1 Monsoon precip
b1=gam(spawners0 ~ 
         Catch1 + 
         precip.gpcp.kerala.mon6to7.0 +
         , data=respdat)
b0 = gam(spawners0 ~ Catch1 + I(Catch1^2), data=b1$model)
c(AIC(b0),AIC(b1))
anova(b0,b1, test="F")

#Early Precipitation
b2=gam(spawners0 ~ 
         s(Catch1, sp=0.2) + 
         s(precip.gpcp.kerala.mon4to5.0, sp=0.6), data=respdat)
c(AIC(b0),AIC(b1),AIC(b2))
anova(b0,b1,b2,test="F")


#Chlorophyll; not enough data for spline for catch
b1=gam(spawners0 ~ 
         Catch1 + I(Catch1^2) +
         s(log.CHL.4.mon6to7.0, sp=0.6), data=respdat)
b0 = gam(spawners0 ~ Catch1 + I(Catch1^2), data=b1$model)
c(AIC(b1),AIC(b0))
anova(b0,b1,test="F")

#SST.4
b1=gam(spawners0 ~ 
         Catch1 + 
         s(SST.4.mon7to9.0, sp=0.6), data=respdat)
b0 = gam(spawners0 ~ Catch1, data=b1$model)
c(AIC(b1),AIC(b0))
anova(b0,b1,test="F")


#Upwelling SST.4 or 3; 
b1=gam(spawners0 ~ 
         s(Catch1, sp=0.2) + 
         s(SST.UPW.4.mon6to7.0, sp=0.6), data=respdat)
b0 = gam(spawners0 ~ s(Catch1, sp=0.2), data=b1$model)
c(AIC(b1),AIC(b0))
anova(b0,b1,test="F")

