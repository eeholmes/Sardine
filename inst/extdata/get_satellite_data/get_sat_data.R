#Make sure working director is get_satellite_data folder

# This script goes and gets chl, sst, ssh and upwelling data from the 14 boxes 
# defined at the Kochi workshop in September 2014. 
#
# Updated March 2017 to update timeseries and use new xtracto routines 
# Updated Sept 2017 to patch xtracto routine with a bug

#ncdf4 and rerddap are on cran but rerddapXtracto using github vs of rerddap
#rerddapXtracto is on github
#Installing from github will not install dependencies (packages) for you so you will have to do that
#You will need Rtools if on Windows machine to install from github
# library(devtools)
# install_github("ropensci/rerddap") #req package
# install_github("ropensci/plotdap") #req package
# install_github("rmendels/rerddapXtracto")
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
  
  for (i in 1:ncol(box)) {
    xpos=c(box[1,i]-width[i],box[1,i]+width[i])
    ypos=c(box[2,i]-width[i],box[2,i]+width[i])
    zpos <- 0.
    print(paste("Extracting",parameter, id, "data from Box",i, sep=' '))
    if(include.z) dat<-rxtracto_3D(dataInfo,parameter,xcoord=xpos,ycoord=ypos,tcoord=tpos,zcoord=zpos)
    if(!include.z) dat<-rxtracto_3D(dataInfo,parameter,xcoord=xpos,ycoord=ypos,tcoord=tpos)
    if(include.z) dat[[parameter]]<-drop(dat[[parameter]])
    avg<-NULL
    
    #Calculate the average for each point in the time series 
    
    for (x in 1:dim(dat[[parameter]])[3]) avg<-c(avg, mean(dat[[parameter]][,,x], na.rm=TRUE))
    avg[is.na(avg)]<-NA
    
    dates<-dat[["time"]]
    if(i==1) alldat<-data.frame(dates=dates, stringsAsFactors=FALSE)
    
    alldat=cbind(alldat,avg)
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

# Define parameters for the chlorophyll dataset 
#https://coastwatch.pfeg.noaa.gov/erddap/info/erdSW1chlamday/index.html
parameter <-'chlorophyll' 
id <- 'erdSW1chlamday'
tag <- "CHL."
erdSW1chlamday=getdat(parameter, id, tag, boxes14, width)

# Define parameters for the chlorophyll 2 dataset 
#https://coastwatch.pfeg.noaa.gov/erddap/info/erdMH1chlamday/index.html
parameter <-'chlorophyll' 
id <- 'erdMH1chlamday'
tag <- "CHL."
erdMH1chlamday=getdat(parameter, id, tag, boxes14, width)
yr1=min(erdMH1chlamday$Year); yr2=max(erdMH1chlamday$Year)
write.csv(erdMH1chlamday, paste("chlorophyll","-", id,"-",yr1,"-",yr2,".csv",sep=""),row.names=FALSE)

# Define parameters for the sst 1a dataset 
#https://coastwatch.pfeg.noaa.gov/erddap/info/erdPH2sstdmday/index.html; pathfinder vs 2 1981 to 2012; 
#https://coastwatch.pfeg.noaa.gov/erddap/info/erdPH53sstdmday/index.html; pathfinder vs 5.3 1981 to present; 
# DAY Time; Science Quality
parameter <-'sea_surface_temperature' 
id <- 'erdPH53sstdmday'
tag <- "SST."
Sys.setenv(RERDDAP_DEFAULT_URL="https://coastwatch.pfeg.noaa.gov/erddap/")
erdPH53sstdmday=getdat(parameter, id, tag, boxes14, width)
Sys.setenv(RERDDAP_DEFAULT_URL="https://upwell.pfeg.noaa.gov/erddap/")

# Define parameters for the sst 1a dataset 
#https://coastwatch.pfeg.noaa.gov/erddap/info/erdPH53sstnmday/index.html; pathfinder vs 5.3 1981 to present; 
# NIGHT Time; Science Quality
parameter <-'sea_surface_temperature' 
id <- 'erdPH53sstnmday'
tag <- "SST."
Sys.setenv(RERDDAP_DEFAULT_URL="https://coastwatch.pfeg.noaa.gov/erddap/")
erdPH53sstnmday=getdat(parameter, id, tag, boxes14, width)
Sys.setenv(RERDDAP_DEFAULT_URL="https://upwell.pfeg.noaa.gov/erddap/")

# Define parameters for the sst 1b dataset 
#https://coastwatch.pfeg.noaa.gov/erddap/info/erdPH2sstdmday/index.html; pathfinder to 2012; NIGHT
parameter <-'sea_surface_temperature' 
id <- 'erdPH2sstnmday'
tag <- "SST."
erdPH2sstnmday=getdat(parameter, id, tag, boxes14, width)

# Define parameters for the sst 1c dataset; use this
#https://coastwatch.pfeg.noaa.gov/erddap/info/erdPH2sstamday/index.html; pathfinder to 2012; DAY and NIGHT
parameter <-'sea_surface_temperature' 
id <- 'erdPH2sstamday'
tag <- "SST."
erdPH2sstamday=getdat(parameter, id, tag, boxes14, width)

# Define parameters for the sst 3 dataset 
#https://coastwatch.pfeg.noaa.gov/erddap/info/erdAGsstamday/index.html; avhrr 2003 to 2016; Day and Night
parameter <-'sst' 
id <- 'erdAGsstamday'
tag <- "SST."
erdAGsstamday=getdat(parameter, id, tag, boxes14, width, include.z=TRUE)

# ICOADS sst 1960 onward
# Poor coastal estimates so not very useful for our purposes
parameter <-'sst' 
id <- 'esrlIcoads1ge' 
tag <- "SST."
esrlIcoads1ge=getdat(parameter, id, tag, boxes14, width, include.z=FALSE)

# Optimum Interpolation Sea Surface Temperature (OISST)
# from AVHRR but interpolated
parameter <-'sst' 
id <- 'ncdcOisst2Agg' 
tag <- "SST."
ncdcOisst2Agg=getdat(parameter, id, tag, boxes14[,1:2], width, include.z=TRUE)
Sys.setenv(RERDDAP_DEFAULT_URL="https://upwell.pfeg.noaa.gov/erddap/")

# Define parameters for the ssh dataset 
#https://coastwatch.pfeg.noaa.gov/erddap/info/erdTAsshmday/index.html
parameter <-'ssh' 
id <- 'erdTAsshmday' #'erdTAsshmday_LonPM180'
tag <- "SSH."
erdTAsshmday=getdat(parameter, id, tag, boxes14, width, include.z=TRUE)

# Define parameters for the wind based upwelling 1 dataset 
#https://coastwatch.pfeg.noaa.gov/erddap/info/erdQSstressmday/index.html
# not wind-based upwelling indices not used in paper
parameter <-'upwelling' 
id <- 'erdQSstressmday'
tag <- "UPW."
erdQSstressmday=getdat(parameter, id, tag, boxes14, width, include.z=TRUE)

 # Define parameters for the ASCAT wind-based upwelling dataset 
 # to continue timeseries past 2009 
#https://coastwatch.pfeg.noaa.gov/erddap/info/erdQAstressmday/index.html
parameter <-'upwelling' 
 id <- 'erdQAstressmday'
 tag <- "UPW."
 erdQAstressmday=getdat(parameter, id, tag, boxes14, width, include.z=TRUE)
 
 #Salinity
 # https://coastwatch.pfeg.noaa.gov/erddap/info/nceiSMOS30sssMonthly/index.html
 # note salinity not used in paper
 parameter <-'sss1' 
 id <- 'nceiSMOS30sssMonthly'
 tag <- "SAL."
 erdQAstressmday=getdat(parameter, id, tag, boxes14, width, include.z=FALSE)
 
 #### Create the SST based upwelling index using 3 degree offshore minus inshore SST
 # Create boxes for inshore and 3 deg offshore
 boxes.upw<-matrix(c(74.7, 12.5,
               75.4, 11.5,
               75.8, 10.5,
               76, 9.5,
               76.8, 8.5,
               71.7, 12.5,
               72.4, 11.5,
               72.8, 10.5,
               73, 9.5,
               73.8, 8.5),ncol=10,nrow=2)
 width=rep(.5,10)
 
 # SST in offshore minus inshore.  Positive value means upwelling
 parameter <-'sst' 
 id <- 'esrlIcoads1ge' 
 tag <- "SST."
 sstupwelling=getdat(parameter, id, tag,  boxes.upw, width, save.csv=FALSE, include.z=FALSE)
 upw.sst = with(sstupwelling, 
                data.frame(Year=Year, Month=Month, 
                           UPW.1=SST.6-SST.1, 
                           UPW.2=SST.7-SST.2,
                           UPW.3=SST.8-SST.3,
                           UPW.4=SST.9-SST.4,
                           UPW.5=SST.10-SST.5))
 yr1=min(upw.sst$Year); yr2=max(upw.sst$Year)
 upw.sst.icoad=upw.sst
 write.csv(upw.sst, paste("upw-sst","-", id,"-",yr1,"-",yr2,".csv",sep=""),row.names=FALSE)
 
 #https://coastwatch.pfeg.noaa.gov/erddap/info/erdPH2sstnmday/index.html; Pathfinder night
 #not used
 parameter <-'sea_surface_temperature' 
 id <- 'erdPH2sstnmday'
 tag <- "SST."
 sstupwelling=getdat(parameter, id, tag,  boxes.upw, width, save.csv=FALSE, include.z=FALSE)
 upw.sst = with(sstupwelling, 
                data.frame(Year=Year, Month=Month, 
                           UPW.1=SST.6-SST.1, 
                           UPW.2=SST.7-SST.2,
                           UPW.3=SST.8-SST.3,
                           UPW.4=SST.9-SST.4,
                           UPW.5=SST.10-SST.5))
 yr1=min(upw.sst$Year); yr2=max(upw.sst$Year)
 upw.sst.PH=upw.sst
 write.csv(upw.sst, paste("upw-sst","-", id,"-",yr1,"-",yr2,".csv",sep=""),row.names=FALSE)

 #https://coastwatch.pfeg.noaa.gov/erddap/info/erdPH2sstamday/index.html; Pathfinder day and night
 #this is the dataset used for the upwelling index for 1981-2002
 parameter <-'sea_surface_temperature' 
 id <- 'erdPH2sstamday'
 tag <- "SST."
 sstupwelling=getdat(parameter, id, tag,  boxes.upw, width, save.csv=FALSE, include.z=FALSE)
 upw.sst = with(sstupwelling, 
                data.frame(Year=Year, Month=Month, 
                           UPW.1=SST.6-SST.1, 
                           UPW.2=SST.7-SST.2,
                           UPW.3=SST.8-SST.3,
                           UPW.4=SST.9-SST.4,
                           UPW.5=SST.10-SST.5))
 yr1=min(upw.sst$Year); yr2=max(upw.sst$Year)
 upw.sst.PH=upw.sst
 write.csv(upw.sst, paste("upw-sst","-", id,"-",yr1,"-",yr2,".csv",sep=""),row.names=FALSE)
 
 #https://coastwatch.pfeg.noaa.gov/erddap/info/erdAGsstamday/index.html; avhrr day and night
 #this is the dataset used for the upwelling index for 2003-2016
 parameter <-'sst' 
 id <- 'erdAGsstamday'
 tag <- "SST."
 sstupwelling=getdat(parameter, id, tag,  boxes.upw, width, save.csv=FALSE, include.z=TRUE)
 upw.sst = with(sstupwelling, 
                data.frame(Year=Year, Month=Month, 
                           UPW.1=SST.6-SST.1, 
                           UPW.2=SST.7-SST.2,
                           UPW.3=SST.8-SST.3,
                           UPW.4=SST.9-SST.4,
                           UPW.5=SST.10-SST.5))
 yr1=min(upw.sst$Year); yr2=max(upw.sst$Year)
 upw.sst.AG=upw.sst
 write.csv(upw.sst, paste("upw-sst","-", id,"-",yr1,"-",yr2,".csv",sep=""),row.names=FALSE)
 
 # For upwelling bakun index, see get_bakun_upi_data.R
 
 # Define parameters for the wind based upwelling 1 dataset 
 #https://coastwatch.pfeg.noaa.gov/erddap/info/jplCcmpL3Wind6Hourly/index.html
 # not wind-based upwelling indices not used in paper
 parameter <-'uwnd' 
 id <- 'jplCcmpL3Wind6Hourly'
 tag <- "CCMP."
 jplCcmpL3Wind6Hourly=getdat(parameter, id, tag, boxes14, width, include.z=FALSE)
 
 parameter <-'vwnd' 
 id <- 'jplCcmpL3Wind6Hourly'
 tag <- "CCMPv."
 jplCcmpL3Wind6Hourly.v=getdat(parameter, id, tag, boxes14, width, include.z=FALSE)
 