td0 <- read.csv("raw-psmsl-tide-level-1939-2013.csv", stringsAsFactors=FALSE)
td1 <- read.csv("psmsl-tide-level-1939-2013.csv", stringsAsFactors=FALSE)
td2 <- read.csv("uhslc-tide-level-2011-2019.csv", stringsAsFactors=FALSE)
td3 <- read.csv("ioc-tide-level-2011-2018.csv", stringsAsFactors=FALSE)

yrs <- 1939:2018
df.mon <- data.frame(Year=rep(yrs, each=12), Month=rep(1:12, length(yrs)), tide.level.mm=NA)
dfc <- td0
yrs <- 1939:2011
for(yr in yrs){
  for(mon in 1:12){
    the.row <- which(df.mon$Year==yr & df.mon$Month==mon)
    df.rows <- which(dfc$Year==yr & dfc$Month==mon)
    if(yr==2011 & mon>9) next
    df.mon[the.row,"tide.level.mm"] <- dfc$tide.level.mm[df.rows]
    df.mon$tide.level.mm <- round(df.mon$tide.level.mm)
  }
}
yrs <- 2011:2018
for(yr in yrs){
  for(mon in 1:12){
    the.row <- which(df.mon$Year==yr & df.mon$Month==mon)
    df.row2 <- which(td2$Year==yr & td2$Month==mon)
    df.row3 <- which(td3$Year==yr & td3$Month==mon)
    if(yr==2011 & mon<10) next
    df.mon[the.row,"tide.level.mm"] <- mean(c(td2$tide.level.mm[df.row2],td3$tide.level.mm[df.row3]), na.rm=TRUE)
    df.mon$tide.level.mm <- round(df.mon$tide.level.mm)
  }
}
# Save as the raw
ts0 <- ts(ts0, start=1939, frequency=12)
ts4 <- ts(df.mon$tide.level.mm, start=df.mon$Year[1], frequency=12)

# Use ETS to fill in the NAs to get annual means
ts4.interp <- ts4
nas <- which(is.na(ts4))
for(i in nas){
  yr <- i%/%12 + 1939
  mon <- (i/12-i%/%12)*12-1
  dat <- window(ts4.interp, end=c(yr, mon))
  fit <- forecast::ets(dat)
  fr <- forecast::forecast(fit, h=1)
  ts4.interp[i] <- fr$mean
}
df.mon$tide.level.interp <- ts4.interp

# annual
yr.mean <- tapply(df.mon$tide.level.interp, df.mon$Year, mean)
df.yr <- data.frame(Year=1939:2018, mean=yr.mean)

#anomalies with linear trend removed
df.yr$anomalies <- df.yr$mean - fitted(lm(mean~Year, data=df.yr))
df.mon$anomalies <- df.mon$tide.level.interp - fitted(lm(tide.level.interp~Year+as.factor(Month), data=df.mon))
df.mon$anomalies13 <- filter(df.mon$anomalies, rep(1/13,13))
#anomalies with non-linear trend removed
fit=mgcv::gam(tide.level.interp~s(Year)+as.factor(Month), data=df.mon)
df.mon$anomaliesb <- df.mon$tide.level.interp - fitted(fit)
df.mon$anomalies13b <- filter(df.mon$anomaliesb, rep(1/13,13))

tide_mon <- df.mon
tide_yr <- df.yr
save(tide_mon, tide_yr, file="tidelevel.rdata")

#Plots
load("tidelevel.rdata")
ts4 <- ts(tide.monthly$tide.level.mm, start=tide.monthly$year[1], frequency=12)
ts4.interp <- ts(tide.monthly$tide.level.interp, start=tide.monthly$year[1], frequency=12)

plot(ts4.interp, col="red", ylab="Tide Level (uncorrected)")
lines(ts4)
title("Interpolated tide level with exponential smoothing")

p <- barplot(tide.annual$anomalies, col=ifelse(tide.annual$anomalies>0, "black", "red"))
yra <- 1939:2020
p <- c(p,p[length(p)]+(1:2)*diff(p)[1])
axis(1, at=p[seq(2,length(p),5)], labels=yra[seq(2,length(p),5)], line=0, las=2)
title("Mean annual sea level height anomalies at Cochin")

tmp3 = data.frame(anom=as.numeric(window(df.mon$anomalies, start=1949, end=c(2017,12))), soi=enso$SOI)

####################################################################

## Some diagnostic plots for the difference in the PSMSL and other data 2011-2018

loc0 <- which(td0$year %in% td2$year)
loc1 <- which(td1$year %in% td2$year)
loc1 <- which(td1$year %in% td2$year)
loc2 <- which(td2$year %in% td1$year)
loc3 <- which(td3$year %in% td1$year)
# Level diagram.
# https://www.psmsl.org/data/obtaining/rlr.diagrams/438.php
# adj of 6260 based on MSL of 709mm 1963-2012
# mean sea level in their data is not 709mm
mean(window(ts0, start=c(1963,1), end=c(2011,12)),na.rm=TRUE)


adj <- 6260
reb0 <- mean(td0$tide.level.mm[loc0] - td2$tide.level.mm[loc2], na.rm=TRUE)
reb2 <- mean(td1$tide.level.mm[loc1] - td2$tide.level.mm[loc2], na.rm=TRUE)
reb3 <- mean(td1$tide.level.mm[loc1] - td3$tide.level.mm[loc2], na.rm=TRUE)
tmp <- cbind(td1$tide.level.mm[loc1]-adj, td2$tide.level.mm[loc2], td3$tide.level.mm[loc3])
pairs(tmp)

ts0 <- ts(td0$tide.level.mm, start=td0$year[1], frequency=12)
ts1 <- ts(td1$tide.level.mm-adj, start=td1$year[1], frequency=12)
ts2 <- ts(td2$tide.level.mm, start=td2$year[1], frequency=12)
ts3 <- ts(td3$tide.level.mm, start=td3$year[1], frequency=12)
plot(window(ts0, start=c(2011,1)), ylim=c(500,1000),lwd=2,ylab="metric tide height")
lines(ts3, col="red")
lines(ts2, col="blue")
legend("topright", c("PSMSL Raw","UHSLC", "IOC"), lwd=c(2,1,1), col=c("black", "blue", "red"))
abline(v=(2011+8.5/12))
text(2012, 1000, "new gauge")

fit <- auto.arima(window(ts0, start=c(1939,1), end=c(2011,1)))
plot(forecast(fit, 12))
lines(window(ts0,start=c(2010), end=c(2014,12)))
