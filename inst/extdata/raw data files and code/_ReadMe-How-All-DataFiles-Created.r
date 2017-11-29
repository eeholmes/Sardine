# References are in the data.R file documentation in R folder

# How to create all the dataset from the information in this folder
# Set working directory to ROOT for package

#0 See code in get_satellite_data directory on downloading satellite data from ERDDAP and from the GPCP server

# 0 In code in raw data files and code folder
# see code with names like read_enso.r for how the non-satellite data were obtained

#1 Create the csv files
# For the satellite data
# Create the Satellite_Covariates.csv file that has all the monthly SST, SSH, CHL, UPW
# set the working directory since these scripts download files
setwd("inst/extdata/get_satellite_data")
#source("get_sat_data.r") #downloads; commented to prevent accidental running
source("create_satellite_covariates_csv.r") #create Satellite_Covariates.csv
#source("get_gpcp_precip_data.r") #downloads and creates precipitation_gpcp.csv file
setwd("../../..") #back to root

# enso data
#downloads and saves enso.csv file to raw data files and code
#source("inst/extdata/get_satellite_data/get_enso_data.r") 

# For the non-satellite data
#reads in the land guage data file and creates the precip_kerala.csv
source("inst/extdata/raw data files and code/create_precip_kerala_csv.r") 

#2 Create a monthly covariate csv file with the satellite data, enso indices, and other non-satellite covariates
# enso, land-based rain over Kerala, etc
# assumes wd is base package dir
source("inst/extdata/raw data files and code/create_monthly_covariates_csv.r")

#3 Create all the rdata files in the data dir
source("create_rdata_files.r")