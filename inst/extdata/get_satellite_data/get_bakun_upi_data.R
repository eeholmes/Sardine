#Bakun upwelling index from here
#https://oceanview.pfeg.noaa.gov/products/upwelling/bakun
#monthly values of upwelling (74.5E 11.5N coast angle 158 degrees)
# Coast angle same as Supradba et al 2016, page 9153
# the values lower down the coast, closer to Kochi were not available. Gave NAs

url <- "https://coastwatch.pfeg.noaa.gov/erddap/griddap/erdlasFnWPr.csv?ektrx[(1967-01-16T12:00:00Z):1:(2019-09-17)][(11.5):1:(11.5)][(74.5):1:(74.5)],ektry[(1967-01-16T12:00:00Z):1:(2019-09-17)][(11.5):1:(11.5)][(74.5):1:(74.5)]"
download.file(url, destfile="upw-erdlasFnWPr-1967-2019.csv")
upi<-read.csv(file="upw-erdlasFnWPr-1967-2019.csv")
upi<-upi[-1,]
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
