## Prep a data frame with covariates by quarter

filename="inst/extdata/raw data files and code/monthly_covariates_with_anomalies.csv"
cov.dat=read.csv(filename)

## Create quarter column
qtrs=cov.dat$Month
qtrs[qtrs%in%c(1:3)]=1
qtrs[qtrs%in%c(4:6)]=2
qtrs[qtrs%in%c(7:9)]=3
qtrs[qtrs%in%c(10:12)]=4
cov.dat$Qtr=qtrs

## define your predictors
## there are many different ways to define the predictors
# for this file, I use mean covariates across quarters
dat=aggregate(cov.dat,list(Qtr=cov.dat$Qtr, Year=cov.dat$Year),mean,na.rm=TRUE)

## Remove the month
dat = dat[, -1*which(colnames(dat)=="Month")]

## Remove extra year col
dat = dat[, -1*which(colnames(dat)=="Year.1")]
dat = dat[, -1*which(colnames(dat)=="Qtr.1")]

seio_covariates_qtr = dat

## Look at what data you have
save(seio_covariates_qtr, file="data/seio_covariates_qtr.rdata")
