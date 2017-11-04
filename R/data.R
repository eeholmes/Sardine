#' Oil sardine landings in metric tons by quarter
#'
#' A dataset containing the landings (in metric tons) of oil sardines in Kerala, Karnataka and Goa states 1956-2016.  The data are collected and processed into a total landings estimates based on a stratified sampling of landing sites along the SW coast of India throughout the year.  The program is run by the Central Marine Fisheries Research Institute (CMFRI) in Cochin, India.  The data were obtained from reports published by CMFRI; see references.
#'
#' @format A data frame 'oilsardine_qtr' with 6 variables:
#' \describe{
#'   \item{Site}{Kerala, Karnataka, Goa}
#'   \item{Year}{Year}
#'   \item{Q1}{Quarter 1 landings}
#'   \item{Q1}{Quarter 2 landings}
#'   \item{Q1}{Quarter 3 landings}
#'   \item{Q1}{Quarter 4 landings}
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


#' ENSO Indices
#' 
#' @description
#' Oceanic Nino Index and Equatorial Southern Oscillation Index
#'
#' @details
#' The ONI index is 3 month running mean of ERSST.v5 SST anomalies in the Niño 3.4 region (5oN-5oS, 120o-170oW)], based on centered 30-year base periods updated every 5 years.  The ONI was downloaded as follows:
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
#'
#' @format A data frame with variables:
#' \describe{
#'   \item{Year}{}
#'   \item{Month}{This is a 3-month average.  Jan value is average of Dec-Jan-Feb.  Qtr would be denoted JFM.}
#'   \item{ONI}{The ONI index value}
#'   \item{SOI}{The SOI index value}
#' }
"enso"

#' Precipitation data
#'
#' @description Three precipition datasets off the SW coast of India.  Two are satellite derived and one is based on land gauges.
#' 
#' @details
#' The National Climatic Data Center provides basic information on the GPCP Precipitation dataset.  The dataset consists of monthly precipitation estimates (average mm/day) from January 1979 to the present. The precipitation estimates merge several satellite and in situ sources into a final product. Data are provided on a 2.5 degree grid.  The GPCP Precipitation data are provided by the NOAA/NCEI Global Precipitation Climatology Project and were downloaded from \url{https://www.ncei.noaa.gov/data/global-precipitation-climatology-project-gpcp-monthly}.  Two boxes were defined, one off the Kerala coast and one off the Karnataka coast, and the average values of all grid points within these boxes were used.
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
#'   \item{precip.gpcp.kerala}{Monthly GPCP precipitation in the box off the Kerala coast.}
#'   \item{precip.gpcp.karnataka}{Monthly GPCP precipitation in the box off the Karnataka coast.}
#'   \item{PrecipTRMM}{Monthly precipitation estimates from the Tropical Rainfall Measuring Mission (TRMM).  Data are averaged in the boxes used for the other satellite data.}
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
"precip"


#' India Monsoon Onset Dates
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
#' #' @reference 
#' Pai, D. S. and Bhan, S. C., editors. 2016. Monsoon: a report 2015. National Climate Centre. India Meteorological Department.
"onset"
