rxtracto_3D=function (dataInfo, parameter = NULL, xcoord = NULL, ycoord = NULL, 
          zcoord = NULL, tcoord = NULL, xName = "longitude", yName = "latitude", 
          zName = "altitude", tName = "time", urlbase = "https://upwell.pfeg.noaa.gov/erddap/", 
          verbose = FALSE) 
{
  rerddap::cache_setup()
  callDims <- list(xcoord, ycoord, zcoord, tcoord)
  names(callDims) <- c(xName, yName, zName, tName)
  urlbase <- rerddapXtracto:::checkInput(dataInfo, parameter, urlbase, callDims)
  allCoords <- rerddapXtracto:::dimvars(dataInfo)
  dataCoordList <- rerddapXtracto:::getfileCoords(attr(dataInfo, "datasetid"), 
                                 allCoords, urlbase)
  if (length(dataCoordList) == 0) {
    stop("Error retrieving coordinate variable")
  }
  working_coords <- rerddapXtracto:::remapCoords(dataInfo, callDims, dataCoordList, 
                                urlbase)
  xcoordLim <- working_coords$xcoord1
  if (working_coords$latSouth) {
    ycoordLim <- c(min(working_coords$ycoord1), max(working_coords$ycoord1))
  }
  else {
    ycoordLim <- c(max(working_coords$ycoord1), min(working_coords$ycoord1))
  }
  zcoordLim <- NULL
  if (!is.null(working_coords$zcoord1)) {
    zcoordLim <- working_coords$zcoord1
    if (length(zcoordLim) == 1) {
      zcoordLim <- c(zcoordLim, zcoordLim)
    }
  }
  tcoordLim <- NULL
  if (!is.null(working_coords$tcoord1)) {
    isoTime <- dataCoordList$time
    udtTime <- parsedate::parse_date(isoTime)
    tcoord1 <- rerddapXtracto:::removeLast(isoTime, working_coords$tcoord1)
    tcoord1 <- parsedate::parse_iso_8601(tcoord1)
    tcoordLim <- tcoord1
  }
  dimargs <- list(xcoordLim, ycoordLim, zcoordLim, tcoordLim)
  names(dimargs) <- c(xName, yName, zName, tName)
  dimargs <- Filter(Negate(is.null), dimargs)
  rerddapXtracto:::checkBounds(dataCoordList, dimargs)
  erddapList <- rerddapXtracto:::findERDDAPcoord(dataCoordList, isoTime, udtTime, 
                                xcoordLim, ycoordLim, tcoordLim, zcoordLim, xName, yName, 
                                tName, zName)
  erddapCoords <- erddapList$erddapCoords
  griddapCmd <- rerddapXtracto:::makeCmd(dataInfo, urlbase, xName, yName, zName, 
                        tName, parameter, erddapCoords$erddapXcoord, erddapCoords$erddapYcoord, 
                        erddapCoords$erddapTcoord, erddapCoords$erddapZcoord, 
                        verbose)
  griddapExtract <- do.call(rerddap::griddap, griddapCmd)
  datafileID <- ncdf4::nc_open(griddapExtract$summary$filename)
  dataX <- ncdf4::ncvar_get(datafileID, varid = xName)
  dataY <- ncdf4::ncvar_get(datafileID, varid = yName)
  if (!is.null(zcoord)) {
    dataZ <- ncdf4::ncvar_get(datafileID, varid = zName)
  }
  if (!is.null(tcoord)) {
    datatime <- ncdf4::ncvar_get(datafileID, varid = "time")
    datatime <- as.POSIXlt(datatime, origin = "1970-01-01", 
                           tz = "GMT")
  }
  param <- ncdf4::ncvar_get(datafileID, varid = parameter, 
                            collapse_degen = FALSE)
  ncdf4::nc_close(datafileID)
  tempCoords <- rerddapXtracto:::readjustCoords(param, dataX, dataY, xcoord, 
                               datafileID, callDims)
  dataX <- tempCoords$dataX
  dataY <- tempCoords$dataY
  extract <- list(NA, NA, NA, NA, NA, NA)
  extract[[1]] <- tempCoords$param
  extract[[2]] <- attributes(dataInfo)$datasetid
  extract[[3]] <- dataX
  extract[[4]] <- dataY
  if (!is.null(zcoord)) {
    extract[[5]] <- dataZ
  }
  if (!is.null(tcoord)) {
    extract[[6]] <- datatime
  }
  if (grepl("etopo", extract[[2]])) {
    names(extract) <- c("depth", "datasetname", xName, yName, 
                        zName, "time")
  }
  else {
    names(extract) <- c(parameter, "datasetname", xName, 
                        yName, zName, "time")
  }
  copyFile <- paste0(getwd(), "/", parameter, ".nc")
  iFile <- 1
  while (file.exists(copyFile)) {
    copyFile <- paste0(getwd(), "/", parameter, "_", iFile, 
                       ".nc")
    iFile <- iFile + 1
  }
  fcopy <- file.copy(griddapExtract$summary$filename, copyFile)
  if (!fcopy) {
    print("copying and renaming downloaded file from default ~/.rerddap failed")
  }
  rerddap::cache_delete(griddapExtract)
  return(extract)
}