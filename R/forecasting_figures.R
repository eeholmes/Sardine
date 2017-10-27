# ################  Forecasting Tests ########################################
# #assumes I am at Analyses
# basedir=dirname(getwd())
# basedir=paste(basedir,"/Forecasting/",sep="")
# 
# jpeg(filename=paste(basedir,"forecast performance.jpg",sep=""))
# 
# par(mfrow=c(2,2))
# covname=c("CHL.")
# boxes=c(5)
# lag=8
# qtr.cov=2
# 
# tmp=makedat(covname,boxes=boxes,
#             rm.trend=FALSE,rm.season=TRUE,lag=lag)
# tmp2=makedat(covname,boxes=boxes,
#              rm.trend=FALSE,rm.season=TRUE,lag=0)
# tmp2=cbind(tmp2,prevyrcov=NA)
# for(yr in (min(tmp2$Year)+1):max(tmp2$Year)){
#   tmp2$prevyrcov[tmp2$Year==yr]=tmp2$CHL.5[tmp2$Year==(yr-1) & tmp2$Qtr==qtr.cov]
# }
# tmp1=makedat(covname,boxes=boxes,
#              rm.trend=FALSE,rm.season=FALSE,lag=c(0))
# tmp$Kerala=tmp1$Kerala
# tmp=cbind(tmp,Kerala.last=lagged(tmp1$Kerala,4),prevyrcov=tmp2$prevyrcov)
# original.dat=tmp
# for(jit in list(c(0,0),c(1,1),c(2,2),c(0,2))){
#   #tmp=na.omit(tmp)
#   tmp=original.dat[original.dat$Year>=(2005+jit[1]),] #first year with chl data at lag 8
#   tmp=tmp[tmp$Year<=(2011+jit[2]),] #first year with chl data at lag 8
# 
#   #plot(c(9,12),c(9,12),type="l",xlab="Actual catch", ylab="Predicted")
#   plot(c(15,21),c(0.2,1.2),type="n",ylab="RMSE (root mean sq error)",xlab="number of training qtrs")
#   text(15.5,.2,"n = ")
#   rmse.last=c()
#   for(n in c(16:20)){ #qtrs for training; 4 to 7 years
#     pred.covprev=predm=predo=obs=pred.level=pred.qtr=pred.ets=c() #store fits here
#     for(i in 1:(dim(tmp)[1]-n-1)){ #start for the training windows
#       fit=lm(Kerala~.-Year-Kerala.last,data=tmp[(i+1):(i+n),]) #cov + qtr no year no last
#       predm=c(predm,(predict(fit, newdata=tmp[i+n+1,]))) #one prediction
#       fit=lm(Kerala~.-Year+prevyrcov,data=tmp[(i+1):(i+n),]) #cov + qtr no year no last
#       pred.covprev=c(pred.covprev,(predict(fit, newdata=tmp[i+n+1,]))) #one prediction
#       fit=lm(Kerala~1,data=tmp[(i+1):(i+n),]) #level model
#       pred.level=c(pred.level,(predict(fit, newdata=tmp[i+n+1,])))
#       fit=lm(Kerala~Year+Qtr,data=tmp[(i+1):(i+n),]) #season model
#       pred.qtr=c(pred.qtr,(predict(fit, newdata=tmp[i+n+1,])))
#       predo=c(predo,(tmp$Kerala[i+n+1-4])) #prev year
#       obs=c(obs,(tmp$Kerala[i+n+1]))
#       fit=ets(ts(tmp$Kerala[(i+1):(i+n)],start=tmp$Year[(i+1)],frequency=4),model="ANA")
#       pred.ets=c(pred.ets,forecast(fit,h=1)$mean)
#     }
#     rmse.covprev=sqrt(mean((pred.covprev-obs)^2,trim=.1))
#     rmsem=sqrt(mean((predm-obs)^2,trim=.1))
#     rmse.level=sqrt(mean((pred.level-obs)^2,trim=.1))
#     rmse.qtr=sqrt(mean((pred.qtr-obs)^2,trim=.1))
#     rmseo=sqrt(mean((predo-obs)^2,trim=.1))
#     rmse.last=c(rmse.last,rmseo) #hold for plotting
#     rmse.ets=sqrt(mean((pred.ets-obs)^2,trim=.1))
#     points(rep(n,6),c(rmse.covprev,rmse.ets,rmsem,rmse.level,rmse.qtr,rmseo),pch=1:6)
#     text(n,.2,length(predo))
#   }
#   lines(16:20,rmse.last,lwd=2)
#   legend("topleft",c(
#     paste("chl qtr 2 last yr",round(rmse.covprev,digits=2)),
#     paste("ets model",round(rmse.ets,digits=2)),
#     paste("chl 2 yr prior",round(rmsem,digits=2)),
#     paste("average of training data",round(rmse.level,digits=2)),
#     paste("year + quarter",round(rmse.qtr,digits=2)),
#     paste("last year's catch",round(rmseo,digits=2))),pch=1:6,cex=.75)
#   title(paste("forecast performance",2005+jit[1],"to", 2011+jit[2]))
# }
# 
# dev.off()
# 
# ################  Forecasting Tests ########################################
# basedir="C:/Users/Eli.Holmes/Dropbox/__MyFiles Archive/TALKS/QuanFishSeminar/2016/figures/"
# jpeg(filename=paste(basedir,"forecast performance large.jpg",sep=""))
# 
# par(mfrow=c(1,1))
# covname=c("CHL.")
# boxes=c(5)
# lag=8
# qtr.cov=2
# 
# tmp=makedat(covname,boxes=boxes,
#             rm.trend=FALSE,rm.season=TRUE,lag=lag)
# tmp2=makedat(covname,boxes=boxes,
#              rm.trend=FALSE,rm.season=TRUE,lag=0)
# tmp2=cbind(tmp2,prevyrcov=NA)
# for(yr in (min(tmp2$Year)+1):max(tmp2$Year)){
#   tmp2$prevyrcov[tmp2$Year==yr]=tmp2$CHL.5[tmp2$Year==(yr-1) & tmp2$Qtr==qtr.cov]
# }
# tmp1=makedat(covname,boxes=boxes,
#              rm.trend=FALSE,rm.season=FALSE,lag=c(0))
# tmp$Kerala=tmp1$Kerala
# tmp=cbind(tmp,Kerala.last=lagged(tmp1$Kerala,4),prevyrcov=tmp2$prevyrcov)
# original.dat=tmp
# for(jit in list(c(0,2))){
#   #tmp=na.omit(tmp)
#   tmp=original.dat[original.dat$Year>=(2005+jit[1]),] #first year with chl data at lag 8
#   tmp=tmp[tmp$Year<=(2011+jit[2]),] #first year with chl data at lag 8
# 
#   #plot(c(9,12),c(9,12),type="l",xlab="Actual catch", ylab="Predicted")
#   plot(c(15,21),c(0.2,1.2),type="n",ylab="RMSE (root mean sq error)",xlab="number of training qtrs")
#   text(15.5,.2,"n = ")
#   rmse.last=c()
#   for(n in c(16:20)){ #qtrs for training; 4 to 7 years
#     pred.covprev=predm=predo=obs=pred.level=pred.qtr=pred.ets=c() #store fits here
#     for(i in 1:(dim(tmp)[1]-n-1)){ #start for the training windows
#       fit=lm(Kerala~.-Year-Kerala.last,data=tmp[(i+1):(i+n),]) #cov + qtr no year no last
#       predm=c(predm,(predict(fit, newdata=tmp[i+n+1,]))) #one prediction
#       fit=lm(Kerala~.-Year+prevyrcov,data=tmp[(i+1):(i+n),]) #cov + qtr no year no last
#       pred.covprev=c(pred.covprev,(predict(fit, newdata=tmp[i+n+1,]))) #one prediction
#       fit=lm(Kerala~1,data=tmp[(i+1):(i+n),]) #level model
#       pred.level=c(pred.level,(predict(fit, newdata=tmp[i+n+1,])))
#       fit=lm(Kerala~Year+Qtr,data=tmp[(i+1):(i+n),]) #season model
#       pred.qtr=c(pred.qtr,(predict(fit, newdata=tmp[i+n+1,])))
#       predo=c(predo,(tmp$Kerala[i+n+1-4])) #prev year
#       obs=c(obs,(tmp$Kerala[i+n+1]))
#       fit=ets(ts(tmp$Kerala[(i+1):(i+n)],start=tmp$Year[(i+1)],frequency=4),model="ANA")
#       pred.ets=c(pred.ets,forecast(fit,h=1)$mean)
#     }
#     rmse.covprev=sqrt(mean((pred.covprev-obs)^2,trim=.1))
#     rmsem=sqrt(mean((predm-obs)^2,trim=.1))
#     rmse.level=sqrt(mean((pred.level-obs)^2,trim=.1))
#     rmse.qtr=sqrt(mean((pred.qtr-obs)^2,trim=.1))
#     rmseo=sqrt(mean((predo-obs)^2,trim=.1))
#     rmse.last=c(rmse.last,rmseo) #hold for plotting
#     rmse.ets=sqrt(mean((pred.ets-obs)^2,trim=.1))
#     points(rep(n,6),c(rmse.covprev,rmse.ets,rmsem,rmse.level,rmse.qtr,rmseo),pch=1:6)
#     text(n,.2,length(predo))
#   }
#   lines(16:20,rmse.last,lwd=2)
#   legend("topleft",c(
#     paste("chl qtr 2 last yr",round(rmse.covprev,digits=2)),
#     paste("ets model",round(rmse.ets,digits=2)),
#     paste("chl 2 yr prior",round(rmsem,digits=2)),
#     paste("average of training data",round(rmse.level,digits=2)),
#     paste("year + quarter",round(rmse.qtr,digits=2)),
#     paste("last year's catch",round(rmseo,digits=2))),pch=1:6,cex=1.25)
#   title(paste("forecast performance",2005+jit[1],"to", 2011+jit[2]))
# }
# 
# dev.off()
# 
# basedir="C:/Users/Eli.Holmes/Dropbox/__MyFiles Archive/TALKS/QuanFishSeminar/2016/figures/"
# jpeg(filename=paste(basedir,"forecast performance predicted versus observed.jpg",sep=""),
#      width=800,height=400)
# 
# par(mfrow=c(1,2))
# plot(obs,pred.ets,xlab="obs log qtrly catch",ylab="exp smoothing model prediction")
# plot(obs,predm,pch=2,xlab="obs log qtrly catch",ylab="multiple regression models with covariates")
# points(obs,pred.covprev,pch=3)
# 
# dev.off()
# 
# ### Make a plot of a ets fit
# 
# basedir="C:/Users/Eli.Holmes/Dropbox/__MyFiles Archive/TALKS/QuanFishSeminar/2016/figures/"
# jpeg(filename=paste(basedir,"ets fit.jpg",sep=""))
# #fit to Kerala
# dat4=log(window(ts(dat$Kerala,start=1975,frequency=4),2000,c(2014,4)))
# mod=ets(dat4,model="ANA")
# plot(mod)
# dev.off()
