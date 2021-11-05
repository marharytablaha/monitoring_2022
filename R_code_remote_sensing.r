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

# ------ day 2

#B1 is the reflectance in the blue wavelenght
#B2 is the reflectance in the green wavelenght
#B3 is the reflectance in the red wavelenght
#B4 is the reflectance in the NIR wavelenght

# let's plot the green band
plot(l2011$B2_sre)

# change the color palette to plot in grey scale
cl<-colorRampPalette(c("black","grey","light grey"))(100)

#change the colorramppalette with dark green, green and light green e.g. clg
clg<-colorRampPalette(c("dark green", "green", "light green"))(100)
plot(l2011$B2_sre, col=clg)

#change the colorramppalette with dark blue, blue and light blue e.g. clb
clb<-colorRampPalette(c("dark blue", "blue", "light blue"))(100)
plot(l2011$B1_sre, col=clb)

# plot both images in just one multiframe graph
# mf means multiframe; if we say mfrow(1,2), we'll plot 1 row and 2 columns

par(mfrow=c(1,2))
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)

# plot the images in just one multiframe graph 
with 1 column and 2 rows
par(mfrow=c(2,1))
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)

# dev.off() is a function that shuts down the device
