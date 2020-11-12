## FUNCTIONS

# Get data from the Coastwatch ERDDAP server. General function. id is the name of the product
getdata <- function(id, pars=NULL, lat=c(7,15), lon=c(70,78), date=NULL, altitude=10){
    url <- paste0("https://coastwatch.pfeg.noaa.gov/erddap/info/", id, "/index.csv")
    meta <- read.csv(url)

  if(!missing(date) && length(date)==1) date <- c(date, date)
  if(missing(date)) date <- c(meta$Value[meta$Attribute.Name=="time_coverage_start"], meta$Value[meta$Attribute.Name=="time_coverage_end"])

    lat1 <- lat[1]; lat2 <- lat[2]
    lon1 <- lon[1]; lon2 <- lon[2]
    dfil <- paste0(id, "-", lat1, "-", lat2, "-", lon1, "-", lon2, "-", stringr::str_sub(date[1], 1, 10), "-", stringr::str_sub(date[2], 1, 10), ".csv")
  dfil <- file.path(here::here(), "inst", "extdata", "get_satellite_data",
                    "Replicate_EMT", dfil)
  
  if(!file.exists(dfil)){
    if(missing(pars)){
      pars <- unique(meta$Variable.Name)
      pars <- pars[!(pars %in% c("NC_GLOBAL", "time", "latitude", "longitude", "altitude"))]
    }
  # if altitude is req in url, add it
  alttag <- ifelse("altitude" %in% meta$Variable.Name, paste0("[(",altitude,"):1:(",altitude,")]"), "")
  val <- paste0("[(", date[1], "):1:(", date[2], ")]",alttag,"[(",lat1,"):1:(",lat2,")][(",lon1,"):1:(",lon2,")]")
  val2 <- paste0(pars, val, collapse=",")
  url <- paste0("https://coastwatch.pfeg.noaa.gov/erddap/griddap/", id, ".csv?", val2)
  download.file(url, destfile=dfil)
  cat("data saved to", dfil, "\n")
  }else{
  cat("data read from", dfil, "\n")
}
  dat <- read.csv(file=dfil, stringsAsFactors = FALSE)
  dat <- dat[-1,]
  for(i in 2:ncol(dat)) dat[[i]] <- as.numeric(dat[[i]])
  dat$time <- as.POSIXlt(dat$time, format="%Y-%m-%dT%H:%M:%OSZ", tz="UTC")
  attr(dat, "resolution") <- as.numeric(meta$Value[meta$Attribute.Name=="geospatial_lat_resolution"])
  cat(paste0("data ", id, " date ", date[1], "-", date[2], ", latitude ", lat1, "-", lat2, ", longitude ", lon1, "-", lon2), "\n")
  dat
}

# Coefficient of drag
# This is the function used for Ekman transport calcs https://oceanview.pfeg.noaa.gov/products/upwelling/bakun under 1-degree Upwelling Index Products
# A non-linear drag coefficient is used based on Large and Pond (1981) modified for low wind speeds as in Trenberth et al. (1990)
Cd <- function(wind.speed){
  wind.orig <- wind.speed
  wind.speed[is.na(wind.speed)] <- -Inf
  Cd <- wind.orig
  Cd[wind.speed <= 1] <- 2.18
  Cd[wind.speed < 3 & wind.speed > 1] <- 0.62+1.56/wind.speed[wind.speed < 3 & wind.speed > 1]
  Cd[wind.speed >= 3 & wind.speed < 10] <- 1.14
  Cd[wind.speed >= 10] <- 0.49 + 0.065*wind.speed[wind.speed >= 10]
  Cd[is.na(wind.orig)] <- NA
  return(Cd*.001)
}

# get u and v from pressure (msl) measurements
# page 7 of Schwing, F. B., O'Farrell, M., Steger, J., and Baltz, K., 1996: Coastal Upwelling Indices, West Coast of North America 1946 - 1995, NOAA Technical Memorandum NMFS-SWFSC-231
getwindfromP <- function(dat){
  if(is.null(attr(dat, "resolution"))) stop("need resolution in the data.frame")
  if(!any(c("P_msl", "p_msl") %in% colnames(dat))) stop("need P_msl or p_msl (pressure) in data")
  for(i in c("u", "v", "P"))
    if(any(colnames(dat)==i)){
      warning(paste0(i, " is already in data. Changing to ", i, "_orig", "\n"))
      colnames(dat)[colnames(dat)==i] <- paste0(i, "_orig")
    }
  
  res <- attr(dat, "resolution")
  lons <- sort(unique(dat$longitude))
  lats <- sort(unique(dat$latitude))
  dat$ug <- NA; dat$vg <- NA
  # pressure in Pascal kg/m s-2
  dat$P <- 100*dat[,tolower(colnames(dat))=="p_msl"] #deal with colname being P_msl or p_msl
  
  # constants
  # h is grid resolution in radians
  h <- pi*res/180
  pa <- 1.22 # kg/m3
  omega <- 7.272205e-05 #(rad/s) used for the SWFSC calcs
  f <- 2*omega*sin(pi*dat$latitude/180)
  R <- 6371 * 1000 # meters https://nssdc.gsfc.nasa.gov/planetary/factsheet/earthfact.html

  if(length(lats)>2)
    for(lat in (min(lats)+res):(max(lats)-res)){
      dPdlat <- (dat$P[dat$latitude==(lat+res)]-dat$P[dat$latitude==(lat-res)])/(2*h)
      constant <- (f*pa*R)[dat$latitude==lat]
      ug <- -1*dPdlat/constant
      dat$ug[dat$latitude==lat] <- ug
    }
  if(length(lons)>2)
    for(lon in (min(lons)+res):(max(lons)-res)){
      dPdlon <- (dat$P[dat$longitude==(lon+res)]-dat$P[dat$longitude==(lon-res)])/(2*h)
      constant <- (f*pa*R*cos(pi*dat$latitude/180))[dat$longitude==lon]
      vg <- dPdlon/constant
      dat$vg[dat$longitude==lon] <- vg
    }
  
  # To approximate frictional effects, the geostrophic wind at the sea surface is estimated by rotating the geostrophic wind 15 deg to the left and reducing its magnitude by 30%
  ang <- pi*30/360
  u <- 0.7*(cos(ang)*dat$ug - sin(ang)*dat$vg)
  v <- 0.7*(sin(ang)*dat$ug + cos(ang)*dat$vg)
  dat$u <- u
  dat$v <- v
  
  return(dat)
}

# Get from u and v only
# Schwing, F. B., O'Farrell, M., Steger, J., and Baltz, K., 1996: Coastal Upwelling Indices, West Coast of North America 1946 - 1995, NOAA Technical Memorandum NMFS-SWFSC-231 using the modified Cd
getEMT <- function(dat, coast_angle=NULL){
  if(!any(colnames(dat)=="u")) stop("need u in data")
  if(!any(colnames(dat)=="v")) stop("need v in data")
  for(i in c("uv_mag", "tau", "taux", "tauy", "EMT", "ektrx", "ektry", "upi"))
    if(any(colnames(dat)==i)){
      warning(paste0(i, " is already in data. Changing to ", i, "_orig\n"))
      colnames(dat)[colnames(dat)==i] <- paste0(i, "_orig")
    }
  
  pa <- 1.22 # kg/m3
  omega <- 7.272205e-05 #(rad/s) used for the SWFSC calcs
  f <- 2*omega*sin(pi*dat$latitude/180)
  # Compute tau; get taux and tauy from u and v
  uv_mag <- sqrt(dat$u^2+dat$v^2)
  tau  <- pa*Cd(uv_mag)*uv_mag*uv_mag
  tauy <- pa*Cd(uv_mag)*uv_mag*dat$v
  taux <- pa*Cd(uv_mag)*uv_mag*dat$u
  EMT <- tau/f
  # MASS TRANSPORT IS PERPENDICULAR TO WIND
  # u/taux positive is west to east wind so into india w coast
  # wind blowing west to east means EMT toward equator (negative)
  EMTy <- -1*taux/f
  # v/tauy negative is wind blowing south toward equator
  # Negative v (south) means EMT to west (off-shore)
  # EMTx is the one that drives upwelling since coast is mostly n-s
  # Negative EMTx = directed offshore = positive upwelling
  EMTx <- tauy/f
  dat$uv_mag <- uv_mag
  dat$tau <- tau
  dat$taux <- taux
  dat$tauy <- tauy
  dat$EMT <- EMT
  dat$ektrx <- EMTx
  dat$ektry <- EMTy
  if(!missing(coast_angle)){
    dat$EMTperp <- EMTperp(dat$ektrx, dat$ektry, coast_angle)$perp
    dat$upi <- upwell(dat$ektrx, dat$ektry, coast_angle)
  }
  return(dat)
}

EMTperp <- function(ektrx, ektry, coast_angle) {
  pi <- 3.1415927
  degtorad <- pi/180.
  alpha <- (180 - coast_angle) * degtorad
  s1 <- cos(alpha)
  t1 <- sin(alpha)
  s2 <- -1 * t1
  t2 <- s1
  perp <- (s1 * ektrx) + (t1 * ektry)
  para <- (s2 * ektrx) + (t2 * ektry)
  return(list(perp=perp, para=para))
}

upwell <- function(ektrx, ektry, coast_angle) {
  pi <- 3.1415927
  degtorad <- pi/180.
  alpha <- (360 - coast_angle) * degtorad
  s1 <- cos(alpha)
  t1 <- sin(alpha)
  s2 <- -1 * t1
  t2 <- s1
  perp <- (s1 * ektrx) + (t1 * ektry)
  para <- (s2 * ektrx) + (t2 * ektry)
  return(perp/10)
}

grid.average.25 <- function(dat){
  # only for .25 to 1 grid
  newdat <- c()
  dat$date <- as.Date(dat$time)
  res <- attr(dat, "resolution")
  for(thedate in unique(format(dat$date)))
    for(lon in sort(unique(dat$longitude)))
      for(lat in sort(unique(dat$latitude))){
        tmp <- subset(dat, 
                      date==as.Date(thedate) &
                        longitude >= lon-res & longitude <= lon+res &
                        latitude >= lat-res & latitude <= lat+res)
        v <- sum(tmp$y_wind, na.rm=TRUE)
        u <- sum(tmp$x_wind, na.rm=TRUE)
        tmp <- subset(dat, 
                      date==as.Date(thedate) &
                        (longitude == lon-2*res | longitude == lon+2*res) &
                        latitude >= lat-res & latitude <= lat+res)
        v <- v + 0.5*sum(tmp$y_wind, na.rm=TRUE)
        u <- u + 0.5*sum(tmp$x_wind, na.rm=TRUE)
        tmp <- subset(dat, 
                      date==as.Date(thedate) &
                        (latitude == lat-2*res | latitude == lat+2*res) &
                        longitude >= lon-res & longitude <= lon+res)
        v <- v + 0.5*sum(tmp$y_wind, na.rm=TRUE)
        u <- u + 0.5*sum(tmp$x_wind, na.rm=TRUE)
        tmp <- subset(dat, 
                      date==as.Date(thedate) &
                        (latitude == lat-2*res | latitude == lat+2*res) &
                        (longitude == lon-2*res | longitude == lon+2*res))
        v <- v + 0.25*sum(tmp$y_wind, na.rm=TRUE)
        u <- u + 0.25*sum(tmp$x_wind, na.rm=TRUE)
        tmp <- data.frame(date=as.Date(thedate), latitude=lat, longitude=lon, 
                          u=u/16, v=v/16)
        newdat <- rbind(newdat, tmp)
      }
}


