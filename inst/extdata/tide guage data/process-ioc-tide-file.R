# process the daily data into monthly
require(magrittr)
require(stringr)
dfc <- read.csv("raw-tide-level-2011-2018-daily-ioc.csv", stringsAsFactors=FALSE, header=TRUE)
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
write.csv(df.mon, file="ioc-tide-level-2011-2018.csv", row.names = FALSE)
