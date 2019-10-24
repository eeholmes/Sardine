#assumes wd is the base package dir

#this creates data objects of monthly chl, sst, ssh, and upw
#Put all the covariate data into one data frame
library(stringr)
fil="inst/extdata/raw data files and code/Satellite_covariates.csv"
dat=read.csv(fil)
years=unique(dat$Year)
chl=sst=ssh=upw=data.frame(Year = rep(years,each=12), Month=rep(1:12,length(years)))
for(covname in c("CHL","SST","SSH","UPW")){
  covs=colnames(dat)[str_detect(colnames(dat),covname)]
  tmp=get(tolower(covname))
  tmp[covs]=NA
  for(i in 1:dim(dat)[1]){
    tmp[tmp$Year==dat$Year[i] & tmp$Month==dat$Month[i],covs]=
      dat[i,covs]
  }
  assign(tolower(covname),tmp)
}
#standardize the Bakun UPW
tmp=(upw$Bakun.UPW-mean(upw$Bakun.UPW,na.rm=TRUE))
tmp=tmp/sqrt(var(tmp,na.rm=TRUE))
upw$Bakun.UPW <- tmp

save(chl, file="data/chl.rdata")
save(sst, file="data/sst.rdata")
save(ssh, file="data/ssh.rdata")
save(upw, file="data/upw.rdata")

enso=read.csv("inst/extdata/raw data files and code/enso.csv")
save(enso, file="data/enso.rdata")

onset=read.csv("inst/extdata/raw data files and code/onset.csv")
save(onset, file="data/onset.rdata")

#creates precip.rdata from the 3 precip files
source("inst/extdata/raw data files and code/create_precip_rdata.r")

#creates the oilsardine_qtr.rdata file
source("inst/extdata/raw data files and code/create_oilsardine_qtr_rdata.r")

#creates monthly .rdata file
filename="inst/extdata/raw data files and code/monthly_covariates_with_anomalies.csv"
seio_covariates_mon = read.csv(filename)
save(seio_covariates_mon, file="data/seio_covariates_mon.rdata")

#creates the quarterly .rdata file
source("inst/extdata/raw data files and code/create_quarterly_covariates_rdata.r")
