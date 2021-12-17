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

##### MAKING COMPARISONS 

rlist <- list.files(pattern="NDVI")
rlist
list_rast <- lapply(rlist, raster)
list_rast
vegetationstack <- stack(list_rast)
vegetationstack
vegetation1999 <- vegetationstack$Normalized.Difference.Vegetation.Index.1km.1
vegetation2020 <- vegetationstack$Normalized.Difference.Vegetation.Index.1km.2

ggplot() + geom_raster(vegetation2020, mapping = aes(x=x, y=y, fill=Normalized.Difference.Vegetation.Index.1km.2)) + scale_fill_viridis(option="viridis") + ggtitle ("NDVI 2020")
ggplot() + geom_raster(vegetation1999, mapping = aes(x=x, y=y, fill=Normalized.Difference.Vegetation.Index.1km.1)) + scale_fill_viridis(option="viridis") + ggtitle ("NDVI 1999")
P1999 <- ggplot() + geom_raster(vegetation1999, mapping = aes(x=x, y=y, fill=Normalized.Difference.Vegetation.Index.1km.1)) + scale_fill_viridis(option="viridis") + ggtitle ("NDVI 1999")
P2020 <- ggplot() + geom_raster(vegetation2020, mapping = aes(x=x, y=y, fill=Normalized.Difference.Vegetation.Index.1km.2)) + scale_fill_viridis(option="viridis") + ggtitle ("NDVI 2020")
library(patchwork)
P1999/P2020

# you can crop your image on a certain area, for example Malaysia-Indonesia
# longitude from 90 to 120
# latitude from -20 to +20
ext<-c(90, 120, -20, 20)
vegetation1999_Malaysia<-crop(vegetation1999,ext)
vegetation2020_Malaysia<-crop(vegetation2020,ext)
P1999_Malaysia <- ggplot() + geom_raster(vegetation1999_Malaysia, mapping = aes(x=x, y=y, fill=Normalized.Difference.Vegetation.Index.1km.1)) + scale_fill_viridis(option="viridis") + ggtitle ("NDVI 1999")
P2020_Malaysia <- ggplot() + geom_raster(vegetation2020_Malaysia, mapping = aes(x=x, y=y, fill=Normalized.Difference.Vegetation.Index.1km.2)) + scale_fill_viridis(option="viridis") + ggtitle ("NDVI 2020")
P1999_Malaysia/P2020_Malaysia
