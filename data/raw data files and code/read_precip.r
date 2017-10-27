#read in the precipitation data
covfiles=c(
  "precipitation_gpcp.csv",
  "precipitation_TRMM.csv",
  "precip_kerala.csv"
  )
years=1956:as.numeric(format(Sys.Date(),"%Y"))
monthly_cov = data.frame(Year = rep(years,each=12), Month=rep(1:12,length(years)))
for(fil in covfiles){
  dat=read.csv(fil)
  covs=colnames(dat)[-c(1,2)]
  for(icol in covs) monthly_cov[[icol]]=NA
  for(i in 1:dim(dat)[1])
    monthly_cov[monthly_cov$Year==dat$Year[i] & monthly_cov$Month==dat$Month[i],covs]=
    dat[i,covs]
}
bad=apply(monthly_cov[,3:dim(monthly_cov)[2]],1,function(x){all(is.na(x))})
monthly_cov=monthly_cov[!bad,]
precip=monthly_cov
save(precip, file="../precip.rdata")