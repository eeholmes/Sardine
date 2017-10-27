#read in the precipitation over land data
fil="Area_Weighted_Monthly_Seasonal_And_Annual_Rainfall_0.csv"
dat=read.csv(fil)
years=unique(dat$YEAR)
precip_kerala = data.frame(Year = rep(years,each=12), Month=rep(1:12,length(years)), Precip.Kerala=NA)

dat=dat[,-1]
dat=dat[dat$SD_Name=="KERALA",]
for(yr in years){
  for(mon in 1:12){
    precip_kerala$Precip.Kerala[precip_kerala$Year==yr & precip_kerala$Month==mon]=
      dat[dat$YEAR==yr,2+mon]
  }
}
write.csv(precip_kerala, file="precip_kerala.csv",row.names=FALSE)
save(precip_kerala, file="../precip_kerala.rdata")