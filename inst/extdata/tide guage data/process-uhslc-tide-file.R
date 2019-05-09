#http://uhslc.soest.hawaii.edu/data/?fd#uh174
require(magrittr)
require(stringr)
dfc <- read.csv("raw-tide-level-cochin-2011-2019-uhslc.csv", stringsAsFactors=FALSE, skip=2)
dfc$tide.level.mm[dfc$tide.level.mm<0] <- NA
#remove outliers
tol <- 3*abs(quantile(dfc$tide.level.mm,c(.9),na.rm=TRUE)-median(dfc$tide.level.mm, na.rm=TRUE))
dfc$tide.level.mm[abs(dfc$tide.level.mm-median(dfc$tide.level.mm,na.rm=TRUE)) > tol] <- NA
#interpolate NAs
x <- 1:length(dfc$tide.level.mm)
y <- dfc$tide.level.mm
dfc$tide.level.mm <- approx(x,y, xout=x)$y

yrs <- min(dfc$year):max(dfc$year)
df.mon <- data.frame(year=rep(yrs, each=12), month=rep(1:12, length(yrs)), tide.level.mm=NA)
for(yr in yrs){
  for(mon in 1:12){
    the.row <- which(df.mon$year==yr & df.mon$mon==mon)
    df.rows <- dfc$year==yr & dfc$mon==mon
    if(sum(df.rows)<20) next
    df.mon[the.row,"tide.level.mm"] <- mean(dfc$tide.level.mm[df.rows], na.rm=TRUE)
    df.mon$tide.level.mm <- round(df.mon$tide.level.mm)
  }
}
write.csv(df.mon, file="uhslc-tide-level-2011-2019.csv", row.names = FALSE)

x <- 1:dim(dfc)[1]
y <- dfc$tide.level.mm
z <- filter(y, c(1,1,1))/3
plot(x,y)
lines(z, col="red")

tmp <- dfc$tide.level.mm[dfc$year==2013 & dfc$month==12]
