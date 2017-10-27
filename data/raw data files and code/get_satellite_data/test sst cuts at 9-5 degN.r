# SST based UPW index works by looking for drop in sst by coast
# nearshore box needs to be close enough to shore to detect that

yr=2007; mon=6
i=which(sstcut.AG$Year==yr & sstcut.AG$Month==mon);sstcut.AG$SST.2[i]-sstcut.AG$SST.6[i]
i=which(sstcut.AG$Year==yr & sstcut.AG$Month==mon);sstcut.AG$SST.2[i]-sstcut.AG$SST.8[i]
i=which(sstcut.icoads$Year==yr & sstcut.icoads$Month==mon);sstcut.icoads$SST.2[i]-sstcut.icoads$SST.6[i]
i=which(sstPH$Year==yr & sstPH$Month==mon);sstPH$SST.4[i]-sstPH$SST.11[i]

y1=2003; y2=2012
tmpa=with(seio_covariates_mon[seio_covariates_mon$Year>=y1 & seio_covariates_mon$Year<= y2,], data.frame(Year=Year,Month=Month,UPW=UPW.4))
tmpb=with(sstPH[sstPH$Year>=y1 & sstPH$Year<= y2,], data.frame(Year=Year,Month=Month,UPW=SST.4-SST.11))
plot(tmpb$UPW,tmpa$UPW)
tmpb=with(sstPH[sstPH$Year>=y1 & sstPH$Year<= y2,], data.frame(Year=Year,Month=Month,UPW=SST.4-SST.11))


#test the slices across 9.5N
boxes.cut<-matrix(c(76.5, 9.5,
                    76, 9.5,
                    75.5, 9.5,
                    75, 9.5,
                    74.5, 9.5,
                    74, 9.5,
                    73.5, 9.5,
                    73, 9.5,
                    72.5, 9.5,
                    72, 9.5),ncol=10,nrow=2)
width=rep(.5,10)

parameter <-'sst' 
id <- 'erdAGsstamday'
tag <- "SST."
sstcut.AG=getdat(parameter, id, tag,  boxctrs=boxes.cut, width, save.csv=FALSE, include.z=TRUE)

parameter <-'sst' 
id <- 'esrlIcoads1ge' 
tag <- "SST."
sstcut.icoads=getdat(parameter, id, tag,  boxctrs=boxes.cut, width, save.csv=FALSE)

parameter <-'sea_surface_temperature' 
id <- 'erdPH2sstdmday'
tag <- "SST."
sstPH=getdat(parameter, id, tag,  boxctrs=boxes.cut, width, save.csv=FALSE)
