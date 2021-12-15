# R code for unloading and visualizing Copernicus data in R
library(ncdf4)
library(raster)
# Set the working directory
setwd("C:/lab/Copernicus/")
vegetation2020<-raster("c_gls_NDVI_202006210000_GLOBE_PROBAV_V3.0.1.nc")
plot(vegetation2020)
