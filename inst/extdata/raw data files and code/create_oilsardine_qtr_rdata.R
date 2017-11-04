#This creates a data.frame of quarterly sardine catches
#from the .csv file of quarterly catches in Goa, Kerala, and Karnataka
# See code in raw data for analyses/landings for how the quarter data was assembled
# See notes in the .csv file for references for the data; all data from CMFRI

fil="Sardine_Landings_by_qtr.csv"

## load the data
dat=read.csv(paste("inst/extdata/raw data files and code/",fil,sep=""),stringsAsFactors = FALSE)
current.year = as.numeric(format(Sys.Date(),"%Y"))
years=1956:current.year

## Create the data.frame
qtr.data=data.frame(Year=rep(years,each=4),Qtr=rep(1:4,length(years)),
                    Goa=NA,Karnataka=NA,Kerala=NA)

for(reg in c("Goa","Karnataka", "Kerala")){
for(i in years){
  qtr.data[[reg]][qtr.data$Year==i & qtr.data$Qtr==1]=dat$Q1[dat$Year==i&dat$Site==reg][1]
  qtr.data[[reg]][qtr.data$Year==i & qtr.data$Qtr==2]=dat$Q2[dat$Year==i&dat$Site==reg][1]
  qtr.data[[reg]][qtr.data$Year==i & qtr.data$Qtr==3]=dat$Q3[dat$Year==i&dat$Site==reg][1]
  qtr.data[[reg]][qtr.data$Year==i & qtr.data$Qtr==4]=dat$Q4[dat$Year==i&dat$Site==reg][1]
}
}

qtr.data$SWCoast = qtr.data$Goa+qtr.data$Karnataka+qtr.data$Kerala

oilsardine_qtr = qtr.data
save(oilsardine_qtr, file="data/oilsardine_qtr.rdata")
