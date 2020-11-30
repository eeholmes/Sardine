# create Satellite_covariates.csv
# if update sat covariates, source this
# with SST, CHL, Wind.UPW, SST.UPW and UPW13.SST
# set get_satellite_data as wd
setwd(file.path(here::here(), "inst", "extdata", "get_satellite_data"))

#set up file
current.year = as.numeric(format(Sys.Date(),"%Y"))
years=1956:current.year
monthly_cov = data.frame(Year = rep(years,each=12), Month=rep(1:12,length(years)))

#SST 
# First submission
# covfiles=c(
#   "sea_surface_temperature-erdPH2sstamday-1981-2012.csv",
#   "sst-erdAGsstamday-2003-2016.csv"
# )
# for(fil in covfiles){
#   dat=read.csv(fil)
#   covs=colnames(dat)[!(colnames(dat)%in%c("Year","Month","Dates"))]
#   for(icol in covs) if(is.null(monthly_cov[[icol]])) monthly_cov[[icol]]=NA
#   for(i in 1:dim(dat)[1]){
#     #don't use 2003 from POES data since only has 3 months in 2003
#     if(!(fil=="sst-erdAGsstamday-2003-2016.csv" & dat$Year[i]==2003))
#       monthly_cov[monthly_cov$Year==dat$Year[i] & monthly_cov$Month==dat$Month[i],covs]=dat[i,covs]
#   }
# }
# Revision
covfiles = c(
  "sst-era5sst-1981-1981.csv",
  "sst-ncdcOisst21Agg-1982-2016.csv"
)
for(fil in covfiles){
  dat=read.csv(fil)
  covs=colnames(dat)[!(colnames(dat)%in%c("Year","Month","Dates"))]
  for(icol in covs) if(is.null(monthly_cov[[icol]])) monthly_cov[[icol]]=NA
  for(i in 1:dim(dat)[1]){
    monthly_cov[monthly_cov$Year==dat$Year[i] & monthly_cov$Month==dat$Month[i],covs]=dat[i,covs]
}
}

# #SST Interpolated
# 11-22-20 I think this file is bad as getdat() needs monthly data and this is daily
# covfiles=c(
#   "sst-ncdcOisst2Agg-1981-2019.csv"
# )
# for(fil in covfiles){
#   dat=read.csv(fil)
#   covs=colnames(dat)[!(colnames(dat)%in%c("Year","Month","Dates"))]
#   for(icol in covs) if(is.null(monthly_cov[[icol]])) monthly_cov[[icol]]=NA
#   for(i in 1:dim(dat)[1]){
#     monthly_cov[monthly_cov$Year==dat$Year[i] & monthly_cov$Month==dat$Month[i],covs]=
#       dat[i,covs]
#   }
# }

#SST Interpolated
covfiles=c(
  "sst-esrlIcoads1ge-1960-2017.csv"
)
for(fil in covfiles){
  dat=read.csv(fil)
  coln <- colnames(dat)
  coln <- stringr::str_replace(coln, "SST", "SSTICOAD")
  colnames(dat) <- coln
  covs=colnames(dat)[!(colnames(dat)%in%c("Year","Month","Dates"))]
  for(icol in covs) if(is.null(monthly_cov[[icol]])) monthly_cov[[icol]]=NA
  for(i in 1:dim(dat)[1]){
    monthly_cov[monthly_cov$Year==dat$Year[i] & monthly_cov$Month==dat$Month[i],covs]=
      dat[i,covs]
  }
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
  "chlorophyll-erdSW2018chlamday-1997-2010.csv",
  "chlorophyll-erdMH1chlamday-2003-2020.csv"
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
# First submission
# covfiles=c(
#   "upw-sst-erdPH2sstamday-1981-2012.csv",
#   "upw-sst-erdAGsstamday-2003-2016.csv"
#   )
# for(fil in covfiles){
#   dat=read.csv(fil)
#   covs=colnames(dat)[!(colnames(dat)%in%c("Year","Month","Dates"))]
#   covs.uniq=paste("SST.",covs,sep="")
#   for(icol in covs.uniq) if(is.null(monthly_cov[[icol]])) monthly_cov[[icol]]=NA
#   for(i in 1:dim(dat)[1]){
#     #use POES from 2004 onward since 2003 only has 3 months
#     if(!(fil=="upw-sst-erdAGsstamday-2003-2016.csv" & dat$Year[i]==2003))
#     monthly_cov[monthly_cov$Year==dat$Year[i] & monthly_cov$Month==dat$Month[i],covs.uniq]=dat[i,covs]
#   }
# }

# Revision use oiSST data
covfiles=c(
  "upw-sst-era5sst-1981-1981.csv",
  "upw-sst-ncdcOisst21Agg-1982-2016.csv"
)
for(fil in covfiles){
  dat=read.csv(fil)
  covs=colnames(dat)[!(colnames(dat)%in%c("Year","Month","Dates"))]
  covs.uniq=paste("SST.",covs,sep="")
  for(icol in covs.uniq) if(is.null(monthly_cov[[icol]])) monthly_cov[[icol]]=NA
  for(i in 1:dim(dat)[1]){
    monthly_cov[monthly_cov$Year==dat$Year[i] & monthly_cov$Month==dat$Month[i],covs.uniq] = dat[i,covs]
  }
}

#UPW Bakun Index
covfiles=c(
  "upw-bakun-erdlasFnWPr-1967-2019.csv"
)
for(fil in covfiles){
  dat=read.csv(fil)
  covs=colnames(dat)[!(colnames(dat)%in%c("Year","Month","Dates"))]
  covs.uniq=paste("Bakun.",covs,sep="")
  for(icol in covs.uniq) if(is.null(monthly_cov[[icol]])) monthly_cov[[icol]]=NA
  for(i in 1:dim(dat)[1])
    monthly_cov[monthly_cov$Year==dat$Year[i] & monthly_cov$Month==dat$Month[i],covs.uniq]=
    dat[i,covs]
}

#EMTperp and Ekman Pumping
covfiles=c(
  "Ekman-ERA5-1979-2020.csv"
)
for(fil in covfiles){
  dat=read.csv(fil)
  covs=colnames(dat)[!(colnames(dat)%in%c("Year","Month","Dates"))]
  covs.uniq=paste(covs,".UPW", sep="")
  for(icol in covs.uniq) if(is.null(monthly_cov[[icol]])) monthly_cov[[icol]]=NA
  for(i in 1:dim(dat)[1])
    monthly_cov[monthly_cov$Year==dat$Year[i] & monthly_cov$Month==dat$Month[i],covs.uniq]=
    dat[i,covs]
}

write.csv(monthly_cov, row.names=FALSE, file=file.path(here::here(), "inst", "extdata", "raw data files and code", "Satellite_covariates.csv"))

setwd(file.path(here::here()))