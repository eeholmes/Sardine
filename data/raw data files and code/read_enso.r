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

#set up enso dataframe
startyear=min(as.numeric(soi$Year), as.numeric(oni$Year))
endyear=max(as.numeric(soi$Year), as.numeric(oni$Year))
enso.yr=rep(startyear:endyear, each=12)
enso.mon=rep(1:12,length(startyear:endyear))
enso=data.frame(Year=enso.yr, Month=enso.mon, ONI=NA, SOI=NA)

#fill the dataframe
for(year in startyear:endyear){
  for(month in 1:12){
    filt1 = enso$Year==year & enso$Month==month
    filt2 = oni.yr==year & oni.mon==month
    filt3 = soi.yr==year & soi.mon==month
    if(any(filt2)) enso$ONI[filt1]=oni.vec[filt2]
    if(any(filt3)) enso$SOI[filt1]=soi.vec[filt3]
  }
}
write.csv(enso, file="enso.csv",row.names=FALSE)
save(enso, file="../enso.rdata")

