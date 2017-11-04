#read in the precipitation data
# code assumes working directory is root for package
covfiles=c(
  "precipitation_gpcp.csv",
  "precipitation_TRMM.csv",
  "precip_kerala.csv"
  )
years=1956:as.numeric(format(Sys.Date(),"%Y"))
monthly_cov = data.frame(Year = rep(years,each=12), Month=rep(1:12,length(years)))
for(fil in covfiles){
  dat=read.csv(paste("inst/extdata/raw data files and code/",fil,sep=""))
  covs=colnames(dat)[-c(1,2)]
  for(icol in covs) monthly_cov[[icol]]=NA
  for(i in 1:dim(dat)[1])
    monthly_cov[monthly_cov$Year==dat$Year[i] & monthly_cov$Month==dat$Month[i],covs]=
    dat[i,covs]
}
bad=apply(monthly_cov[,3:dim(monthly_cov)[2]],1,function(x){all(is.na(x))})
monthly_cov=monthly_cov[!bad,]
precip=monthly_cov
save(precip, file="data/precip.rdata")