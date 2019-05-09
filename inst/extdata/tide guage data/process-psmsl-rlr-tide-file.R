# https://www.psmsl.org/data/obtaining/stations/438.php
require(magrittr)
require(stringr)
dfc <- read.delim("tide-level-cochin-RLR-1939-2013.csv", stringsAsFactors=FALSE, skip=2, sep=";")
tmp <- dfc$year %>% sapply(function(x){stringr::str_split(x, "[.]")[[1]][2]})
tmp2 <- str_c("0.",tmp) %>% as.numeric()*12+0.51
mons <- floor(tmp2)
yrs <- dfc$year %>% sapply(function(x){stringr::str_split(x, "[.]")[[1]][1]}) %>% as.numeric()
vals <- dfc$corrected.tide.level.mm
vals[vals<0] <- NA
dfc <- data.frame(year=yrs, month=mons, tide.level.mm=vals)

yrs <- min(yrs):max(yrs)
df.mon <- data.frame(year=rep(yrs, each=12), month=rep(1:12, length(yrs)), tide.level.mm=NA)
for(yr in yrs){
  for(mon in 1:12){
    the.row <- which(df.mon$year==yr & df.mon$mon==mon)
    dfc.row <- which(dfc$year==yr & dfc$mon==mon)
    df.mon[the.row,"tide.level.mm"] <- dfc$tide.level.mm[dfc.row]
  }
}
write.csv(df.mon, file="psml-tide-level-1939-2013.csv", row.names = FALSE)

dfc <- read.delim("tide-level-cochin-metric-psmsl-1939-2013.csv", stringsAsFactors=FALSE, skip=2, sep=";")
tmp <- dfc$year %>% sapply(function(x){stringr::str_split(x, "[.]")[[1]][2]})
tmp2 <- str_c("0.",tmp) %>% as.numeric()*12+0.51
mons <- floor(tmp2)
yrs <- dfc$year %>% sapply(function(x){stringr::str_split(x, "[.]")[[1]][1]}) %>% as.numeric()
vals <- dfc$tide.level.mm
vals[vals<0] <- NA
dfc <- data.frame(year=yrs, month=mons, tide.level.mm=vals)

yrs <- min(yrs):max(yrs)
df.mon <- data.frame(year=rep(yrs, each=12), month=rep(1:12, length(yrs)), tide.level.mm=NA)
for(yr in yrs){
  for(mon in 1:12){
    the.row <- which(df.mon$year==yr & df.mon$mon==mon)
    dfc.row <- which(dfc$year==yr & dfc$mon==mon)
    df.mon[the.row,"tide.level.mm"] <- dfc$tide.level.mm[dfc.row]
  }
}
write.csv(df.mon, file="psmsl-raw-tide-level-1939-2013.csv", row.names = FALSE)
