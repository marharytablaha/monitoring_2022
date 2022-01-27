# R code for my Monitoring Ecosystem Changes and Functioning exam in 2022

# This code is for analyzing Copernicus Leaf Area Index data in R

# A particular focus in the analysis here is the deforestation and palm plantations in Malaysia

# Upload all the libraries needed at the beginning
library(ncdf4) # for formatting our files
library(raster) # importing the files to R, stacking and unstacking
library(RStoolbox) #
library(ggplot2) # for graphics
library(viridis) # palette
library(colorspace) # palette for diverging colors
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
P1999 <- ggplot() + geom_raster(vegetation1999, mapping = aes(x=x, y=y, fill=Leaf.Area.Index.1km.1)) + scale_fill_viridis(option="viridis") + ggtitle ("LAI 1999")
P2006 <- ggplot() + geom_raster(vegetation2006, mapping = aes(x=x, y=y, fill=Leaf.Area.Index.1km.2)) + scale_fill_viridis(option="viridis") + ggtitle ("LAI 2006")
P2013 <- ggplot() + geom_raster(vegetation2013, mapping = aes(x=x, y=y, fill=Leaf.Area.Index.1km.3)) + scale_fill_viridis(option="viridis") + ggtitle ("LAI 2013")
P2020 <- ggplot() + geom_raster(vegetation2020, mapping = aes(x=x, y=y, fill=Leaf.Area.Index.1km.4)) + scale_fill_viridis(option="viridis") + ggtitle ("LAI 2020")

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

P1999_MAS <- ggplot() + geom_raster(vegetation1999_MAS, mapping = aes(x=x, y=y, fill=Leaf.Area.Index.1km.1)) + scale_fill_viridis(option="viridis") + ggtitle ("LAI 1999")
P2006_MAS <- ggplot() + geom_raster(vegetation2006_MAS, mapping = aes(x=x, y=y, fill=Leaf.Area.Index.1km.2)) + scale_fill_viridis(option="viridis") + ggtitle ("LAI 2006")
P2013_MAS <- ggplot() + geom_raster(vegetation2013_MAS, mapping = aes(x=x, y=y, fill=Leaf.Area.Index.1km.3)) + scale_fill_viridis(option="viridis") + ggtitle ("LAI 2013")
P2020_MAS <- ggplot() + geom_raster(vegetation2020_MAS, mapping = aes(x=x, y=y, fill=Leaf.Area.Index.1km.4)) + scale_fill_viridis(option="viridis") + ggtitle ("LAI 2020")

# Export the ggplots in a png file
png(file="LAI Malaysia.png", units="cm", width=30, height=10, res=600)
# use patchwork to plot all fours images together
P1999_MAS + P2006_MAS + P2013_MAS + P2020_MAS
dev.off()


# scatterplot matrix for Malaysia
MAS_stack<-stack(vegetation1999_MAS,vegetation2006_MAS,vegetation2013_MAS,vegetation2020_MAS) # create a stack from the 4 variables first
# Recall the variable
MAS_stack
names(MAS_stack)<-c("LAI.1999","LAI.2006","LAI.2013","LAI.2020")

# use the pairs function
pairs(MAS_stack) # density plot, scatterplot, and Pearson coefficient

# Save the scatterplot multiframe in a PNG file
png(file="LAI scatterplot.png", units="cm", width=20, height=20, res=600)
pairs(MAS_stack) # density plot, scatterplot, and Pearson coefficient
dev.off()

# Computing the difference between the first and the last year (1999 and 2020)
dif<-vegetation2020_MAS - vegetation1999_MAS
dif

# Create a palette from the viridis package
mako(3)
mako<-colorRampPalette(c("#0B0405FF", "#357BA2FF", "#DEF5E5FF"))(100)

viridis(3)
viridis<-colorRampPalette(c("#440154FF", "#21908CFF", "#FDE725FF"))(100) 

plot(dif, col=mako)

# we can also transform it into a ggplot
difference <- ggplot() + geom_raster(dif, mapping = aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="mako") + ggtitle ("1999-2020 LAI difference")
difference

# Focus on Peninsular Malaysia LAI difference
# Crop the area first
P_MAS<-c(99.6419, 105, 0.8527, 7.3529)
P_MAS_1999<-crop(vegetation1999,P_MAS)
P_MAS_2006<-crop(vegetation2006,P_MAS)
P_MAS_2013<-crop(vegetation2013,P_MAS)
P_MAS_2020<-crop(vegetation2020,P_MAS)

# Compute the difference between the layers
P_MAS_dif<-P_MAS_2020-P_MAS_1999

# Plot!
plot(P_MAS_dif, col=mako)

# Use diverging colors to plot the positive and negative change in LAI
red_green<-diverging_hcl(5, "Red-Green")
red_green # recall the variable to see the color palette
# "#841859" "#F398C4" "#F6F6F6" "#7CC57D" "#005600"

# This palette does not center in 0, but we want the grey color to be exactly in 0

# Palette for the top half of the image, with positive values
green <- colorRampPalette(colors = c("#F6F6F6", "#7CC57D", "#005600"))(50.33283)

# Palette for the bottom half of the image, with negative values
red <- colorRampPalette(colors = c("#841859", "#F398C4", "#F6F6F6"))(61.66605)

# Combine the two color palettes
red_green <- c(red, green)

# Plot!
plot(P_MAS_dif, col=red_green) # now it's centered!

# Make a multiframe of the LAI in 1999, the difference, and the LAI 2020
# Let's use a different palette for the difference image
par(mfrow=c(1,3))
plot(P_MAS_1999, col=viridis, main="LAI in 1999")
plot(P_MAS_dif, col=red_green, main="1999-2020 difference")
plot(P_MAS_2020, col=viridis, main="LAI in 2020")

# Export the picture as PNG
png(file="Peninsular Malaysia 1999-2020.png", units="cm", width=30, height=10, res=600)
par(mfrow=c(1,3))
plot(P_MAS_1999, col=viridis, main="LAI in 1999")
plot(P_MAS_dif, col=red_green, main="1999-2020 difference")
plot(P_MAS_2020, col=viridis, main="LAI in 2020")
dev.off()

# Let's zoom on the Sarawak state, a region of Malaysia on the Borneo Island where most of the deforestation is happening
Sarawak<-c(109.6060, 115.5806, 0.8527, 5.2135)
Sarawak1999<-crop(vegetation1999,Sarawak)
Sarawak2006<-crop(vegetation2006,Sarawak)
Sarawak2013<-crop(vegetation2013,Sarawak)
Sarawak2020<-crop(vegetation2020,Sarawak)

dif_Sar<-Sarawak2020-Sarawak1999

# Palette for the top half of the image, with positive values
green2 <- colorRampPalette(colors = c("#F6F6F6", "#7CC57D", "#005600"))(52.33281)

# Palette for the bottom half of the image, with negative values
red2 <- colorRampPalette(colors = c("#841859", "#F398C4", "#F6F6F6"))(58.33275)

# Combine the two color palettes
red_green2 <- c(red2, green2)

png(file="Sarawak 1999-2020.png", units="cm", width=30, height=10, res=600)
par(mfrow=c(1,3))
plot(Sarawak1999, col=viridis, main="LAI in 1999")
plot(dif_Sar, col=red_green2, main="1999-2020 difference")
plot(Sarawak2020, col=viridis, main="LAI in 2020")
dev.off()

# plot the difference between each 7 years
# we have to adjust the palette for each plot so it's centered in 0
# we do this by taking the max and min values from each computed difference and multiply it by 10
dif_1999_2006<-P_MAS_2006-P_MAS_1999
gr_a <- colorRampPalette(colors = c("#F6F6F6", "#7CC57D", "#005600"))(53.99946)
rd_a<- colorRampPalette(colors = c("#841859", "#F398C4", "#F6F6F6"))(55.33278)
rd_gr_a <- c(rd_a, gr_a)
plot(dif_1999_2006, col=rd_gr_a, main="1999 - 2006")

dif_2006_2013<-P_MAS_2013-P_MAS_2006
gr_b <- colorRampPalette(colors = c("#F6F6F6", "#7CC57D", "#005600"))(58.33275)
rd_b<- colorRampPalette(colors = c("#841859", "#F398C4", "#F6F6F6"))(54.33279)
rd_gr_b <- c(rd_b, gr_b)
plot(dif_2006_2013, col=rd_gr_b, main="2006 - 2013")

dif_2013_2020<-P_MAS_2020-P_MAS_2013
gr_c <- colorRampPalette(colors = c("#F6F6F6", "#7CC57D", "#005600"))(45.99954)
rd_c<- colorRampPalette(colors = c("#841859", "#F398C4", "#F6F6F6"))(61.66605)
rd_gr_c <- c(rd_c, gr_c)
plot(dif_2013_2020, col=rd_gr_c, main="2013 - 2020")

# Safe files as png and a multiframe
png(file="7 years timeframe difference.png", units="cm", width=30, height=10, res=600)
par(mfrow=c(1,3))
plot(dif_1999_2006, col=rd_gr_a, main="1999 - 2006")
plot(dif_2006_2013, col=rd_gr_b, main="2006 - 2013")
plot(dif_2013_2020, col=rd_gr_c, main="2013 - 2020")
dev.off()
