#' Oil sardine landings in metric tons by quarter
#'
#' A dataset containing the landings (in metric tons) of oil sardines in Kerala, Karnataka and Goa states 1956-2016.  The data are collected and processed into a total landings estimates based on a stratified sampling of landing sites along the SW coast of India throughout the year.  The program is run by the Central Marine Fisheries Research Institute (CMFRI) in Cochin, India.  The data were obtained from reports published by CMFRI; see references.
#'
#' @format A data frame 'oilsardine_qtr' with 6 variables:
#' \describe{
#'   \item{Year}{Year}
#'   \item{Qtr}{Quarter 1 to 4}
#'   \item{Goa}{Goa landings}
#'   \item{Karnataka}{Karnataka landings}
#'   \item{Kerala}{Kerala landings}
#'   \item{SWCoast}{SW Coast landings}
#' }
#' 
#' @references 
#' CMFRI reports were downloaded from the CMFRI Publication repository \url{http://www.cmfri.org.in}.
#' 
#' 1956-1968 (Note Mysore which later becomes Karnataka) \insertRef{Raja1969}{SardineForecast}
#' 
#' 1968-1978 \insertRef{Pillai1982}{SardineForecast}
#' 
#' 1975-1984 Kerala \insertRef{Jacobetal1987}{SardineForecast}
#' 
#' 1975-1984 Kernataka \insertRef{Kurupetal1987}{SardineForecast}
#' 
#' 1985-2014 Provided by CMFRI directly via a data request.
"oilsardine_qtr"

#' Oil sardine landings in metric tons by calendar year
#'
#' A dataset containing the calendar year (Jan-Dec) landings (in metric tons) of oil sardines in Kerala, Karnataka and Goa states 1956-2016.  The data are collected and processed into a total landings estimates based on a stratified sampling of landing sites along the SW coast of India throughout the year.  The program is run by the Central Marine Fisheries Research Institute (CMFRI) in Cochin, India.  The data were obtained from reports published by CMFRI; see references.
#'
#' @format A data frame 'oilsardine_qtr' with 6 variables:
#' \describe{
#'   \item{Year}{Year}
#'   \item{Goa}{Goa landings}
#'   \item{Karnataka}{Karnataka landings}
#'   \item{Kerala}{Kerala landings}
#' }
#' 
#' @references 
#' See oilsardine_qtr for the 1956-2015 sources. 2016-present were taken from
#' the Fish Catch Estimates provided on the CMFRI website
"oilsardine_yr"


#' Ocean Climate Indices
#' 
#' @description
#' Oceanic Nino Index, Equatorial Southern Oscillation Index and Dipole Mode Index
#'
#' @details
#' The ONI index is 3 month running mean of ERSST.v5 SST anomalies in the Niño 3.4 region 
#' (5°N-5°S, 120°-170°W)], based on centered 30-year base periods updated every 5 years.  
#' The ONI was downloaded as follows:
#' \preformatted{
#' require(XML)
#' require(RCurl)
#' require(httr)
#' oni=read.table("http://www.cpc.ncep.noaa.gov/data/indices/oni.ascii.txt", stringsAsFactors=FALSE)
#' }
#' The SOI used is the Equatorial SOI monthly.  The data were downloaded with the following code.
#' \preformatted{
#' soi=read.table("http://www.cpc.ncep.noaa.gov/data/indices/reqsoi.for", stringsAsFactors=FALSE)
#' }
#' The DMI  is the monthly Dipole Mode Index.  
#' The DMI (also IOD index) is defined by the SSTA difference between the 
#' western Indian Ocean (10°S–10°N, 50°E–70°E) and the southeastern Indian Ocean (10°S–0°, 90°E–110°E).
#' The data were downloaded from the NOAA Earth Systems Research Laboratories with the following code.
#' \preformatted{
#' dmi=read.table("https://www.esrl.noaa.gov/psd/gcos_wgsp/Timeseries/Data/dmi.long.data", skip=1, nrows=149)
#' }
#' The NAO  is the monthly North Atlantic Oscillation Index.  
#' The North Atlantic Oscillation (NAO) index is based on the surface sea-level pressure difference between the Subtropical (Azores) High and the Subpolar Low. 
#' The data were downloaded from the NOAA Climate Prediction Center with the following code.
#' \preformatted{
#' nao = read.table("ftp://ftp.cpc.ncep.noaa.gov/wd52dg/data/indices/nao_index.tim", skip=9, nrows=length(1950:2018)*12)
#' }
#' The PDO  is the monthly Pacific Decadal Oscillation Index and the AMO is the Atlantic Multidecadal Oscillation.  The PDO is an index of the sea surface temperature anomalies over the North Pacific Ocean. The AMO is based on sea-surface temperature oscillations in the North Atlantic Ocean.  The data were downloaded from the NOAA Physical Sciences Laboratory with the following code.
#' \preformatted{
#' pdo = read.table("https://psl.noaa.gov/tmp/gcos_wgsp/data.143.131.2.6.325.11.4.55", skip=0, nrows=length(1948:2017)*12)
#' amo <- read.table("https://psl.noaa.gov/tmp/gcos_wgsp/data.143.131.2.6.325.11.25.33", skip=0, nrows=length(1948:2017)*12)
#' }
#' 
#' @format A data frame with variables:
#' \describe{
#'   \item{Year}{}
#'   \item{Month}{For ONI and SOI, this is a 3-month average.  Jan value is average of Dec-Jan-Feb.  Qtr would be denoted JFM.}
#'   \item{ONI}{The ONI index value}
#'   \item{SOI}{The SOI index value}
#'   \item{DMI}{The DMI index value}
#'   \item{MEI}{The MEI index value}
#'   \item{NAO}{The NAO index value}
#'   \item{PDO}{The PDO index value}
#'   \item{AMO}{The AMO index value}
#' }
#' 
#' @references
#' 
#' \insertRef{SajiYamagata2003}{SardineForecast}
#' 
#' \insertRef{vandenDooletal2000}{SardineForecast}
#' 
#' \insertRef{Mantuaetal1997}{SardineForecast}
#' 
#' \insertRef{Newmanetal2016}{SardineForecast}
#' 
#' \insertRef{Enfieldetal2001}{SardineForecast}
#' 
"enso"

#' Precipitation data
#'
#' @description Three precipition datasets off the SW coast of India.  Two are satellite derived and one is based on land gauges.
#' 
#' @details
#' The National Climatic Data Center provides basic information on the GPCP Precipitation dataset.  
#' The dataset consists of monthly precipitation estimates (average mm/day) from January 1979 to 
#' the present. The precipitation estimates merge several satellite and in situ sources into a 
#' final product. Data are provided on a 2.5 degree grid.  The GPCP Precipitation data are 
#' provided by the NOAA/NCEI Global Precipitation Climatology Project and were downloaded from 
#' \url{https://www.ncei.noaa.gov/data/global-precipitation-climatology-project-gpcp-monthly}.  Two boxes were defined, one off the Kerala coast and one off the Karnataka coast, and the average values of all grid points within these boxes were used.
#' \preformatted{
#' The boxes are 
#' Kerala Lat(8.75,  11.25), Lon(73.25,  75.75)
#' Karnataka Lat(13.75,  16.25), Lon(71.25,  73.75)
#' }
#' 
#' The land gauge data is monthly, seasonal and annual rainfall (in mm) area weighted average for each state in India starting from 1901 onwards. This data set is based on rain guages.  The data are provided by the India Meteorological Department (Ministry of Earth Sciences).  The 1901 to 2014 data were downloaded from the Open Government Data Platform India \url{https://data.gov.in}.  The raw data are in the file 'Area_Weighted_Monthly_Seasonal_And_Annual_Rainfall_0.csv' in the extdata folder.  The 2015 and 2016 data were extracted from the yearly Rainfall Statistics reports (see references).
#' 
#' NASA's Tropical Rainfall Measuring Mission (TRMM) website provides background on the TRMM data (\url{https://pmm.nasa.gov/}).  1997 to 2015 monthly precipitation estimates on a 0.25 degree grid were downloaded from the Tropical Rainfall Measuring Mission (TRMM) website.  The data are averaged in the 2.5 x 2.5 degree boxes used for the other satellite data.
#' 
#' @format A data frame with:
#' \describe{
#'   \item{Year}{}
#'   \item{Month}{}
#'   \item{precip.gpcp.kerala}{Monthly GPCP precipitation in the box off the Kerala coast. Units are average mm/day.}
#'   \item{precip.gpcp.karnataka}{Monthly GPCP precipitation in the box off the Karnataka coast.  Units are average mm/day.}
#'   \item{PrecipTRMM}{Monthly precipitation estimates from the Tropical Rainfall Measuring Mission (TRMM).  Data are averaged in the boxes 1 to 13 used for the other satellite data.}
#'   \item{Precip.Kerala}{Monthly precipitation (mm) from landgauges.}
#' }
#' 
#' @references
#' 
#' \insertRef{Adleretal2003}{SardineForecast}
#' 
#' \insertRef{Adleretal2016}{SardineForecast}
#' 
#' \insertRef{PurohitKaur2016}{SardineForecast}
#' 
#' \insertRef{KothawaleRajeevan2017}{SardineForecast}
#' 
#' \insertRef{NCEI2017}{SardineForecast}

"precip"


#' India monsoon onset dates
#' 
#' @description
#' India monsoon onset dates relative to average June 1st arrival date into SW India.  
#'
#' @details
#' The onset dates were extracted from the annual monsoon reports.  These reports contain a section on the 'Onset and Advance of the Southwest Monsoon' which gives the date that the southwest monsoon set in over Kerala. The onset is given as the number of days before or after June 1st.  0 indicates that the monsoon arrived on June 1st.  1 would indicate that it arrived on June 2nd. -1 indicates it arrived on May 31.
#'
#' @format A data frame with variables:
#' \describe{
#'   \item{Year}{}
#'   \item{Onset}{The arrival date relative to June 1st.  Monsoon arrival is defined in the monsoon reports.}
#' }
#' 
#' @references 
#' 
#' \insertRef{PaiandBhan2016}{SardineForecast}
"onset"

#' Sea surface temperature data from remote-sensing products
#'
#' @description The SST satellite data were downloaded from the NOAA ERDDAP server using Roy Mendelssohn's
#' \strong{rerddapXtracto} R package which uses the ropensci\strong{rerddap} R package available on CRAN.  The R code used
#' to download the data is in the \code{extdata/get_satelite_data} folder.  See examples for how to find
#' the file. Units are degree Celsius.
#' 
#' @details
#' There are two SST data sets: AVHRR and ICOADS.
#' 
#' \strong{AVHRR}
#' The SST differential upwelling indices were computed from the SST Daily Optimum
#' Interpolation (OI), AVHRR Only, Version 2.1, Final 0.25 degree grid, Global data
#' downloaded from the NOAA ERDDAP server. These are daily data. They daily data were
#' averaged over all days in each month to produce monthly averages.
#' The SST estimates use the
#' Advanced Very-High Resolution Radiometer (AVHRR) instruments. AVHRR is 
#' accurate for close to the coast and thus could be used for our SST differential upwelling
#' index.
#'    
#' The SST data were downloaded from the NOAA ERDDAP server. See
#'     \url{https://coastwatch.pfeg.noaa.gov/erddap/info/ncdcOisst21Agg/index.html}.
#'
#' \strong{ICOADS}
#'  The SST was extracted from the International Comprehensive Ocean-Atmosphere Data Set (ICOADS) 
#'  collection of surface marine data
#'  Data from 1960 onward were used, which are on a 1°x1° grid. 
#'  
#' The ICOADS SST data were downloaded from the NOAA ERDDAP server.
#' \url{https://coastwatch.pfeg.noaa.gov/erddap/info/esrlIcoads1ge/index.html}
#' More information on the ICOADS data are available at
#' \url{https://coastwatch.pfeg.noaa.gov/erddap/info/esrlIcoads1ge/index.html}


#' The R code used
#' to download the data is in the \code{extdata/get_satelite_data} folder.  See examples
#' for how to find and view the files.  The SST values were averaged across thirteen
#' 1 degree by 1 degree boxes which roughly parallel the bathymetry.  
#' 
#' @format A data frame with:
#' \describe{
#'   \item{Year}{The year}
#'   \item{Month}{The month}
#'   \item{SST.1 to SST.13}{Average monthly SST averaged over boxes 1 to 13. Units are degree Celcius.}
#'   \item{SSTICOAD.1 to SSTICOAD.13}{Average monthly SST averaged over boxes 1 to 13. Units are degree Celcius.}
#' }
#' 
#' @references
#' The AVHRR data were provided by GHRSST and the US National Oceanographic Data Center. 
#' This project was supported in part by a grant from the NOAA Climate Data Record 
#' (CDR) Program for satellites. The data were downloaded from NOAA CoastWatch-West 
#' Coast Regional Node and Southwest Fisheries Science Center's Environmental 
#' Research Division. To cite these data in a paper, please follow the instructions 
#' in the license and at this link: 
#' \url{https://coastwatch.pfeg.noaa.gov/erddap/information.html#citeDataset}
#' 
#' The ICOADS data were provided by the NOAA/OAR/ESRL PSD, Boulder, Colorado, USA,
#' from their Web site at http://www.esrl.noaa.gov/psd/ (and downloaded via NOAA's
#' CoastWatch data server.)
#' 
#' \insertRef{Caseyetal2010}{SardineForecast}
#' 
#' \insertRef{Waltonetal1998}{SardineForecast}
#' 
#' \insertRef{rerddap}{SardineForecast}
#' 
#' \insertRef{rerddapXtracto}{SardineForecast}
#' 
#' @examples
#' \dontrun{
#' # Show the R code that downloaded the data
#' file.show(system.file("extdata/get_satellite_data", "get_sat_data.R", package="SardineForecast"))
#' 
#' # Show the background files on each data set at the time the data were downloaded
#' browseURL(system.file("extdata/get_satellite_data/ERDDAP_background", "erdAGsstamday.html", package="SardineForecast"))
#' browseURL(system.file("extdata/get_satellite_data/ERDDAP_background", "erdPH2sstamday.html", package="SardineForecast"))
#' 
#' # Show the boxes
#' browseURL(system.file("docs", "kerala_study_area_with_inset.jpg", package="SardineForecast"))
#' }
"sst"

#' Chlorophyll-a data from remote-sensing products
#'
#' @description The CHL satellite data (mg/m$^3$) were downloaded from the NOAA ERDDAP server using 
#' Roy Mendelssohn's
#'  \strong{rerddapXtracto} R package which uses the ropensci\strong{rerddap} R packages available on CRAN.  The R code used
#' to download the data is in the \code{extdata/get_satelite_data} folder.  See examples for how to find
#' the file.
#' 
#' @details
#' 
#' The Chlorophyll-a products are developed by the
#' Ocean Biology Processing Group in the Ocean Ecology Laboratory
#' at the NASA Goddard Space Flight Center.
#' 
#' For September 1997 to 2002, we used the Chlorophyll-a 2018.0 Reprocessing (R2018.0) product 
#' from the Sea-viewing Wide Field-of-view 
#' Sensor (SeaWiFS) on the Orbview-2 satellite. These data are on a 0.083 degree grid.  See reference below.
#'    
#' For 2003 to 2017, we used the MODIS-Aqua R2018.1 product on a 0.0416 degree. These CHL data are taken from measurements 
#' gathered by the Moderate 
#' Resolution Imaging Spectroradiometer (MODIS) 
#' on NASA's Aqua Spacecraft. See reference below.
#'    
#' Both CHL data sets were downloaded from the NOAA ERDDAP server. See
#'     \url{https://coastwatch.pfeg.noaa.gov/erddap/info/erdSW2018chlamday/index.html} and 
#'     \url{https://coastwatch.pfeg.noaa.gov/erddap/info/erdMH1chlamday/index.html}.
#'    
#' The R code used
#' to download the data is in the \code{extdata/get_satelite_data} folder.  See examples
#' for how to find and view the files.  The CHL values were averaged across thirteen
#' 1 degree by 1 degree boxes 
#' which roughly parallel the bathymetry.  See the figure in the examples below which shows
#' the boxes. 
#' 
#' @format A data frame with:
#' \describe{
#'   \item{Year}{The year}
#'   \item{Month}{The month}
#'   \item{CHL.1 to CHL.13}{Average monthly CHL averaged over boxes 1 to 13. Units are mg/m$^3$.}
#' }
#' 
#' @references
#' 
#' NASA Goddard Space Flight Center, Ocean Ecology Laboratory, 
#' Ocean Biology Processing Group; (2018): SeaWiFS Ocean Color Data; 
#' NASA Goddard Space Flight Center, Ocean Ecology Laboratory, 
#' Ocean Biology Processing Group. \url{https://dx.doi.org/10.5067/ORBVIEW-2/SEAWIFS/L3B/CHL/2018}
#' 
#' NASA Goddard Space Flight Center, Ocean Ecology Laboratory, Ocean 
#' Biology Processing Group. Moderate-resolution Imaging 
#' Spectroradiometer (MODIS) Aqua Chlorophyll Data; 2014 Reprocessing. 
#' NASA OB.DAAC, Greenbelt, MD, USA. \url{https://dx.doi.org/10.5067/AQUA/MODIS/L3M/CHL/2018}
#' 
#' 
#' \insertRef{Huetal2012}{SardineForecast}
#' 
#' \insertRef{rerddap}{SardineForecast}
#' 
#' \insertRef{rerddapXtracto}{SardineForecast}
#' 
#'  
#' @examples
#' \dontrun{
#' # Show the R code that downloaded the data
#' file.show(system.file("extdata/get_satellite_data", "get_sat_data.R", package="SardineForecast"))
#' 
#' # Show the background files on each data set at the time the data were downloaded
#' browseURL(system.file("extdata/get_satellite_data/ERDDAP_background", "erdSW1chlamday", package="SardineForecast"))
#' browseURL(system.file("extdata/get_satellite_data/ERDDAP_background", "erdMH1chlamday", package="SardineForecast"))
#' 
#' # Show the boxes
#' browseURL(system.file("docs", "kerala_study_area_with_inset.jpg", package="SardineForecast"))
#' }
"chl"

#' Monthly tide height data from Cochin
#' 
#' @aliases tidelevel
#'
#' @description Tide height data were downloaded form three sources to provide a 1939 to 2018
#' time series of tide height at Cochi. The Cochi tide gauge is on Willington Island; 
#' \href{https://www.gloss-sealevel.org/gloss-station-handbook?stn=32}{GLOSS# 032}, UH#174, 
#' \href{http://www.ioc-sealevelmonitoring.org/station.php?code=coch}{IOC#coch}
#' and \href{https://www.psmsl.org/data/obtaining/stations/438.php}{PSMSL#438}.
#' The data are the raw tide gauge values, which are the mm above the datum for this gauge.  The datum
#' is 1.94m below BM27.
#'   
#' Sea level measurements are affected by the local barometric pressure, and
#' it is common to apply the inverted barometer correction which uses
#' the difference between the current air pressure and the mean air pressure.
#' However Srinivas and Kumar (2006) found that for the Cochin tide height measurements,
#' "There is no significant difference between the seasonal march of the observed 
#' sea level and CSL [corrected sea level]". Therefore we use the raw sea level data with no
#' correction.
#'  
#' Srinivas et al. (2005) and Srinivas and Kumar (2006) found a positive correlation
#' between the Southern Oscillation Index (SOI) and mean sea level for 1976-1993,
#' with the sea level decreasing during El Nino years and increasing during La Nina years. 
#' Singh (2006) also found this correlation but for Sept only for Cochin. A Singh (2006) also found
#' a correlation between the monthly rainfall in the SW monsoon season and mean sea level. Srinivas
#' and Kumar (2006) also found a relationship between the along shore winds and sea level height at
#' Cochi. Note that this relationship between sea level and SOI does not seem to hold for the entire
#' 1939-2018 time series.
#' 
#' @details
#' 
#' For 1939 to 2013, mean monthly tide height was downloaded from the Permanent Service for Mean
#' Sea Level (PSMSL), (PSMSL 2019, Holgate et al. 2013). This is from the tide gauge at Cochin on 
#' Willington Island (Lat 9.966667, Lon 76.266667). The data are the raw tide level data, termed
#' the 'metric' data on the PSMSL website. Download link was 
#' \url{https://www.psmsl.org/data/obtaining/met.monthly.data/438.metdata}
#'
#' In 2011, a automatic tide gauge was installed which provides minute tide height data. Data
#' from 2011 onward are provided by Indian National Centre for Ocean Information Services (INCOIS)
#' and hosted at \url{http://www.ioc-sealevelmonitoring.org} and the
#' University of Hawaii Sea Level Center (UHSLC) \url{https://uhslc.soest.hawaii.edu/}. Research quality
#' data are not available for Cochin (UH# 174). Instead the Fast Delivery data were used
#' and quality control (outlier removal) was applied to the downloaded data per the algorithm 
#' used by IOC Sea Level Monitoring (FAQ \url{http://www.ioc-sealevelmonitoring.org/service.php}).
#' 
#' Daily minute tide level data were downloaded from \url{http://www.ioc-sealevelmonitoring.org/station.php?code=coch}
#' and outlier removal applied.
#' \itemize{
#'  \item All values X where abs(X – median) > tolerance are hidden.
#'  \item With tolerance = 3*abs(percentile90 - median)
#'  \item The statistics (median and percentile90) are calculated on the daily minute data
#'  }
#'  After outlier removal, NAs were replaced with a linear interpolation and 
#'  the mean tide height for the day (average over all the minute data) was computed. The daily
#'  data were then averaged over the calendar month to create the monthly average. Months with
#'  fewer than 20 days of data were given NA.
#'  was computed.
#'  
#'  Daily mean tide level was also downloaded from the
#' University of Hawaii Sea Level Center (UHSLC) at the link \url{http://uhslc.soest.hawaii.edu/data/?fd#uh174}.
#' This data should be the same as the IOC data above but there were slight differences that
#' are likely due to differences in outlier removal and how NAs are treated. As for the IOC data, he daily
#'  data were then averaged over the calendar month to create the monthly average. Months with
#'  fewer than 20 days of data were given NA.
#'  was computed. The reference for these data are Caldwell et al. (2015).
#'  
#'  A monthly time series for 1939 to 2018 was assembled by merging the 3 data sets. The PSMSL data
#'  were used for 1939 to Aug 2011. For Sept 2011 onward, the IOC and UHSLC monthly data were averaged.
#'  If one had a NA and the other did not, the non-NA value was used. The monthly data had NAs. The NAs
#'  were interpolated using exponential smoothing (ETS) via a seasonal model. 
#'  \itemize{
#'  \item An ETS model was fit to the data up to the first NA
#'  \item The fitted ETS model was used to forecast one step ahead.
#'  \item The one-step ahead forecast was used to fill in the first NA
#'  \item A new ETS model was fit to the data up to the second NA, where the first NA was filled in via the step above.
#'  \item The new fitted ETS model was used to forecast one step ahead.
#'  \item This one-step ahead forecast was used to fill in the second NA.
#'  \item This process was repeated until all NAs were replaced.
#'  }
#'  The R code for interpolation in the 'process-merged-tide-gauge-data.R' file.
#'  
#'  All code for downloading and processing the data along with the raw downloaded
#'  data is in the
#'  extdata/tide gauge data folder in the doc folder.
#'  
#' 
#' @format tide_mon is a data frame with:
#' \describe{
#'   \item{Year}{The year}
#'   \item{Month}{The month}
#'   \item{tide.level.mm}{Tide level in mm above the Cochin datum (1.94m below BM27)}
#'   \item{tide.level.mm}{Tide level in mm above the Cochin datum (1.94m below BM27)}
#'   \item{tide.level.interp}{tide.level.mm with the NAs interpolated with exponential smoothing.}
#'   \item{anomalies}{tide.level.interp with linear trend and monthly means removed.}
#'   \item{anomalies13}{13 month running mean of anomalies as done in Srinivas et al. 2005 (Fig. 3).}
#'   \item{anomaliesb}{tide.level.interp with non-linear trend (via gam) and monthly means removed.}
#'   \item{anomalies13b}{13 month running mean of anomaliesb.}
#' }
#' 
#' @references
#' 
#' Caldwell, P. C., M. A. Merrifield, P. R. Thompson (2015), 
#' Sea level measured by tide gauges from global oceans — the Joint Archive for Sea 
#' Level holdings (NCEI Accession 0019568), Version 5.5, NOAA National Centers for 
#' Environmental Information, Dataset, doi:10.7289/V5V40S7W. Research Quality data is not
#' available for the Cochin tide guage (UH# 174, GLOSS# 032). The Fast Delivery data was downloaded on May 7, 2019.
#' from \url{http://uhslc.soest.hawaii.edu/data/?fd#uh174}
#' 
#' \insertRef{Holgateetal2013}{SardineForecast}
#' 
#' Permanent Service for Mean Sea Level (PSMSL). 2019. 
#' "Tide Gauge Data", Retrieved 6 May 2019 from 
#' \url{https://www.psmsl.org/data/obtaining/stations/438.php}.
#' 
#' \insertRef{Singh2006}{SardineForecast}
#' 
#' \insertRef{SrinivasKumar2006}{SardineForecast}
#' 
#' \insertRef{Srinivasetal2005}{SardineForecast}
#'  
"tide_mon"

#' Yearly mean tide height data from Cochin
#' #'
#' @description See \link{tidelevel} for information on the tide height data and references.
#' tide_yr is the calendar year averages of the monthly tide levels in tide_mon.
#'  
#' 
#' @format tide_yr is a data frame with:
#' \describe{
#'   \item{Year}{The year}
#'   \item{Month}{The month}
#'   \item{mean}{Calendar year mean of months in tide_mon}
#'   \item{anomalies}{mean with linear trend and mean level removed.}
#' }
#'  
"tide_yr"


#' Upwelling indices from remote-sensing products
#'
#' @description Three upwelling indices are in the 'upw' data object: a SST nearshore offshore
#' differential, a wind-based index, Ekman Mass Transport, and Ekman Pumping.
#' The wind upwelling indices and SST data were downloaded from the NOAA ERDDAP server using R Mendels
#' \code{rerddapXtracto} R package which uses the ropensci \code{rerddap} R package.  The R code used
#' to download the data is in the \code{extdata/get_satelite_data} folder.  See examples for how to find
#' the file. The Ekman Mass Transport and Pumping were computed from winds from the ERA5 product.
#' 
#' @details
#' 
#' The wind-based monthly upwelling indices were downloaded from the NOAA ERDDAP server. The first is
#' 1999-2009 on a 0.125 degree grid. The second is 2009 to present on a 0.25 degree grid. Units are m/s.
#' See
#'     \url{https://coastwatch.pfeg.noaa.gov/erddap/info/erdQSstressmday/index.html} and 
#'     \url{https://coastwatch.pfeg.noaa.gov/erddap/info/erdQAstressmday/index.html}.
#'    
#' The SST differential upwelling indices were computed from the SST Daily Optimum
#' Interpolation (OI), AVHRR Only, Version 2.1, Final 0.25 degree grid, Global data
#' downloaded from the NOAA ERDDAP server. This is AVHRR so 
#' accurate for close to the coast. These are daily data. They daily data was averaged over
#' all days in each month to produce monthly averages.
#'     \url{https://coastwatch.pfeg.noaa.gov/erddap/info/ncdcOisst21Agg/index.html}.
#' The UPW index is the difference between the coast box (1 to 5) and a box 3 degrees
#' offshore at the same latitude.
#' 
#' The Bakun index (The Bakun 1973) is calculated based upon Ekman's theory of mass transport
#'  due to wind stress. The index is computed from the ektrx and ektry, which
#'  are the x- and y- components of Ekman Transport (kg m$^{-1}$ s$^-1$) obtained from the ERDDAP link 
#'  below, and coast_angle is 158 degrees for the India west coast near Kochi (74.5E 11.5N coast angle 158 degrees). The Bakun index was downloaded from
#'     \url{https://coastwatch.pfeg.noaa.gov/erddap/info/erdlasFnWPr/index.html}.
#'  The function to compute the Bakun index is 
#'  (from \url{https://oceanview.pfeg.noaa.gov/products/upwelling/bakun})
#' \preformatted{
#'  upwell <- function(ektrx, ektry, coast_angle) {
#'  pi <- 3.1415927
#'  degtorad <- pi/180.
#'  alpha <- (360 - coast_angle) * degtorad
#'  s1 <- cos(alpha)
#'  t1 <- sin(alpha)
#'  s2 <- -1 * t1
#'  t2 <- s1
#'  perp <- (s1 * ektrx) + (t1 * ektry)
#'  para <- (s2 * ektrx) + (t2 * ektry)
#'  return(perp/10)
#'  }
#'  }
#'    
#' The R code used
#' to download the data is in the \code{extdata/get_satelite_data} folder.
#' 
#' The wind data are from the ERA5 Reanalysis Dataset
#'     \url{https://confluence.ecmwf.int/display/CKB/ERA5}.
#' downloaded from the Asia-Pacific Data-Research Center ERDDAP server 
#'     \url{https://apdrc.soest.hawaii.edu/erddap/info/hawaii_soest_66d3_10d8_0f3c/index.html}.
#'     
#' The R code used to download the data is in \code{extdata/get_satelite_data/get_EMTperp.R} and the functions are in \code{extdata/get_satelite_data/Replicate_EMT/get_EMT_functions.R}.

#' @format A data frame with:
#' \describe{
#'   \item{Year}{The year}
#'   \item{Month}{The month}
#'   \item{Wind.UPW.1 to Wind.UPW.5}{Average monthly wind-based upwelling index averaged over boxes 1 to 5. Units are m/s.}
#'   \item{SST.UPW.1 to SST.UPW.5}{Average monthly SST differential averaged over boxes 1 to 5. Units are degree Celcius.}
#'   \item{Bakun.UPW}{Bakun index at 74.5E 11.5N (near Kochi, India) at a coast angle of 158 degrees. Units are kg m$^{-1}$ s$^-1$.}
#' }
#' 
#' @references
#' 
#' SST data: These data were provided by GHRSST and the US National Oceanographic Data Center. 
#' This project was supported in part by a grant from the NOAA Climate Data Record (CDR) 
#' Program for satellites. The data were downloaded from NOAA CoastWatch-West Coast 
#' Regional Node and Southwest Fisheries Science Center's Environmental Research Division.
#' 
#' Wind-based UPW index: NOAA's CoastWatch Program distributes wind velocity measurements 
#' derived from the Seawinds instrument aboard NASA's QuikSCAT satellite. The Seawinds instrument 
#' is a dual-beam microwave scatterometer designed to measure wind magnitude and direction over the 
#' global oceans. CoastWatch further processes these wind velocity measurements to wind stress 
#' and wind stress curl. 
#' 
#' Bakun index: The Environmental Research Division (ERD), within NOAA Fisheries,
#'  has long been a leader in development and calculation of upwelling and other 
#'  environmental indices. ERD was originally established as the Pacific Environmental Group 
#'  at the U.S. Navy Fleet Numerical Meteorology and Oceanography Center (FNMOC) in Monterey, 
#'  California, to take advantage of the Navy's global oceanographic and meteorological models. 
#'  FNMOC produces operational forecasts of the state of the atmosphere and the ocean several 
#'  times daily. Before the advent of satellite oceanography, these forecasts provided global 
#'  snapshots of ocean conditions for Navy operations, but were also invaluable for studies of 
#'  fisheries climatology since they provided long time series of environmental conditions 
#'  at a much higher resolution than was possible from direct measurement. 
#'  The FNMOC sea-level pressure became the basis of the Bakun upwelling index calculation, 
#'  and provides estimates of upwelling for the Northern Hemisphere starting in 1948 and 
#'  globally since 1981.
#' 
#' \insertRef{Bakun1973}{SardineForecast}
#' 
#'  
#' @examples
#' \dontrun{
#' # Show the R code that downloaded the data
#' file.show(system.file("extdata/get_satellite_data", "get_sat_data.R", package="SardineForecast"))
#' 
#' # Show the R code that downloaded the data
#' file.show(system.file("extdata/get_satellite_data", "get_bakun_upi_data.R", package="SardineForecast"))
#' 
#' # Show the boxes
#' browseURL(system.file("docs", "kerala_study_area_with_inset.jpg", package="SardineForecast"))
#' }
"upw"