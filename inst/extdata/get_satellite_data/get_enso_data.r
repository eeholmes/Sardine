#Oceanic Niño Index (ONI); 3-month average
#http://www.cpc.ncep.noaa.gov/products/analysis_monitoring/ensostuff/ensoyears.shtml
require(XML)
require(RCurl)
require(httr)
oni=read.table("http://www.cpc.ncep.noaa.gov/data/indices/oni.ascii.txt", stringsAsFactors=FALSE)
#Month is average of 3 months.  Jan = DJF average of Dec-Jan-Feb
#qtrs=c("JFM","AMJ","JAS","OND")

colnames(oni)=oni[1,]
oni=oni[-1,c("YR","SEAS","ANOM")]
colnames(oni)=c("Year","Month","ONI")

oni.yr=as.numeric(oni$Year)
oni.vec=as.numeric(oni$ONI)
oni.mon=rep(1:12,length(min(as.numeric(oni$Year)):max(as.numeric(oni$Year))))[1:length(oni$Year)]

#Southern Oscillation Index
soi=read.table("http://www.cpc.ncep.noaa.gov/data/indices/reqsoi.for", stringsAsFactors=FALSE)

colnames(soi)=c("Year",month.abb)

soi.vec=as.matrix(soi[,2:13])
soi.vec=as.numeric(t(soi.vec))
soi.vec[soi.vec==999.9]=NA
soi.yr=rep(as.numeric(soi$Year),each=12)
soi.mon=rep(1:12,length(soi$Year))

#Dipole Mode Index
#change nrow if you want data past 2018
dmi=read.table("https://www.esrl.noaa.gov/psd/gcos_wgsp/Timeseries/Data/dmi.long.data", skip=1, nrows=149)
colnames(dmi)=c("Year",month.abb)
dmi.vec=as.matrix(dmi[,2:13])
dmi.vec=as.numeric(t(dmi.vec))
dmi.vec[dmi.vec== -999.000]=NA
dmi.yr=rep(as.numeric(dmi$Year),each=12)
dmi.mon=rep(1:12,length(dmi$Year))

#set up enso dataframe
startyear=min(as.numeric(soi$Year), as.numeric(oni$Year))
endyear=max(as.numeric(soi$Year), as.numeric(oni$Year))
enso.yr=rep(startyear:endyear, each=12)
enso.mon=rep(1:12,length(startyear:endyear))
enso=data.frame(Year=enso.yr, Month=enso.mon, ONI=NA, SOI=NA, DMI=NA)

#fill the dataframe
for(year in startyear:endyear){
  for(month in 1:12){
    filt1 = enso$Year==year & enso$Month==month
    filt2 = oni.yr==year & oni.mon==month
    filt3 = soi.yr==year & soi.mon==month
    filt4 = dmi.yr==year & dmi.mon==month
    if(any(filt2)) enso$ONI[filt1]=oni.vec[filt2]
    if(any(filt3)) enso$SOI[filt1]=soi.vec[filt3]
    if(any(filt4)) enso$DMI[filt1]=dmi.vec[filt4]
  }
}
fil="enso.csv"
filename=paste0("inst/extdata/raw data files and code/",fil)
write.csv(enso, file=filename, row.names=FALSE)
save(enso, file="data/enso.rdata")

