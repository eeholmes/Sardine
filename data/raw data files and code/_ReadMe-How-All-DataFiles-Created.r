# How to create all the dataset from the information in this folder
# Set working directory as 'raw data files and code' in the data directory

#0 See code in get_satellite_data directory on downloading satellite data from ERDDAP
# See code with names like read_enso.r for how the non-satellite data were obtained

#1 Create the Satellite_Covariates.csv file that has all the monthly sat covariates (except enso) assembled into one file
setwd("get_satellite_data")
source("create_satellite_covariates_master_file.r")

#2 Create a monthly covariate file with the satellite data, enso indices, and other non-satellite covariates
# enso, land-based rain over Kerala, etc
setwd("..") #back to 'raw data files and code'
source("create_monthly_covariates.r")

#3 Create a quarterly covariate file with the satellite data and other non-satellite covarietes
# enso, land-based rain over Kerala, etc
source("create_quarterly_covariates.r")

#4 Create rdata files in the data dir
source("create_rdata_files.r")