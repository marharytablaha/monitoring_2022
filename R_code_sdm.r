# R code for Spacial Distribution Modelling, namely the distribution of individuals

library(sdm)
library(rgdal)
library(raster)

# .shp is the extension used a lot in shape geography
file <- system.file("external/species.shp", package="sdm")
file

species <- shapefile(file) # exatcly as the raster function for raster files

plot(species, pch=19, col="red")


