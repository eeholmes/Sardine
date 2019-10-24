# This one is daily so break down download by months
library(ncdf4)
library(rerddap)
library(rerddapXtracto)

# Define boxes of timeseries to plot. These are the central locations of each box.
# Each box is a 1 degree by 1 degree, except for box 14 which is 3 degree by 3 
# degree. So add and subtract 0.5 from each point, except for box 14 add/subtract 1.5

boxes14<-matrix(c(74.7, 12.5,
                  75.4, 11.5,
                  75.8, 10.5,
                  76, 9.5,
                  76.8, 8.5,
                  73.7, 12.5,
                  74.4, 11.5,
                  74.8, 10.5,
                  75, 9.5,
                  75.8, 8.5,
                  74, 9.5,
                  74.8, 8.5,
                  73.8, 8.5,
                  74.5, 14.5),ncol=14,nrow=2)
width<-rep(.5,times=14) #this is 1/2 width
width[14]<-1.5

# Define function for downloading and saving data
getdat = function(parameter, id, tag, box, width, clean=TRUE, save.csv=TRUE, include.z=FALSE){
  dataInfo <- rerddap::info(id)
  #get data range from dataset
  global <- dataInfo$alldata$NC_GLOBAL
  tt <- global[global$attribute_name %in% c("time_coverage_end", "time_coverage_start"), "value", ]
  cat(sprintf("     time: (%s, %s)", tt[2], tt[1]));cat("\n")
  tpos<-c(tt[2],tt[1]) # times must be within timerange of dataset 
  tpos2 <- seq(as.Date(tpos)[1], as.Date(tpos)[2], by="month")
  for (i in 1:ncol(box)) {
    xpos=c(box[1,i]-width[i],box[1,i]+width[i])
    ypos=c(box[2,i]-width[i],box[2,i]+width[i])
    zpos <- 0.
    print(paste("Extracting",parameter, id, "data from Box",i, sep=' '))
    mon.avg<-NULL
    for(t in 1:(length(tpos2)-1)){
      cat(" ", t)
      tpos3=c(tpos2[t],tpos2[t+1])
      if(include.z) dat<-rxtracto_3D(dataInfo,parameter,xcoord=xpos,ycoord=ypos,tcoord=tpos3,zcoord=zpos)
      if(!include.z) dat<-rxtracto_3D(dataInfo,parameter,xcoord=xpos,ycoord=ypos,tcoord=tpos3)
      if(include.z) dat[[parameter]]<-drop(dat[[parameter]])
      avg<-NULL
      
      #Calculate the average for each point in the time series 
      
      for (x in 1:dim(dat[[parameter]])[3]) avg<-c(avg, mean(dat[[parameter]][,,x], na.rm=TRUE))
      avg[is.na(avg)]<-NA
      avg <- mean(avg, na.rm=TRUE)
      mon.avg <- c(mon.avg, avg)
    }
    dates<-tpos2[1:(length(tpos2)-1)]
    if(i==1) alldat<-data.frame(dates=dates, stringsAsFactors=FALSE)
    
    alldat=cbind(alldat,mon.avg)
    if(save.csv) write.csv(alldat, paste("tmp-", i+2, "-", parameter,"-", id,"-",yr1,"-",yr2,".csv",sep=""),row.names=FALSE)
  }
  #Create the data.frame with the Year, Month and covariates in each box
  covnames = paste(tag,1:ncol(box),sep="")
  colnames(alldat)=c("Dates",covnames)
  yr1=format(as.Date(tt[2]),"%Y")
  yr2=format(as.Date(tt[1]),"%Y")
  #create data.frame with all months are present and file starts with Jan and ends with Dec
  fullalldat=data.frame(Year=rep(yr1:yr2,each=12),Month=rep(1:12,length(yr1:yr2)))
  fullalldat[covnames]=NA #add on covariates
  #add year and month to alldat
  alldat = cbind(Year=as.numeric(format(alldat$Dates,"%Y")),
                 Month=as.numeric(format(alldat$Dates,"%m")),
                 alldat)
  #make sure each month is present in each year and file starts with Jan and ends with Dec
  for(irow in 1:dim(alldat)[1]){
    fullalldat[fullalldat$Year==alldat$Year[irow] & fullalldat$Month==alldat$Month[irow],covnames]=
      alldat[irow,covnames]
  }
  if(save.csv) write.csv(fullalldat, paste(parameter,"-", id,"-",yr1,"-",yr2,".csv",sep=""),row.names=FALSE)
  #clean up
  if(clean) file.remove(Sys.glob("*.nc"))
  invisible(fullalldat)
}

parameter <-'sst' 
id <- 'ncdcOisst2Agg' 
tag <- "SST."
ncdcOisst2Agg=getdat(parameter, id, tag, boxes14[,3:14], width, include.z=TRUE)
