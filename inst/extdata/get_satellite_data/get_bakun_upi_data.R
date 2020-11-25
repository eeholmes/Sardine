#Bakun upwelling index from here
#https://oceanview.pfeg.noaa.gov/products/upwelling/bakun
#monthly values of upwelling (74.5E 11.5N coast angle 158 degrees)
# Coast angle same as Supradba et al 2016, page 9153, used (74.5E 13.0N coast angle 158 degrees)
# the values lower down the coast, closer to Kochi were not available. Gave NAs
# The calculation for computing Ekman transport from FNMOC pressure 
# uses a geostrophic approximation and thus is not valid within about 10-15 degrees of the equator.

url <- "https://coastwatch.pfeg.noaa.gov/erddap/griddap/erdlasFnWPr.csv?ektrx[(1967-01-16T12:00:00Z):1:(2019-09-17)][(11.5):1:(11.5)][(75.5):1:(75.5)],ektry[(1967-01-16T12:00:00Z):1:(2019-09-17)][(11.5):1:(11.5)][(75.5):1:(75.5)]"
download.file(url, destfile="upw-erdlasFnWPr-1967-2019.csv")
upi<-read.csv(file="upw-erdlasFnWPr-1967-2019.csv", stringsAsFactors = FALSE)
upi<-upi[-1,]
upi$ektrx <- as.numeric(upi$ektrx)
upi$ektry <- as.numeric(upi$ektry)
upi$time <- as.Date(upi$time)
upi$Month <- as.numeric(format(upi$time, "%m"))
upi$Year <- as.numeric(format(upi$time, "%Y"))

upwell <- function(ektrx, ektry, coast_angle) {
  pi <- 3.1415927
  degtorad <- pi/180.
  alpha <- (360 - coast_angle) * degtorad
  s1 <- cos(alpha)
  t1 <- sin(alpha)
  s2 <- -1 * t1
  t2 <- s1
  perp <- (s1 * ektrx) + (t1 * ektry)
  para <- (s2 * ektrx) + (t2 * ektry)
  return(perp/10)
}
upi$UPW <- upwell(upi$ektrx, upi$ektry, 140)
yr1=min(upi$Year); yr2=max(upi$Year)
id <- "erdlasFnWPr"
upi <- upi[,c("Year", "Month", "UPW")]
dfil <- paste("upw-bakun","-", id,"-",yr1,"-",yr2,".csv",sep="")
write.csv(upi, file=file.path(here::here(), "inst", "extdata", "get_satellite_data", dfil), row.names=FALSE)
