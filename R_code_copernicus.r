# R code for unloading and visualizing Copernicus data in R
library(ncdf4)
library(raster)
library(RStoolbox)
library(ggplot2)
library(viridis)

# Set the working directory
setwd("C:/lab/Copernicus/")
vegetation2020<-raster("c_gls_NDVI_202006210000_GLOBE_PROBAV_V3.0.1.nc")
plot(vegetation2020)
ggplot() + geom_raster(vegetation2020, mapping = aes(x=x, y=y, fill=Normalized.Difference.Vegetation.Index.1km))
ggplot() + geom_raster(vegetation2020, mapping = aes(x=x, y=y, fill=Normalized.Difference.Vegetation.Index.1km))+scale_fill_viridis(option="cividis")


