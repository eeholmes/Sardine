#' Oil sardine landings in metric tons by quarter
#'
#' A dataset containing the landings (in metric tons) of oil sardines in Kerala, Karnataka and Goa states 1956-2016.  The data are collected and processed into a total landings estimates based on a stratified sampling of landing sites along the SW coast of India throughout the year.  The program is run by the Central Marine Fisheries Research Institute (CMFRI) in Cochin, India.  The data were obtained from reports published by CMFRI; see references.
#'
#' @format A data frame 'oilsardine_qtr' with 6 variables:
#' \describe{
#'   \item{Site}{Kerala, Karnataka, Goa}
#'   \item{Year}{}
#'   \item{Q1}{Quarter 1 landings}
#'   \item{Q1}{Quarter 2 landings}
#'   \item{Q1}{Quarter 3 landings}
#'   \item{Q1}{Quarter 4 landings}
#' }
#' 
#' @references 
#' 1956-1968 (Note Mysore which later becomes Karnataka) \insertRef{Raja1969}{SardineForecast}
#' 
#' 1968-1978 \insertRef{Pillai1982}{SardineForecast}
#' 
#' 1975-1984 Kerala \insertRef{Jacobetal1987}{SardineForecast}
#' 
#' 1975-1984 Kernataka \insertRef{Kurupetal1987}{SardineForecast}
#' 
#' 1985-2014 Provided by CMFRI directly \url{http://www.cmfri.org.in}
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
#' GPCP Precipitation data provided by the NOAA/NCEI Global Precipitation Climatology Project from their Web site at \url{https://www.ncei.noaa.gov/data/global-precipitation-climatology-project-gpcp-monthly}.  The data are on a 2.5 x 2.5 grid.  Two boxes are defined, one off the Kerala coast and one off the Karnataka coast.
#' \preformatted{
#' The boxes are 
#' Kerala Lat(8.75,  11.25), Lon(73.25,  75.75)
#' Karnataka Lat(13.75,  16.25), Lon(71.25,  73.75)
#' }
#' 
#' @format A data frame with:
#' \describe{
#'   \item{Year}{}
#'   \item{Month}{}
#'   \item{precip.gpcp.kerala}{Monthly GPCP precipitation in the box off the Kerala coast.}
#'   \item{precip.gpcp.karnataka}{Monthly GPCP precipitation in the box off the Karnataka coast.}
#'   \item{PrecipTRMM#}{Monthly TRMM precipitation in the boxes used for the other satellite data.}
#'   \item{Precip.Kerala}{Monthly precipitation from the land gauges.}

#' }
#' 
#' @reference 
#' Adler, R.F., G.J. Huffman, A. Chang, R. Ferraro, P. Xie, J. Janowiak, B. Rudolf, U. Schneider, S. Curtis, D. Bolvin, A. Gruber, J. Susskind, P. Arkin, 2003: The Version 2 Global Precipitation Climatology Project (GPCP) Monthly Precipitation Analysis (1979-Present). J. Hydrometeor., 4,1147-1167.
"precip"

