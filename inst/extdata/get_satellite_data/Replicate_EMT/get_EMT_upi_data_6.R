lat <- 10.5
lon <- 75.5
lat1 <- 11.5
lat2 <- 18.5
lon <- 75
lat1 <- 20
lat2 <- 50
lon <- 225
lat1 <- 11.5
lat2 <- 11.5
lon <- 75
val <- paste0("[(2019-09-01T06:00:00Z):1:(2019-09-30T06:00:00Z)][(",lat1,"):1:(",lat2,")][(",lon,"):1:(",lon,")]")
pars <- c("u", "v", "tauy", "taux", "ektrx", "ektry", "uv_mag")
val2 <- paste0(pars, val, collapse=",")
url <- paste0("https://coastwatch.pfeg.noaa.gov/erddap/griddap/erdlasFnTransMon.csv?", val2)
download.file(url, destfile="upw-erdlasFnTransMon.csv")
upi<-read.csv(file="upw-erdlasFnTransMon.csv", stringsAsFactors = FALSE)
upi<-upi[-1,]
upi$uv_mag <- as.numeric(upi$uv_mag)
upi$tauy <- as.numeric(upi$tauy)
upi$taux <- as.numeric(upi$taux)
upi$ektrx <- as.numeric(upi$ektrx)
upi$ektry <- as.numeric(upi$ektry)
upi$time <- as.Date(upi$time)
upi$Month <- as.numeric(format(upi$time, "%m"))
upi$Year <- as.numeric(format(upi$time, "%Y"))
upi$u <- as.numeric(upi$u)
upi$v <- as.numeric(upi$v)
upi$latitude <- as.numeric(upi$latitude)

pa <- 1.22 # kg/m3
omega <- 7.272205e-05 #(rad/s) used for the SWFSC calcs
f <- 2*omega*sin(pi*upi$latitude/180)
Cd <- function(wind.speed){
  Cd <- wind.speed
  Cd[wind.speed <= 1] <- 2.18
  Cd[wind.speed < 3 & wind.speed > 1] <- 0.62+1.56/wind.speed[wind.speed < 3 & wind.speed > 1]
  Cd[wind.speed >= 3 & wind.speed < 10] <- 1.14
  Cd[wind.speed >= 10] <- 0.49 + 0.065*wind.speed[wind.speed >= 10]
  return(Cd*.001)
}


# Compute tau; get taux and tauy from u and v
tau <- pa*Cd(upi$uv_mag)*upi$uv_mag*upi$uv_mag
tauy2 <- sign(upi$v)*(abs(upi$v)/upi$uv_mag)*tau
taux2 <- sign(upi$u)*(abs(upi$u)/upi$uv_mag)*tau
EMT <- tau/f
# MASS TRANSPORT IS PERPENDICULAR TO WIND
# u/taux positive is west to east wind so into india w coast
# wind blowing west to east means EMT toward equator (negative)
EMTy <- -1*taux/f
# v/tauy negative is wind blowing south toward equator
# Negative v (south) means EMT to west (off-shore)
# EMTx is the one that drives upwelling since coast is mostly n-s
# Negative EMTx = directed offshore = positive upwelling
EMTx <- tauy2/f
upi$tauy2 <- tauy2
upi$taux2 <- taux2
upi$EMTy <- EMTy
upi$EMTx <- EMTx


plot(upi$taux, upi$taux2)
abline(a=0, b=1)
plot(upi$tauy, upi$tauy2)
abline(a=0, b=1)

# within 4e-8
plot(upi$taux2-upi$taux, upi$uv_mag)
plot(upi$tauy2-upi$tauy, upi$uv_mag)

# EMT ok
f <- 2*omega*sin(pi*upi$latitude/180)
plot((1/f)/(sqrt(upi$ektrx^2+upi$ektry^2)/sqrt(upi$taux^2+upi$tauy^2)), upi$latitude)
f2 <- 1/(sqrt(upi$ektrx^2+upi$ektry^2)/sqrt(upi$taux^2+upi$tauy^2))
f2/(2*sin(pi*upi$latitude/180))

plot(sqrt(upi$ektrx^2+upi$ektry^2)-EMT, upi$latitude)

# tau is the same
plot(sqrt(upi$taux^2+upi$tauy^2)-tau, upi$latitude)
mean(sqrt(upi$taux^2+upi$tauy^2)-tau)

# taux and tauy are the same
plot(upi$taux-taux2, upi$latitude)
plot(upi$tauy-tauy2, upi$latitude)

#good
plot(tau-sqrt(taux2^2+tauy2^2))
plot(tau-sqrt(upi$taux^2+upi$tauy^2))

# these are ok
plot(sqrt(upi$ektrx^2+upi$ektry^2)/(sqrt(upi$taux^2+upi$tauy^2)/(2*omega*sin(pi*upi$latitude/180))), upi$latitude)
plot(sqrt(upi$ektrx^2+upi$ektry^2)/(sqrt(upi$taux2^2+upi$tauy2^2)/(2*omega*sin(pi*upi$latitude/180))), upi$latitude)


#odd not within 4e-8
plot(EMT-sqrt(EMTx^2+EMTy^2)) # ODD

# ODD NOT WITHIN 4E-8
plot(upi$ektrx-upi$tauy/f, upi$uv_mag)
plot(upi$ektry- -1*upi$taux/f, upi$uv_mag)

# these are the same
plot(EMTx-tauy2/f, upi$uv_mag)
plot(EMTy- -1*taux2/f, upi$uv_mag)

# these are different
plot(upi$ektry- -1*upi$taux/f, abs(upi$u)) #close but not within 4e-8
plot(upi$ektrx-upi$tauy/f, abs(upi$v)) #close but not within 4e-8
plot(upi$ektry, -1*upi$taux/f); abline(a=0, b=1)
plot(upi$ektrx, upi$tauy/f); abline(a=0, b=1)


# these are similar within 4e-3
plot(upi$ektrx-EMTx, upi$uv_mag) # similar but not with 4e-8
plot(upi$ektry-EMTy, upi$uv_mag) # similar but not with 4e-8
plot(upi$ektry, EMTy)
plot(upi$ektrx, EMTx)

df <- subset(upi, time>as.Date("2000-01-01"))
df$ektry[abs(df$ektry)>20000]<-NA
df$ektrx[abs(df$ektrx)>20000]<-NA
df<-na.omit(df)
plot(tapply(df$EMTy, df$Month, mean, na.rm=TRUE))
plot(tapply(df$ektry, df$Month, mean, na.rm=TRUE), ylim=c(-10000,5000))
lines(tapply(df$EMTy, df$Month, mean, na.rm=TRUE))

# UPWELLING = transport away from coast
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
upi$UPW <- upwell(upi$ektrx, upi$ektry, 158)
yr1=min(upi$Year); yr2=max(upi$Year)
id <- "erdlasFnWPr"
#upi <- upi[,c("Year", "Month", "UPW")]
plot(ts(upi$u_mean, start=c(upi$Year[1], upi$Month[1]), frequency=12))

