#daily tide gauge data; day is day BEFORE date in url
baseurl <- "http://www.ioc-sealevelmonitoring.org/bgraph.php?code=coch&output=tab&period=1&endtime="
yrs <- 2011:2018
df <- data.frame(year=1999, month=1, day=1, tide.level.mm=NA)
for(yr in yrs){
  for(mon in 1:12){
    for(day in 1:31){
      if(yr==2011 & mon<7) next #problems with data before July 2011
    dat <- paste0(yr,"-",mon,"-",day)
    a <- XML::readHTMLTable(paste0(baseurl,dat),header=TRUE, stringsAsFactors=FALSE)
    if(length(a)==0) next
    a <- a[[1]] #first table if data
    if(length(a)==0) next
    a[,1] <- as.Date(a[,1])
    a[,2] <- as.numeric(a[,2])
    a <- a[-dim(a)[1],] #get rid of first data point from next day
    # remove outliers per IOC procedure on website
    tol <- 3*abs(quantile(a[,2],c(.9))-median(a[,2]))
    a[abs(a[,2]-median(a[,2])) > tol,2] <- NA
    df <- rbind(df, 
                data.frame(year=as.numeric(format(a[1,1], "%Y")),
                  month=as.numeric(format(a[1,1], "%m")),
                  day=as.numeric(format(a[1,1], "%d")),
                  tide.level.mm=mean(a[,2], na.rm=TRUE)*1000))
    cat(dat, "\n")
    }
      }
}
df <- df[-1,]
save(df, file="df-ioc.RData")
write.csv(df, file="raw-tide-level-2011-2018-daily-ioc.csv", row.names = FALSE)
