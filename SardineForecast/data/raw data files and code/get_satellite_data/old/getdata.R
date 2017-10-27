# This script goes and gets chl, sst, ssh and upwelling data from the 14 boxes 
# defined at the Kochi workshop in September 2014. 
#
# Updated March 2017 to update timeseries and use new xtracto routines 
# Updated Sept 2017 to patch xtracto routine with a bug

#ncdf4 and rerddap are on cran but rerddapXtracto using github vs of rerddap
#rerddapXtracto is on github
# library(devtools)
# install_github("ropensci/rerddap") #req package
# install_github("ropensci/plotdap") #req package
# install_github("rmendels/rerddapXtracto")
library(ncdf4)
library(rerddap)
library(rerddapXtracto)

# #patch one of the rerddapXtracto files
# thepatchfile="rxtracto_3D_patch.R"
# source(thepatchfile)
# library(R.utils) #install if needed
# reassignInPackage("rxtracto_3D", pkgName="rerddapXtracto", rxtracto_3D)

# Define boxes of timeseries to plot. These are the central locations of each box.
# Each box is a 1 degree by 1 degree, except for box 14 which is 3 degree by 3 
# degree. So add and subtract 0.5 from each point, except for box 14 add/subtract 1.5

box<-matrix(c(74.7, 12.5,
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

width<-rep(.5,times=14)
width[14]<-1.5

# Define parameters for the chlorophyll dataset 

parameter <-'chlorophyll' 
dataInfo <- rerddap::info('erdMH1chlamday')
tpos1<-tpos<-c('2003-01-16','2016-12-16') # times must be within timerange of dataset 

for (i in 1:ncol(box)) {
  xpos=c(box[1,i]-width[i],box[1,i]+width[i])
  ypos=c(box[2,i]-width[i],box[2,i]+width[i])
  print(paste("Extracting ",parameter," data from Box ",i,sep=''))
  chl<-rxtracto_3D(dataInfo,parameter,xcoord=xpos,ycoord=ypos,tcoord=tpos)
 
  avg<-NULL
  
  #Calculate the average for each point in the time series 
  
  for (x in 1:dim(chl$chlorophyll)[3]) avg<-c(avg, mean(chl$chlorophyll[,,x], na.rm=TRUE))
  avg[is.na(avg)]<-NA
  
  dates<-chl$time
  if(i==1) allchl<-data.frame(dates=dates, stringsAsFactors=FALSE)
  
  allchl=cbind(allchl,avg)}
 colnames(allchl)=c("Dates",paste("CHL.",1:14,sep=""))
 allchl = cbind(Year=format(allchl$Dates,"%Y"),Month=format(allchl$Dates,"%m"),allchl)
 write.csv(allchl, paste(parameter,"-", attr(dataInfo, "datasetid"),".csv",sep=""),row.names=FALSE)
 
 # Define parameters for the SST dataset 
 
 parameter <-'sst' 
 dataInfo <- rerddap::info('erdAGsstamday')
 tpos<-c('2003-08-17','2016-05-16') # times must be within timerange of dataset 
 zpos <- 0.
 
 for (i in 1:ncol(box)) {
   xpos=c(box[1,i]-width[i],box[1,i]+width[i])
   ypos=c(box[2,i]-width[i],box[2,i]+width[i])
   print(paste("Extracting ",parameter," data from Box ",i,sep=''))
   sst<-rxtracto_3D(dataInfo,parameter,xcoord=xpos,ycoord=ypos,tcoord=tpos,zcoord=zpos)
   sst$sst<-drop(sst$sst)   # remoce extraneous 4th dimension 
   avg<-NULL
   
   #Calculate the average for each point in the time series 
   
   for (x in 1:dim(sst$sst)[3]) avg<-c(avg, mean(sst$sst[,,x], na.rm=TRUE))
   avg[is.na(avg)]<-NA
   
   dates<-sst$time
   if(i==1) allsst<-data.frame(dates=dates, stringsAsFactors=FALSE)
   
   allsst=cbind(allsst,avg)}
 colnames(allsst)=c("Dates",paste("SST.",1:14,sep=""))
 allsst = cbind(Year=format(allsst$Dates,"%Y"),Month=format(allsst$Dates,"%m"),allsst)
 write.csv(allsst, paste(parameter,"-", attr(dataInfo, "datasetid"),".csv",sep=""),row.names=FALSE)
 
 # Define parameters for the upwelling dataset 
 
 parameter <-'upwelling' 
 dataInfo <- rerddap::info('erdQSstressmday')
 tpos<-c('1999-08-17','2009-10-16') # times must be within timerange of dataset 
 zpos <- 0.
 
 for (i in 1:ncol(box)) {
   xpos=c(box[1,i]-width[i],box[1,i]+width[i])
   ypos=c(box[2,i]-width[i],box[2,i]+width[i])
   print(paste("Extracting ",parameter," data from Box ",i,sep=''))
   upw<-rxtracto_3D(dataInfo,parameter,xcoord=xpos,ycoord=ypos,tcoord=tpos,zcoord=zpos)
   upw$upwelling<-drop(upw$upwelling)   # remove extraneous 4th dimension 
   avg<-NULL
   
   #Calculate the average for each point in the time series 
   
   for (x in 1:dim(upw$upwelling)[3]) avg<-c(avg, mean(upw$upwelling[,,x], na.rm=TRUE))
   avg[is.na(avg)]<-NA
   
   dates<-upw$time
   if(i==1) allupw1<-data.frame(dates=dates, stringsAsFactors=FALSE)
   
   allupw1=cbind(allupw1,avg)}
 colnames(allupw1)=c("Dates",paste("UPW.",1:14,sep=""))
 
 # Define parameters for the ASCAT upwelling dataset 
 # to continue timeseries past 2009 
 
 parameter <-'upwelling' 
 dataInfo <- rerddap::info('erdQAstressmday')
 tpos<-c('2009-11-17','2017-08-16') # times must be within timerange of dataset 
 zpos <- 0.
 
 for (i in 1:ncol(box)) {
   xpos=c(box[1,i]-width[i],box[1,i]+width[i])
   ypos=c(box[2,i]-width[i],box[2,i]+width[i])
   print(paste("Extracting ",parameter," data from Box ",i,sep=''))
   upw2<-rxtracto_3D(dataInfo,parameter,xcoord=xpos,ycoord=ypos,tcoord=tpos,zcoord=zpos)
   upw2$upwelling<-drop(upw2$upwelling)   # remove extraneous 4th dimension 
   avg<-NULL
   
   #Calculate the average for each point in the time series 
   
   for (x in 1:dim(upw2$upwelling)[3]) avg<-c(avg, mean(upw2$upwelling[,,x], na.rm=TRUE))
   avg[is.na(avg)]<-NA
   
   dates2<-upw2$time
   if(i==1) allupw2<-data.frame(dates=dates2, stringsAsFactors=FALSE)
   
   allupw2=cbind(allupw2,avg)}
 colnames(allupw2)=c("Dates",paste("UPW.",1:14,sep=""))
 allupw=rbind(allupw1,allupw2)  # this has data from both QuikScat and ASCAT 
 allupw = cbind(Year=format(allupw$Dates,"%Y"),Month=format(allupw$Dates,"%m"),allupw)
 write.csv(allupw, paste(parameter,"-", attr(dataInfo, "datasetid"),".csv",sep=""),row.names=FALSE)
 
 # Define parameters for the ssh dataset 

 parameter <-'ssh' 
 dataInfo <- rerddap::info('erdTAsshmday')
 tpos<-c('1992-10-17','2009-06-15') # times must be within timerange of dataset 
 zpos <- 0.
 
 for (i in 1:ncol(box)) {
   xpos=c(box[1,i]-width[i],box[1,i]+width[i])
   ypos=c(box[2,i]-width[i],box[2,i]+width[i])
   print(paste("Extracting ",parameter," data from Box ",i,sep=''))
   ssh<-rxtracto_3D(dataInfo,parameter,xcoord=xpos,ycoord=ypos,tcoord=tpos,zcoord=zpos)
   ssh$ssh<-drop(ssh$ssh)   # remove extraneous 4th dimension 
   avg<-NULL
   
   #Calculate the average for each point in the time series 
   
   for (x in 1:dim(ssh$ssh)[3]) avg<-c(avg, mean(ssh$ssh[,,x], na.rm=TRUE))
   avg[is.na(avg)]<-NA
   
   dates<-ssh$time
   if(i==1) allssh<-data.frame(dates=dates, stringsAsFactors=FALSE)
   
   allssh=cbind(allssh,avg)}
 
 colnames(allssh)=c("Dates",paste("SSH.",1:14,sep=""))
 allssh = cbind(Year=format(allssh$Dates,"%Y"),Month=format(allssh$Dates,"%m"),allssh)
 write.csv(allssh, paste(parameter,"-", attr(dataInfo, "datasetid"),".csv",sep=""),row.names=FALSE)
 
 save(allssh,allsst,allchl,allupw,file="SatelliteData")