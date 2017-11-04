##Predicting the catch anomalies
##What covariates do best at explaining catch anomalies?
covcor = function(reg="Kerala", Qtr=3, TT=10, covname="CHL.3", months=1:3, year=0,type="log catch"){
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
}


b1=gam(spawners0 ~ 
         Catch1 + 
         s(precip.gpcp.kerala.mon4to5.0) + s(precip.gpcp.kerala.mon6to7.0) +
         s(SST.UPW.5.mon7to12.0, sp=0.6) + s(SST.UPW.5.mon7to12.1, sp=0.6) +
         s(log.CHL.4.mon7to12.1, sp=0.6), data=respdat)
summary(b1)
plot(b1)


b1=gam(spawners0 ~ 
         Catch1, data=respdat)
summary(b1)


#Precipitation
b1=gam(spawners0 ~ 
         Catch1 + 
         s(precip.gpcp.kerala.mon6to7.0), data=respdat)
summary(b1)
b2 = gam(spawners0 ~ Catch1, data=b1$model)
AIC(b2)

plot(b1)

#Early Precipitation
b1=gam(spawners0 ~ 
         Catch1 + 
         s(precip.gpcp.kerala.mon4to5.0), data=respdat)
summary(b1)
b2 = gam(spawners0 ~ Catch1, data=b1$model)
c(AIC(b1),AIC(b2))
anova(b1,b2,test="F")


#Chlorophyll
b1=gam(spawners0 ~ 
         Catch1 + 
         s(log.CHL.4.mon6to7.0, sp=0.6), data=respdat)
summary(b1)
b2 = gam(spawners0 ~ Catch1, data=b1$model)
c(AIC(b1),AIC(b2))


#SST.4
b1=gam(spawners0 ~ 
         s(Catch1, sp=0.2) + 
         s(Catch2, sp=0.2) +
         s(SST.4.mon7to9.0, sp=0.6), data=respdat)
b2=gam(spawners0 ~ 
         s(Catch1, sp=0.2) + 
         s(SST.4.mon7to9.0, sp=0.6), data=b1$model)
b3 = gam(spawners0 ~ s(Catch1, sp=0.2), data=b1$model)
b4 = gam(spawners0 ~ s(Catch1, sp=0.2) + s(Catch2, sp=0.2), data=b1$model)
c(AIC(b1) ,AIC(b2), AIC(b3), AIC(b4))
anova.gam(b1, b2, test="F")
anova.gam(b1b, b3, test="F")


#Upwelling SST.4
b1=gam(spawners0 ~ 
         Catch1 + 
         s(SST.UPW.3.mon6to7.0, sp=0.6), data=respdat)
summary(b1)
b2 = gam(spawners0 ~ Catch1, data=b1$model)
c(AIC(b1),AIC(b2))


library(mgcv)
library(ggplot2)
b1=gam(Catch0 ~ Catch1 + s(SST.UPW.5.mon9to12.0, sp=0.6), data=respdat[-39,])
summary(b1)
plot(b1)

b1=gam(Catch0 ~ Catch1 + s(SST.UPW.4.mon1to3.0, sp=0.6), data=respdat[-39,])
summary(b1)
plot(b1)

b1=gam(Catch0 ~ Catch1 + s(SST.4.mon7to12.1, sp=0.6), data=respdat[-39,])
summary(b1)
plot(b1)

b1=gam(Catch0 ~ Catch1 + s(SST.3.mon9to12.0, sp=0.6) + s(SST.3.mon1to3.0, sp=0.6), data=respdat[-39,])
summary(b1)
plot(b1)

#bad
b1=gam(Catch0 ~ Catch1 + s(log.CHL.3.mon1to3.1, sp=0.6), data=respdat[-39,])
summary(b1)
plot(b1)

#hmm, ok, oddly when use this Catch1 is not important
b1=gam(Catch0 ~ s(log.CHL.3.mon7to9.0, sp=0.6), data=respdat[-39,])
summary(b1)
plot(b1)
plot(b1$model$Catch0, b1$model$log.CHL.3.mon7to9.0)

#bad
b1=gam(Catch0 ~ Catch1 + s(log.CHL.4.mon7to9.1, sp=0.6), data=respdat[-39,])
summary(b1)
plot(b1)
plot(b1$model$Catch0, b1$model$log.CHL.3.mon7to9.0)


#oddly when use this Catch1 is not important
b1=gam(Catch0 ~ Catch1 + s(log.CHL.3.mon7to9.0, sp=0.6), data=respdat[-39,])
summary(b1)
plot(b1)
plot(b1$model$Catch0, b1$model$log.CHL.3.mon7to9.0)

#ok 
b1=gam(Catch0 ~ Catch1 + s(SST.4.mon1to3.0, sp=0.6), data=respdat[-39,])
summary(b1)
plot(b1)

#good and makes sense biologically
b1=gam(Catch0 ~ Catch1 + s(SST.3.mon9to12.0, sp=0.6), data=respdat[-39,])
summary(b1)
plot(b1)

#Not hot
b1=gam(Catch0 ~ Catch1, data=respdat[-39,])
summary(b1)
plot(b1)
b1=gam(Catch0 ~ Catch1 + s(SST.4.mon7to12.0, sp=0.6), data=respdat[-39,])
summary(b1)
plot(b1)

b1=gam(Catch0 ~ Catch1 + SST.UPW.4.mon1to3.0, data=respdat[-39,])
summary(b1)
plot(b1)

p <- predict(b1, type="lpmatrix")
beta <- coef(b1)[grepl("SST.UPW.5.mon9to12.0", names(coef(b1)))]
s <- p[,grepl("SST.UPW.5.mon9to12.0", colnames(p))] %*% beta
ggplot(data=cbind.data.frame(s, b1$model$SST.UPW.5.mon9to12.0), aes(x=b1$model$SST.UPW.5.mon9to12.0[-39], y=s)) + geom_line()



b1=gam(Catch0 ~ Catch1 + s(SST.UPW.4.mon1to3.0, sp=0.6), data=respdat[-39,])
summary(b1)
plot(b1)

b1=gam(Catch0 ~ Catch1 + s(SST.UPW.4.mon1to3.0, sp=0.6) + precip.gpcp.kerala.mon6to6.0, data=respdat)
summary(b1)
plot(b1)

b1=gam(Catch0 ~ s(SST.UPW.5.mon9to12.0, sp=0.6), data=respdat)
summary(b1)
plot(b1)

b1=gam(Catch0 ~ Catch1, data=respdat)
summary(b1)
plot(b1)

b1=gam(Catch0 ~ spawners1 + s(SST.3.mon7to12.0, sp=0.6), data=respdat)
summary(b1)
plot(b1)

b1=gam(Catch0 ~ spawners1 + s(SST.13.mon3to6.0, sp=0.6), data=respdat)
summary(b1)
plot(b1)


b1=gam(Catch0 ~ s(SST.UPW.4.mon9to12.0, sp=0.6), data=respdat)
summary(b1)
plot(b1)

b1=gam(SST.UPW.4.mon7to9.0 ~ SST.UPW.4.mon1to3.0, data=respdat)
summary(b1)
plot(b1)