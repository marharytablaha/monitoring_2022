# R code for unloading and visualizing Copernicus data in R

#upload all the libraries needed at the beginning
library(ncdf4) # for formatting our files
library(raster) # importing the files to R, stacking and unstacking
library(RStoolbox) #
library(ggplot2) # for graphics
library(viridis) # palette
library(patchwork) # for comparing graphics

# Set the working directory
setwd("C:/lab/FAPAR/")
# one way of importing is one by one
vegetation2021<-raster("c_gls_FAPAR300_201407100000_GLOBE_PROBAV_V1.0.1.nc")
vegetation2021

# we can also import multiple files that have the same pattern in the name
rlist <- list.files(pattern="FAPAR")
rlist
list_rast <- lapply(rlist, raster)
list_rast
vegetationstack <- stack(list_rast) # we create a stack
vegetationstack

# and then we separate the files, assigning to each element of the stack a name
vegetation2014 <- vegetationstack$Fraction.of.Absorbed.Photosynthetically.Active.Radiation.333m.1
vegetation2021 <- vegetationstack$Fraction.of.Absorbed.Photosynthetically.Active.Radiation.333m.2

# here we plot the files with ggplot2
P2014 <- ggplot() + geom_raster(vegetation2014, mapping = aes(x=x, y=y, fill=Fraction.of.Absorbed.Photosynthetically.Active.Radiation.333m.1)) + scale_fill_viridis(option="viridis") + ggtitle ("FAPAR 2014")
P2021 <- ggplot() + geom_raster(vegetation2021, mapping = aes(x=x, y=y, fill=Fraction.of.Absorbed.Photosynthetically.Active.Radiation.333m.2)) + scale_fill_viridis(option="viridis") + ggtitle ("FAPAR 2021")

# use patchwork for comparing the files
P2014/P2021 # plot vertical sequence
P2014/P2021 # plot horizontal sequence

# you can crop your image on a certain area, for example Malaysia
# longitude from 100 to 119
# latitude from 0 to 8
ext<-c(100, 119, 0, 8)
vegetation2014_SEA<-crop(vegetation2014,ext)
vegetation2021_SEA<-crop(vegetation2021,ext)
P2014_SEA <- ggplot() + geom_raster(vegetation2014_SEA, mapping = aes(x=x, y=y, fill=Fraction.of.Absorbed.Photosynthetically.Active.Radiation.333m.1)) + scale_fill_viridis(option="viridis") + ggtitle ("FAPAR 2014")
P2021_SEA <- ggplot() + geom_raster(vegetation2021_SEA, mapping = aes(x=x, y=y, fill=Fraction.of.Absorbed.Photosynthetically.Active.Radiation.333m.2)) + scale_fill_viridis(option="viridis") + ggtitle ("FAPAR 2021")
P2014_SEA/P2021_SEA

# here we crop the Amazon forest area
P2014
Amazon <- c(-82, -40, -20, 12)
vegetation2014_AMZ<-crop(vegetation2014,Amazon)
vegetation2021_AMZ<-crop(vegetation2021,Amazon)
P2014_AMZ <- ggplot() + geom_raster(vegetation2014_AMZ, mapping = aes(x=x, y=y, fill=Fraction.of.Absorbed.Photosynthetically.Active.Radiation.333m.1)) + scale_fill_viridis(option="magma") + ggtitle ("FAPAR 2014")
P2021_AMZ <- ggplot() + geom_raster(vegetation2021_AMZ, mapping = aes(x=x, y=y, fill=Fraction.of.Absorbed.Photosynthetically.Active.Radiation.333m.2)) + scale_fill_viridis(option="magma") + ggtitle ("FAPAR 2021")
P2014_AMZ/P2021_AMZ

# attempt to create graphs
pairs(vegetationstack)
