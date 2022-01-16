# R code for unloading and visualizing Copernicus data in R

#upload all the libraries needed at the beginning
library(ncdf4) # for formatting our files
library(raster) # importing the files to R, stacking and unstacking
library(RStoolbox) #
library(ggplot2) # for graphics
library(viridis) # palette
library(patchwork) # for comparing graphics

# Set the working directory
setwd("C:/lab/LAI/")
# one way of importing is one by one
vegetation1999<-raster("c_gls_LAI_199907100000_GLOBE_VGT_V2.0.2.nc")
vegetation1999

# we can also import multiple files at once that have the same pattern in the name
rlist <- list.files(pattern="LAI")
rlist
list_rast <- lapply(rlist, raster)
list_rast
vegetationstack <- stack(list_rast) # we create a stack
vegetationstack

# and then we separate the files, assigning to each element of the stack a name
vegetation1999 <- vegetationstack$Leaf.Area.Index.1km.1
vegetation2006 <- vegetationstack$Leaf.Area.Index.1km.2
vegetation2013 <- vegetationstack$Leaf.Area.Index.1km.3
vegetation2020 <- vegetationstack$Leaf.Area.Index.1km.4

# here we plot the files with ggplot2
P1999 <- ggplot() + geom_raster(vegetation1999, mapping = aes(x=x, y=y, fill=Leaf.Area.Index.1km.1)) + scale_fill_viridis(option="mako") + ggtitle ("LAI 1999")
P2006 <- ggplot() + geom_raster(vegetation2006, mapping = aes(x=x, y=y, fill=Leaf.Area.Index.1km.2)) + scale_fill_viridis(option="mako") + ggtitle ("LAI 2006")
P2013 <- ggplot() + geom_raster(vegetation2013, mapping = aes(x=x, y=y, fill=Leaf.Area.Index.1km.3)) + scale_fill_viridis(option="mako") + ggtitle ("LAI 2013")
P2020 <- ggplot() + geom_raster(vegetation2020, mapping = aes(x=x, y=y, fill=Leaf.Area.Index.1km.4)) + scale_fill_viridis(option="mako") + ggtitle ("LAI 2020")

# use patchwork for comparing the files
# use / to plot vertical sequence
# use + to plot horizontal sequence
P1999 + P2006 + P2013 + P2020


# you can crop your image on a certain area, for example Malaysia
# longitude from 99.6419 to 119.2758
# latitude from 0.8527 to 7.3529
ext<-c(99.6419, 119.2758, 0.8527, 7.3529)
vegetation1999_MAS<-crop(vegetation1999,ext)
vegetation2006_MAS<-crop(vegetation2006,ext)
vegetation2013_MAS<-crop(vegetation2013,ext)
vegetation2020_MAS<-crop(vegetation2020,ext)

P1999_MAS <- ggplot() + geom_raster(vegetation1999_MAS, mapping = aes(x=x, y=y, fill=Leaf.Area.Index.1km.1)) + scale_fill_viridis(option="mako") + ggtitle ("LAI 1999")
P2006_MAS <- ggplot() + geom_raster(vegetation2006_MAS, mapping = aes(x=x, y=y, fill=Leaf.Area.Index.1km.2)) + scale_fill_viridis(option="mako") + ggtitle ("LAI 2006")
P2013_MAS <- ggplot() + geom_raster(vegetation2013_MAS, mapping = aes(x=x, y=y, fill=Leaf.Area.Index.1km.3)) + scale_fill_viridis(option="mako") + ggtitle ("LAI 2013")
P2020_MAS <- ggplot() + geom_raster(vegetation2020_MAS, mapping = aes(x=x, y=y, fill=Leaf.Area.Index.1km.4)) + scale_fill_viridis(option="mako") + ggtitle ("LAI 2020")

P1999_MAS + P2006_MAS + P2013_MAS + P2020_MAS

# Let's zoom on the Sarawak state, a region of Malaysia on the Borneo Island where most of the deforestation is happening
Sarawak<-c(109.6060, 115.5806, 0.8527, 5.2135)
Sarawak1999<-crop(vegetation1999,Sarawak)
Sarawak2006<-crop(vegetation2006,Sarawak)
Sarawak2013<-crop(vegetation2013,Sarawak)
Sarawak2020<-crop(vegetation2020,Sarawak)

P1999_SAR <- ggplot() + geom_raster(Sarawak1999, mapping = aes(x=x, y=y, fill=Leaf.Area.Index.1km.1)) + scale_fill_viridis(option="mako") + ggtitle ("LAI 1999")
P2006_SAR <- ggplot() + geom_raster(Sarawak2006, mapping = aes(x=x, y=y, fill=Leaf.Area.Index.1km.2)) + scale_fill_viridis(option="mako") + ggtitle ("LAI 2006")
P2013_SAR <- ggplot() + geom_raster(Sarawak2013, mapping = aes(x=x, y=y, fill=Leaf.Area.Index.1km.3)) + scale_fill_viridis(option="mako") + ggtitle ("LAI 2013")
P2020_SAR <- ggplot() + geom_raster(Sarawak2020, mapping = aes(x=x, y=y, fill=Leaf.Area.Index.1km.4)) + scale_fill_viridis(option="mako") + ggtitle ("LAI 2020")

P1999_SAR + P2006_SAR + P2013_SAR + P2020_SAR

# here we crop approximately the Amazon forest area
Amazon <- c(-82, -40, -20, 12)
vegetation1999_AMZ<-crop(vegetation1999,Amazon)
vegetation2006_AMZ<-crop(vegetation2006,Amazon)
vegetation2013_AMZ<-crop(vegetation2013,Amazon)
vegetation2020_AMZ<-crop(vegetation2020,Amazon)
P1999_AMZ <- ggplot() + geom_raster(vegetation1999_AMZ, mapping = aes(x=x, y=y, fill=Leaf.Area.Index.1km.1)) + scale_fill_viridis(option="mako") + ggtitle ("LAI 1999")
P2006_AMZ <- ggplot() + geom_raster(vegetation2006_AMZ, mapping = aes(x=x, y=y, fill=Leaf.Area.Index.1km.2)) + scale_fill_viridis(option="mako") + ggtitle ("LAI 2006")
P2013_AMZ <- ggplot() + geom_raster(vegetation2013_AMZ, mapping = aes(x=x, y=y, fill=Leaf.Area.Index.1km.3)) + scale_fill_viridis(option="mako") + ggtitle ("LAI 2013")
P2020_AMZ <- ggplot() + geom_raster(vegetation2020_AMZ, mapping = aes(x=x, y=y, fill=Leaf.Area.Index.1km.4)) + scale_fill_viridis(option="mako") + ggtitle ("LAI 2020")

P1999_AMZ + P2006_AMZ + P2013_AMZ + P2020_AMZ

# scatterplot matrix for global LAI 
pairs(vegetationstack) # density plot, scatterplot, and Pearson coefficient
# scatterplot matrix for Malaysia
MASstack<-stack(vegetation1999_MAS,vegetation2006_MAS,vegetation2013_MAS,vegetation2020_MAS) # create a stack from the 4 variables first
# Recall the variable
MASstack
# use the pairs function
pairs(MASstack)
