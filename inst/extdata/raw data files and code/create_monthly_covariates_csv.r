#Code assumes you are at the package root as wd

#Put all the covariate data into one data frame
# Satellite_covariates.csv created by create_satellite_master_file.r in get_satellite_data folder
covfiles=c(
  "Satellite_covariates.csv",
  "precipitation_gpcp.csv",
  "precipitation_TRMM.csv",
  "enso.csv",
  "precip_kerala.csv",
  "tide_mon.csv")
current.year = 2019
years=1956:current.year

#set up the data frame
monthly_cov = data.frame(Year = rep(years,each=12), Month=rep(1:12,length(years)))

#go through all covariate csv files and add the data
for(fil in covfiles){
  dat=read.csv(paste("inst/extdata/raw data files and code/",fil,sep=""))
  covs=colnames(dat)[-c(1,2)]
  for(icol in covs) monthly_cov[[icol]]=NA
  for(i in 1:dim(dat)[1])
    monthly_cov[monthly_cov$Year==dat$Year[i] & monthly_cov$Month==dat$Month[i],covs]=
          dat[i,covs]
}

#Create anomalies for all the covariates
dat=monthly_cov
dat$Month=as.factor(dat$Month)
cov.names=colnames(dat)[-c(1,2)]
for(covn in cov.names){
  resp=dat[[covn]]
  if(substr(covn,1,3)=="CHL")
    resp=log(dat[[covn]])
  pred=dat$Month
  fit=lm(resp~-1+pred)
  res=residuals(fit)
  row.res=as.numeric(names(res))
  anom=rep(NA,length(resp))
  anom[row.res]=res
  anom.name=paste("anom.",covn,sep="")
  if(substr(covn,1,3)=="CHL"){
    anom.name=paste("anom.log.",covn,sep="")
    log.name=paste("log.",covn,sep="")
    dat[log.name]=resp
  }
  dat[anom.name]=anom
}

fil="monthly_covariates_with_anomalies.csv"
filename=paste("inst/extdata/raw data files and code/",fil,sep="")
write.csv(dat, file=filename,row.names=FALSE)

seio_covariates_mon = dat
save(seio_covariates_mon, file="data/seio_covariates_mon.rdata")


