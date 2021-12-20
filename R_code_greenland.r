# Set the working directory
setwd("C:/lab/Greenland")

# Import the files that contain "lst" in their name
rlist <- list.files(pattern="lst")

library(raster)
library(viridis)
library(RStoolbox)
library(patchwork)
library(ggplot2)
import <- lapply(rlist, raster)

tgr <- stack(import)

cl <- colorRampPalette(c("blue", "light blue", "pink", "yellow"))(100)
plot(tgr, col=cl)

# ggplot the first and final images 2000 vs. 2015
library(viridis)
p1 <- ggplot() + geom_raster(tgr$lst_2000, mapping = aes(x=x, y=y, fill=lst_2000)) + scale_fill_viridis(option="magma") + ggtitle ("LST in 2000")
p2 <- ggplot() + geom_raster(tgr$lst_2015, mapping = aes(x=x, y=y, fill=lst_2015)) + scale_fill_viridis(option="magma") + ggtitle ("LST in 2015")

# plot the two images together
p1 + p2

# plotting frequency distribution

par(mfrow=c(2,2))
hist(tgr$lst_2000)
hist(tgr$lst_2005)
hist(tgr$lst_2010)
hist(tgr$lst_2015)

plot(tgr$lst_2010, tgr$lst_2015, xlim=c(12500, 15000), ylim=c(12500, 15000))
abline(0,1, col="red")

# make a plot with all of the histograms and all the regressions for all the variables
par(mfrow=c(4,4))
hist(tgr$lst_2000)
hist(tgr$lst_2005)
hist(tgr$lst_2010)
hist(tgr$lst_2015)
plot(tgr$lst_2000, tgr$lst_2005, xlim=c(12500, 15000), ylim=c(12500, 15000))
plot(tgr$lst_2005, tgr$lst_2010, xlim=c(12500, 15000), ylim=c(12500, 15000))
plot(tgr$lst_2010, tgr$lst_2015, xlim=c(12500, 15000), ylim=c(12500, 15000))
plot(tgr$lst_2000, tgr$lst_2015, xlim=c(12500, 15000), ylim=c(12500, 15000))
plot(tgr$lst_2005, tgr$lst_2015, xlim=c(12500, 15000), ylim=c(12500, 15000))
plot(tgr$lst_2000, tgr$lst_2010, xlim=c(12500, 15000), ylim=c(12500, 15000))

# big nightmare, isn't it? So let's use pairs
pairs(tgr)




