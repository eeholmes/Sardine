#read in the precipitation over land data
# assumes working directory is root for package

fil="Area_Weighted_Monthly_Seasonal_And_Annual_Rainfall_0.csv"
dat=read.csv(paste("inst/extdata/raw data files and code/",fil,sep=""))
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
fil="precip_kerala.csv"
filename=read.csv(paste("inst/extdata/raw data files and code/",fil,sep=""))
write.csv(precip_kerala, file=filename,row.names=FALSE)
