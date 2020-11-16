# How to download the satellite data
# run getdata_sat_data.R
# to download the sat data from the servers and process

# The file create_satellite_covariates_csv.r
# takes the files created from getdata_sat_data.R and makes 
# a master csv file with SST, SSH, CHL, Wind.UPW, and SST.UPW.
# and puts in 'raw data files and code' folder

# run get_gpcp_precip_data.R
# to download the gpcp precipitation data
# and create a csv file

# run get_enso_data.R
# to download the enso data
# and create a csv file

# run get_EMTperp.R
# to download the ERA5 wind data, compute Ekman Mass Trans perp and Ekman Pumping
# and create a csv file

# The file test sst cuts at 9-5 degN.r
# tests how SST drops off as you go offshore.


