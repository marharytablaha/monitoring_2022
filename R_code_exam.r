# R code for my Monitoring Ecosystem Changes and Functioning exam in 2022

# This code is for analyzing Copernicus Leaf Area Index data in R

# A particular focus in the analysis here is the deforestation and palm plantations in Malaysia

# Upload all the libraries needed at the beginning
library(ncdf4) # for formatting our files
library(raster) # importing the files to R, stacking and unstacking
library(RStoolbox) # tools for remote sensing data processing; builds on raster
library(ggplot2) # for plots
library(viridis) # palette
library(colorspace) # palette for diverging colors
library(patchwork) # for comparing ggplots

# Set the working directory
setwd("C:/lab/LAI/")
# one way of importing is one by one
vegetation1999 <- raster("c_gls_LAI_199907100000_GLOBE_VGT_V2.0.2.nc")
vegetation1999

# we can also import multiple files at once that have the same pattern in the name
# this is much faster when we have many files to import
rlist <- list.files(pattern="c_gls_LAI") # listing all the files with the pattern present in the directory
rlist
list_rast <- lapply(rlist, raster) # lapply function to make the list a raster list
list_rast
laistack <- stack(list_rast) # we create a stack
laistack

# Let's change the names of laistack
names(laistack)<-c("LAI.1km.1", "LAI.1km.2", "LAI.1km.3", "LAI.1km.4")

# and then we separate the files, assigning to each element of the stack a name
lai1999 <- laistack$LAI.1km.1
lai2006 <- laistack$LAI.1km.2
lai2013 <- laistack$LAI.1km.3
lai2020 <- laistack$LAI.1km.4

# We can now plot an image of the global LAI values, for example in 2020
# Save a viridis palette to use with raster files
viridis(3)
viridis<-colorRampPalette(viridis(3))(100) 
plot(lai2020, col=viridis)

# Save the file as a PNG
png(file="Global LAI 2020.png", units="cm", width=25, height=14, res=600)
par(bg=NA) # makes the background transparent
plot(lai2020, col=viridis, colNA=NA, bg="transparent")
dev.off()

# here we plot the files with ggplot2
P1999 <- ggplot() + geom_raster(lai1999, mapping = aes(x=x, y=y, fill=LAI.1km.1)) + scale_fill_viridis(option="viridis") + ggtitle ("LAI 1999")
P2006 <- ggplot() + geom_raster(lai2006, mapping = aes(x=x, y=y, fill=LAI.1km.2)) + scale_fill_viridis(option="viridis") + ggtitle ("LAI 2006")
P2013 <- ggplot() + geom_raster(lai2013, mapping = aes(x=x, y=y, fill=LAI.1km.3)) + scale_fill_viridis(option="viridis") + ggtitle ("LAI 2013")
P2020 <- ggplot() + geom_raster(lai2020, mapping = aes(x=x, y=y, fill=LAI.1km.4)) + scale_fill_viridis(option="viridis") + ggtitle ("LAI 2020")

# use patchwork for comparing the files
# use / to plot vertical sequence
# use + to plot horizontal sequence
P1999 + P2006 + P2013 + P2020


# you can crop your image on a certain area, for example Malaysia
# longitude from 99.6419 to 119.2758
# latitude from 0.8527 to 7.3529
ext<-c(99.6419, 119.2758, 0.8527, 7.3529)
lai1999_MYS <- crop(lai1999,ext)
lai2006_MYS <- crop(lai2006,ext)
lai2013_MYS <- crop(lai2013,ext)
lai2020_MYS <- crop(lai2020,ext)

P1999_MYS <- ggplot() + geom_raster(lai1999_MYS, mapping = aes(x=x, y=y, fill=LAI.1km.1)) + scale_fill_viridis(option="viridis") + ggtitle ("LAI 1999")
P2006_MYS <- ggplot() + geom_raster(lai2006_MYS, mapping = aes(x=x, y=y, fill=LAI.1km.2)) + scale_fill_viridis(option="viridis") + ggtitle ("LAI 2006")
P2013_MYS <- ggplot() + geom_raster(lai2013_MYS, mapping = aes(x=x, y=y, fill=LAI.1km.3)) + scale_fill_viridis(option="viridis") + ggtitle ("LAI 2013")
P2020_MYS <- ggplot() + geom_raster(lai2020_MYS, mapping = aes(x=x, y=y, fill=LAI.1km.4)) + scale_fill_viridis(option="viridis") + ggtitle ("LAI 2020")

# Export the ggplots in a PNG file
png(file="LAI Malaysia.png", units="cm", width=15, height=23, res=600)
# use patchwork to plot all fours images together
P1999_MYS / P2006_MYS / P2013_MYS / P2020_MYS
dev.off()

# Scatterplot matrix for Malaysia
MYS_stack<-stack(lai1999_MYS,lai2006_MYS,lai2013_MYS,lai2020_MYS) # create a stack from the 4 variables first
# Recall the variable
MYS_stack
names(MYS_stack) <- c("LAI.1999","LAI.2006","LAI.2013","LAI.2020")

# use the pairs function
pairs(MYS_stack) # density plot, scatterplot, and Pearson coefficient

# Save the scatterplot multiframe in a PNG file
png(file="LAI scatterplot.png", units="cm", width=20, height=20, res=600)
pairs(MYS_stack) # density plot, scatterplot, and Pearson coefficient
dev.off()

# Focus on Peninsular Malaysia LAI difference
# Crop the area first
P_MYS<-c(99.6419, 105, 0.8527, 7.3529)
P_MYS_1999 <- crop(lai1999,P_MYS)
P_MYS_2006 <- crop(lai2006,P_MYS)
P_MYS_2013 <- crop(lai2013,P_MYS)
P_MYS_2020 <- crop(lai2020,P_MYS)

# Compute the difference between the layers
P_MYS_dif <- P_MYS_2020-P_MYS_1999

# Plot!
plot(P_MYS_dif, col=viridis)

# Use diverging colors to plot the positive and negative change in LAI
# from diverging palette from the colorspace package
red_green <- diverging_hcl(5, "Red-Green")
red_green # recall the variable to see the color palette
# "#841859" "#F398C4" "#F6F6F6" "#7CC57D" "#005600"

# This palette does not center in 0, but we want the light grey color to be exactly in 0

# Palette for the top half of the image, with positive values
green <- colorRampPalette(colors = c("#F6F6F6", "#7CC57D", "#005600"))(50.33283)

# Palette for the bottom half of the image, with negative values
red <- colorRampPalette(colors = c("#841859", "#F398C4", "#F6F6F6"))(61.66605)

# Combine the two color palettes
red_green <- c(red, green)

# Plot!
plot(P_MYS_dif, col=red_green) # now the midpoint of the palette is in 0!

# Make a multiframe of the LAI in 1999, the difference, and the LAI 2020
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
Sarawak1999 <- crop(lai1999,Sarawak)
Sarawak2006 <- crop(lai2006,Sarawak)
Sarawak2013 <- crop(lai2013,Sarawak)
Sarawak2020 <- crop(lai2020,Sarawak)

dif_Sar <-Sarawak2020-Sarawak1999

# We need to "recalibrate" the red_green palette to be centered in 0
# To do this, we take the min and max values of dif_Sar and we multiply it by 10; this number is the number of shades for each color
dif_Sar # values: -5.833275, 5.233281  (min, max)

# Palette for the top half of the image, with positive values
green2 <- colorRampPalette(colors = c("#F6F6F6", "#7CC57D", "#005600"))(52.33281)

# Palette for the bottom half of the image, with negative values
red2 <- colorRampPalette(colors = c("#841859", "#F398C4", "#F6F6F6"))(58.33275)

# Combine the two color palettes
red_green2 <- c(red2, green2)

par(mfrow=c(1,3))
plot(Sarawak1999, col=viridis, main="LAI in 1999")
plot(dif_Sar, col=red_green2, main="1999-2020 difference")
plot(Sarawak2020, col=viridis, main="LAI in 2020")

# Plot the difference between each 7 years
# We have to adjust the palette for each plot so it's centered in 0
# Again, one way to do this is by taking the max and min values from each computed difference and multiply it by 10
lai_99_06 <-P_MYS_2006-P_MYS_1999 # difference between LAI in 2006 and LAI in 1999

lai_gr_a <- colorRampPalette(colors = c("#F6F6F6", "#7CC57D", "#005600"))(53.99946)
lai_rd_a <- colorRampPalette(colors = c("#841859", "#F398C4", "#F6F6F6"))(55.33278)
lai_rd_gr_a <- c(lai_rd_a, lai_gr_a)

plot(lai_99_06, col=lai_rd_gr_a, main="1999 - 2006")

lai_06_13 <-P_MYS_2013-P_MYS_2006 # difference between LAI in 2013 and LAI in 2006

lai_gr_b <- colorRampPalette(colors = c("#F6F6F6", "#7CC57D", "#005600"))(58.33275)
lai_rd_b <- colorRampPalette(colors = c("#841859", "#F398C4", "#F6F6F6"))(54.33279)
lai_rd_gr_b <- c(lai_rd_b, lai_gr_b)

plot(lai_06_13, col=lai_rd_gr_b, main="2006 - 2013")

lai_13_20<-P_MYS_2020-P_MYS_2013 # difference between LAI in 2020 and LAI in 2013

lai_gr_c <- colorRampPalette(colors = c("#F6F6F6", "#7CC57D", "#005600"))(45.99954)
lai_rd_c <- colorRampPalette(colors = c("#841859", "#F398C4", "#F6F6F6"))(61.66605)
lai_rd_gr_c <- c(lai_rd_c, lai_gr_c)

plot(lai_13_20, col=lai_rd_gr_c, main="2013 - 2020")

# Safe files as PNG and a multiframe
png(file="LAI 7 years timeframe difference.png", units="cm", width=30, height=12.4, res=600)
par(mfrow=c(1,3))

# Here I am changing the default par() options to make the backgrount transparent and the colors of the axis, axis' names, foreground, titles in yellow to match my presentation theme for the exam
par(bg=NA, col.axis="#fde725", col.lab="#fde725", bg="transparent", col.main="#fde725", col.sub="#fde725", fg="#fde725")

plot(lai_99_06, col=lai_rd_gr_a, colNA="light blue", main="LAI 1999 - 2006")
plot(lai_06_13, col=lai_rd_gr_b, colNA="light blue", main="LAI 2006 - 2013")
plot(lai_13_20, col=lai_rd_gr_c, colNA="light blue", main="LAI 2013 - 2020")
dev.off()

# We can estimate quantitatively how much of the area has a negative difference in LAI and how much has a positive one
# First, we count the total values available
length(P_MYS_dif[P_MYS_dif, na.rm=T]) # na.rm removes all the NA values, e.g. sea area
# the total values available are 197112
total <- length(P_MYS_dif[P_MYS_dif, na.rm=T])
# let's consider only changes bigger than 0.25 and smaller that - 0.25 to eliminate possible minor inaccuracies from technology and the small changes in LAI
pos <- length(P_MYS_dif[P_MYS_dif > 0.25, na.rm=T]) # all positive LAI difference values 
pos # 41060
neg <- length(P_MYS_dif[P_MYS_dif < -0.25, na.rm=T]) # all negative LAI difference values 
neg # 63356
ppos <- pos/total*100 # percentage of positive change in LAI ~ 20.83 possibly the number of new plantations since 1999
pneg <- neg/total*100 # percentage of negative change in LAI ~ 32.14 possibly areas that have been damaged or deforestated
nochange <- (total-pos-neg)/total*100
nochange # 47.03

# Make a data frame with the obtained results
LAI_change <- c("LAI increase", "LAI decrease", "No changes")
prop_change <- c(ppos, pneg, nochange)
prop_frame <- data.frame(LAI_change, prop_change)

# make a histogram with ggplot2
land_change_plot <- ggplot(prop_frame, aes(x=LAI_change, y=prop_change, fill=LAI_change)) + scale_x_discrete(name = "LAI change") + scale_y_discrete(name = "Area proportion") + geom_bar(stat="identity", color="#181818") + geom_text(aes(label=sprintf("%0.2f", round(prop_change, digits = 2))), vjust=3.6, color="#181818", size=6) + scale_fill_manual("LAI_change", values = c("LAI increase" = "#7CC57D", "LAI decrease" = "#F398C4", "No changes" = "#F6F6F6")) + theme_minimal()
land_change_plot

# We can also plot the LAI difference map next to the histogram, using the same diverging color palette
names(P_MYS_dif)<-c("LAI.difference") # this will appear as the label in the legend of the ggplot

# The palette colours are the same as the ones used to plot the LAI difference
gg_green <- colorRampPalette(colors = c("#F6F6F6", "#7CC57D", "#005600"))(50)
gg_red <- colorRampPalette(colors = c("#841859", "#F398C4", "#F6F6F6"))(50)

# I had to change x=x, y=y to x=as.numeric(x), y=as.numeric(y) to change both variables to numeric; because otherwise there is an error - "Error: discrete value supplied to continuous scale"
P_MYS_dif_gg <- ggplot() + geom_raster(P_MYS_dif, mapping = aes(x=as.numeric(x), y=as.numeric(y), fill=LAI.difference)) + scale_x_discrete(name = "Longitude") + scale_y_discrete(name = "Latitude") + scale_fill_gradient2(midpoint=0, low=gg_red, high=gg_green, mid="#F6F6F6") + ggtitle ("1999-2020 LAI change") + theme_minimal()

# We can now use patchwork to plot both the map and the histogram together
P_MYS_dif_gg + land_change_plot



