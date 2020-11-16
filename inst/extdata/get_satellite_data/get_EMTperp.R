#Bakun upwelling index from here
#https://oceanview.pfeg.noaa.gov/products/upwelling/bakun
#monthly values of upwelling (coast angle 158 degrees)
# Coast angle same as Supradba et al 2016, page 9153


source(file.path(here::here(), "inst", "extdata", "get_satellite_data", "Replicate_EMT", "get_EMT_functions.R"))

# Get monthly wind data
#getdata("hawaii_soest_66d3_10d8_0f3c", lat=c(7,15), lon=c(70,78), 
#       altitude=1000, eserver="http://apdrc.soest.hawaii.edu/erddap", alt.name="LEV")
# dfil <- file.path(here::here(), "inst", "extdata", "get_satellite_data", "Replicate_EMT", "hawaii_soest_66d3_10d8_0f3c-7-15-70-78-1979-01-01-2020-06-01.csv")
windmon <- getdata("hawaii_soest_66d3_10d8_0f3c", date=c("1979-01-01", "2020-06-01"), 
        lat=c(7,15), lon=c(70,78), 
        altitude=1000, eserver="http://apdrc.soest.hawaii.edu/erddap", alt.name="LEV")
windmon$time <- as.Date(windmon$time)
windmon$Month <- as.numeric(format(windmon$time, "%m"))
windmon$Year <- as.numeric(format(windmon$time, "%Y"))
windmon <- getEMT(windmon, coast_angle=158)

# Define the region 2 degrees longitude off the coast
load(file.path(here::here(), "inst", "extdata", "get_satellite_data", "Replicate_EMT", "indiashp.RData"))
b=as(as(indiashp2, "SpatialLinesDataFrame"), "SpatialPointsDataFrame")
b=subset(b, Line.NR==129)
coastcoord=coordinates(b)
coastcoord <- coastcoord[coastcoord[,"x"]<77.5,] # don't include east coast
coastlats = unique(windmon$latitude)
coastlons = c()
for(i in coastlats){
  tmp <- coastcoord[,"y"]
  coastlons <- c(coastlons, min(coastcoord[,"x"][which(abs(tmp-i)==min(abs(tmp-i)))]))
}

# Include only the coast and lat 8 to 13
windmon.coast <- windmon[windmon$latitude>=8 & windmon$latitude<=13,]
for(i in 1:length(coastlats)){
  thelat <- coastlats[i]
  thelon <- coastlons[i]
  windmon.coast <- windmon.coast[!(windmon.coast$latitude==thelat & windmon.coast$longitude<(thelon-2)),]
}
# Get average coastal EMTperp for each month
EMTperp.cmean <- windmon.coast %>% 
  group_by(Year, Month) %>% 
  summarize(EMTperp = mean(EMTperp, na.rm=TRUE)
  )
# Get average EMT pumping for each month
windmon.tip <- windmon[windmon$latitude>=7 & windmon$latitude<=9 & 
                         windmon$longitude>=75 & windmon$longitude<=77,]
Epump.cmean <- windmon.tip %>% 
  group_by(Year, Month) %>% 
  summarize(We = 1000000*mean(We, na.rm=TRUE)
  )


yr1=min(windmon$Year); yr2=max(windmon$Year)
id <- "ERA5"
Ekman <- cbind(EMTperp.cmean[,c("Year", "Month", "EMTperp")], We=Epump.cmean$We)
dfil <- file.path(here::here(), "inst", "extdata", "get_satellite_data",
                  paste0("Ekman","-", id,"-",yr1,"-",yr2,".csv"))
write.csv(Ekman, file=dfil, row.names=FALSE)
