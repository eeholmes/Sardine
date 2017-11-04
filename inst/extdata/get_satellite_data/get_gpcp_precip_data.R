# This downloads the gpcp nc files, reads, and save information

#instructions here
# http://climvis.de/read-plot-netcdf-files-r/

#nc files are here
# https://www.ncei.noaa.gov/data/global-precipitation-climatology-project-gpcp-monthly/access/

# The boxes are 
# Kerala Lat(8.75,  11.25), Lon(73.25,  75.75)
# Karnataka Lat(13.75,  16.25), Lon(71.25,  73.75)
# determined by the 2.5 deg grid of the gpcp dataset

#make sure wd is get_satellite_data
#set up the data frame
years=1979:as.numeric(format(Sys.Date(),"%Y"))
precip.yr=rep(years,each=12)
precip.mon=rep(1:12,length(years))
precip=data.frame(Year=precip.yr, Month=precip.mon, precip.gpcp.kerala=NA, precip.gpcp.karnataka=NA)

# Download the nc file, read it, and store precip values
require(ncdf4)
require(RCurl) #for url.exists
require(XML) #for readHTMLTable
require(stringr) #for str_detect and str_locate
dwld=FALSE
# Select: variable and year
var='Precipitation'
for(year in years){
  baseurl=paste("https://www.ncei.noaa.gov/data/global-precipitation-climatology-project-gpcp-monthly/access/", year, "/", sep="")
  a=readHTMLTable(getURL(baseurl))[[1]]
  a=na.omit(a)
  files=apply(a,1,function(x){x[which(str_detect(x,"gpcp_v02r03"))]})
  files=unlist(files)
  mon.locs=str_locate(files,paste("d",year,sep=""))
  mon.locs[,1]=mon.locs[,2]+1
  mon.locs[,2]=mon.locs[,1]+1
  mons=as.numeric(str_sub(files,mon.locs))
  for(i in 1:length(files)){
    fil=files[i]
    month=mons[i]
# Download netCDF file
url=paste("https://www.ncei.noaa.gov/data/global-precipitation-climatology-project-gpcp-monthly/access/", year, "/", fil, sep="")
dfile=paste("precip/",var,'-',year,'-',month,'.nc', sep='')
if(dwld){
  if(!url.exists(url)) next
  download.file(url, destfile=dfile, mode="wb")
}

nc=nc_open(dfile)

dataX <- ncdf4::ncvar_get(nc, varid = "longitude")
dataY <- ncdf4::ncvar_get(nc, varid = "latitude")
param <- ncdf4::ncvar_get(nc, varid = "precip")

Y1=which(dataY==8.75) #latitude
X1=which(dataX==73.75) #longitude
p1=ncvar_get(nc, varid = "precip", start=c(X1, Y1, 1), count=c(1,1,1))
precip$precip.gpcp.kerala[precip$Year==year & precip$Month==month]=p1

Y1=which(dataY==13.75)
X1=which(dataX==71.25)
p2=ncvar_get(nc, varid = "precip", start=c(X1, Y1, 1), count=c(1,1,1))
precip$precip.gpcp.karnataka[precip$Year==year & precip$Month==month]=p2
nc_close(nc)
  }
}

write.csv(precip, file="../raw data files and code/precipitation_gpcp.csv",row.names=FALSE)
