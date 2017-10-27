# create Satellite_covariates.csv
# set get_satellite_data as wd

#set up file
years=1956:2017
monthly_cov = data.frame(Year = rep(years,each=12), Month=rep(1:12,length(years)))

#SST 
covfiles=c(
  "sea_surface_temperature-erdPH2sstamday-1981-2012.csv",
  "sst-erdAGsstamday-2003-2016.csv"
)
for(fil in covfiles){
  dat=read.csv(fil)
  covs=colnames(dat)[!(colnames(dat)%in%c("Year","Month","Dates"))]
  for(icol in covs) if(is.null(monthly_cov[[icol]])) monthly_cov[[icol]]=NA
  for(i in 1:dim(dat)[1])
    monthly_cov[monthly_cov$Year==dat$Year[i] & monthly_cov$Month==dat$Month[i],covs]=
    dat[i,covs]
}

#SSH
covfiles=c(
  "ssh-erdTAsshmday-1992-2010.csv"
)
for(fil in covfiles){
  dat=read.csv(fil)
  covs=colnames(dat)[!(colnames(dat)%in%c("Year","Month","Dates"))]
  for(icol in covs) if(is.null(monthly_cov[[icol]])) monthly_cov[[icol]]=NA
  for(i in 1:dim(dat)[1])
    monthly_cov[monthly_cov$Year==dat$Year[i] & monthly_cov$Month==dat$Month[i],covs]=
    dat[i,covs]
}

#CHL; uses sw for 1997 to 2002; then mh for 2003 onward
covfiles=c(
  "chlorophyll-erdSW1chlamday-1997-2010.csv",
  "chlorophyll-erdMH1chlamday-2003-2017.csv"
)
for(fil in covfiles){
  dat=read.csv(fil)
  covs=colnames(dat)[!(colnames(dat)%in%c("Year","Month","Dates"))]
  for(icol in covs) if(is.null(monthly_cov[[icol]])) monthly_cov[[icol]]=NA
  for(i in 1:dim(dat)[1])
    monthly_cov[monthly_cov$Year==dat$Year[i] & monthly_cov$Month==dat$Month[i],covs]=
    dat[i,covs]
}

#wind.upwelling
covfiles=c(
  "upwelling-erdQAstressmday-2009-2017.csv",
  "upwelling-erdQSstressmday-1999-2009.csv"
)
for(fil in covfiles){
  dat=read.csv(fil)
  covs=colnames(dat)[!(colnames(dat)%in%c("Year","Month","Dates"))]
  covs.uniq=paste("Wind.",covs,sep="")
  for(icol in covs.uniq) if(is.null(monthly_cov[[icol]])) monthly_cov[[icol]]=NA
  for(i in 1:dim(dat)[1])
    monthly_cov[monthly_cov$Year==dat$Year[i] & monthly_cov$Month==dat$Month[i],covs.uniq]=
    dat[i,covs]
}

#UPW SST based; pathfinder 1981-2002, then POES
covfiles=c(
  "upw-sst-erdPH2sstamday-1981-2012.csv",
  "upw-sst-erdAGsstamday-2003-2016.csv"
  )
for(fil in covfiles){
  dat=read.csv(fil)
  covs=colnames(dat)[!(colnames(dat)%in%c("Year","Month","Dates"))]
  covs.uniq=paste("SST.",covs,sep="")
  for(icol in covs.uniq) if(is.null(monthly_cov[[icol]])) monthly_cov[[icol]]=NA
  for(i in 1:dim(dat)[1])
    monthly_cov[monthly_cov$Year==dat$Year[i] & monthly_cov$Month==dat$Month[i],covs.uniq]=
    dat[i,covs]
}


write.csv(monthly_cov, row.names=FALSE, file="../Satellite_covariates.csv")
