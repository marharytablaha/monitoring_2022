# R code for ecosystem monitoring by remote sensing
# First of all, we need to install additional packages
# raster package to manage image data
# https://cran.r-project.org/web/packages/raster/index.html

install.packages("raster")

library(raster)

setwd("C:/lab/")

brick("p224r63_2011.grd")

l2011 <- brick("p224r63_2011.grd")

#B1 is the reflectance in the blue wavelenght
#B2 is the reflectance in the green wavelenght
#B3 is the reflectance in the red wavelenght

plot(l2011)

cl <- colorRampPalette(c("black","grey","light grey"))(100)
plot(ll011, col=cl)
plotRGB(l2011, r=3, g=2, b=1, stretch="Lin")
