#set 'raw data files and code' dir as wd before running
#this creates data objects of monthly chl, sst, ssh, and upw
#Put all the covariate data into one data frame
fil="Satellite_covariates.csv"
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

save(chl, file="../chl.rdata")
save(sst, file="../sst.rdata")
save(ssh, file="../ssh.rdata")
save(upw, file="../upw.rdata")

enso=read.csv("enso.csv")
save(enso, file="../enso.rdata")

onset=read.csv("onset.csv")
save(onset, file="../onset.rdata")

#creates precip.rdata from the 2 precip files
source("read_precip.r")

#creates the oilsardine_qtr.rdata file
source("read_oilsardine_qtr.r")
