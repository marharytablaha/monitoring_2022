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
library(patchwork) # for comparing separate ggplots

# Set the working directory
setwd("C:/lab/LAI/")
# one way of importing is one by one
lai1999 <- raster("c_gls_LAI_199907100000_GLOBE_VGT_V2.0.2.nc")
lai1999

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
plot(P_MYS_1999, col=viridis, main="LAI in 1999")
plot(P_MYS_dif, col=red_green, main="1999-2020 difference")
plot(P_MYS_2020, col=viridis, main="LAI in 2020")

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

# Plot the difference between each 7 years for Peninsular Malaysia
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

# Let's sum all the LAI values of Peninsular Malaysia and divide them for the respective area to dind out if there was a significant change in LAI

# Sum the values with NAs removed
sum_pmys99<-sum(P_MYS_1999[P_MYS_1999, na.rm=T])
sum_pmys06<-sum(P_MYS_2006[P_MYS_2006, na.rm=T])
sum_pmys13<-sum(P_MYS_2013[P_MYS_2013, na.rm=T])
sum_pmys20<-sum(P_MYS_2020[P_MYS_2020, na.rm=T])

# Calculate the area with NAs removed
area99<-length(P_MYS_1999[P_MYS_1999, na.rm=T])
area06<-length(P_MYS_2006[P_MYS_2006, na.rm=T])
area13<-length(P_MYS_2013[P_MYS_2013, na.rm=T])
area20<-length(P_MYS_2020[P_MYS_2020, na.rm=T])

# Divide the sum by the area
sum99<-sum_pmys99/area99
sum06<-sum_pmys06/area06
sum13<-sum_pmys13/area13
sum20<-sum_pmys20/area20

# Create a data frame
year<-c("1999", "2006", "2013", "2020")
sum<-c(sum99, sum06, sum13, sum20)
proportion<-data.frame(sum, lai.sum)

# Plot with ggplot2
total_lai<- ggplot(proportion, aes(x=year, y=sum, fill=year)) + scale_x_discrete(name = "Year") + scale_y_discrete(name = "Total LAI") + geom_bar(stat="identity", width = 0.4, color="#181818") + scale_fill_manual("Year", values = c(viridis(4))) + theme_minimal() + ggtitle("Total LAI from 1999 to 2020")

######## I've dowloaded FAPAR and FCover data to compare it to LAI data ########

# to import it I've use the same method as for LAI, so:
rlist <- list.files(pattern="c_gls_FAPAR")
rlist
list_rast <- lapply(rlist, raster) # use lapply function to make a raster list from the list of files
list_rast
parstack <- stack(list_rast) # we create a raster stack
parstack

# Change names of the parstack
names(parstack)<-c("FAPAR.1km.1","FAPAR.1km.2","FAPAR.1km.3","FAPAR.1km.4")

parstack # recall the stack to see if everything is correct

# and then we separate the files, assigning to each element of the stack a name
par1999 <- parstack$FAPAR.1km.1
par2006 <- parstack$FAPAR.1km.2
par2013 <- parstack$FAPAR.1km.3
par2020 <- parstack$FAPAR.1km.4

# Focus on Peninsular Malaysia FAPAR
# Crop the area
pmys<-c(99.6419, 105, 0.8527, 7.3529)
pmys1999<-crop(par1999, pmys)
pmys2006<-crop(par2006, pmys)
pmys2013<-crop(par2013, pmys)
pmys2020<-crop(par2020, pmys)

# Computing the difference between the first and the last year (1999 and 2020)
fapar_99_20<-par2020_MYS - par1999_MYS
fapar_99_20 # values:    -0.94, 0.624 (min, max)

# Palette recalibration to center it in 0
# Palette for the top half of the image, with positive values
fapar_gr <- colorRampPalette(colors = c("#F6F6F6", "#7CC57D", "#005600"))(62.4)

# Palette for the bottom half of the image, with negative values
fapar_rd <- colorRampPalette(colors = c("#841859", "#F398C4", "#F6F6F6"))(94)

fapar_rd_gr <- c(fapar_rd, fapar_gr)

plot(fapar_99_20, col=fapar_rd_gr, colNA="light blue")

# Plot the difference between each 7 years
# We have to adjust the palette for each plot so it's centered in 0, where the corresponding color will be light gray
# We do this by taking the max and min values from each computed difference and multiply it by 10
fapar_99_06<-pmys2006-pmys1999
fapar_06_13<-pmys2013-pmys2006
fapar_13_20<-pmys2020-pmys2013
fapar_99_06 # values     : -0.9, 0.792  (min, max)
fapar_06_13 # values     : -0.94, 0.808  (min, max)
fapar_13_20 # values     : -0.92, 0.572  (min, max)

fapar_gr_a <- colorRampPalette(colors = c("#F6F6F6", "#7CC57D", "#005600"))(79.2)
fapar_rd_a<- colorRampPalette(colors = c("#841859", "#F398C4", "#F6F6F6"))(90)
fapar_rd_gr_a <- c(fapar_rd_a, fapar_gr_a)
plot(fapar_99_06, col=fapar_rd_gr_a, main="1999 - 2006")

fapar_gr_b <- colorRampPalette(colors = c("#F6F6F6", "#7CC57D", "#005600"))(80.8)
fapar_rd_b<- colorRampPalette(colors = c("#841859", "#F398C4", "#F6F6F6"))(94)
fapar_rd_gr_b <- c(fapar_rd_b, fapar_gr_b)
plot(fapar_06_13, col=fapar_rd_gr_b, main="2006 - 2013")

fapar_gr_c <- colorRampPalette(colors = c("#F6F6F6", "#7CC57D", "#005600"))(57.2)
fapar_rd_c<- colorRampPalette(colors = c("#841859", "#F398C4", "#F6F6F6"))(92)
fapar_rd_gr_c <- c(fapar_rd_c, fapar_gr_c)
plot(fapar_13_20, col=fapar_rd_gr_c, main="2013 - 2020")

# Now we can plot the multiframe for FAPAR difference too!
par(mfrow=c(2,2))
plot(fapar_99_06, col=fapar_rd_gr_a, colNA="light blue", main="FAPAR 1999 - 2006")
plot(fapar_06_13, col=fapar_rd_gr_b, colNA="light blue", main="FAPAR 2006 - 2013")
plot(fapar_13_20, col=fapar_rd_gr_c, colNA="light blue", main="FAPAR 2013 - 2020")
plot(fapar_99_20, col=fapar_rd_gr, colNA="light blue", main="FAPAR 1999 - 2020")

# Repeat for FCover

setwd("C:/lab/FCOVER/") # Set working directory

# we can  import multiple files at once that have the same pattern in the name
rlist <- list.files(pattern="c_gls_FCOVER")
rlist
list_rast <- lapply(rlist, raster) # use lapply function to make a raster list from the list of files
list_rast
fcoverstack <- stack(list_rast) # we create a stack
fcoverstack

# Change names of the fcoverstack
names(fcoverstack)<-c("FCOVER.1km.1","FCOVER.1km.2","FCOVER.1km.3","FCOVER.1km.4")

fcoverstack # recall the stack to see if everything is correct

# and then we separate the files, assigning to each element of the stack a name
fcover1999 <- fcoverstack$FCOVER.1km.1
fcover2006 <- fcoverstack$FCOVER.1km.2
fcover2013 <- fcoverstack$FCOVER.1km.3
fcover2020 <- fcoverstack$FCOVER.1km.4

# Export a PNG file of the global Fcover in 2020
png(file="FCOVER global 2020.png", units="cm", width=25, height=14, res=600)
par(bg=NA)
plot(fcover2020, col=viridis, colNA=NA, bg="transparent")
dev.off()

# Focus on Peninsular Malaysia FAPAR difference
# We already have the values for cropping
pmys<-c(99.6419, 105, 0.8527, 7.3529)
fcover_pmys1999<-crop(fcover1999, pmys)
fcover_pmys2006<-crop(fcover2006, pmys)
fcover_pmys2013<-crop(fcover2013, pmys)
fcover_pmys2020<-crop(fcover2020, pmys)

# Plot the difference between each 7 years
# Adjust the palette for each plot so it's centered in 0, where the corresponding color will be light gray
# We do this by taking the max and min values from each computed difference and multiply it by 10
fcover_99_06<-fcover_pmys2006-fcover_pmys1999
fcover_06_13<-fcover_pmys2013-fcover_pmys2006
fcover_13_20<-fcover_pmys2020-fcover_pmys2013
fcover_99_20<-fcover_pmys2020-fcover_pmys1999

fcover_99_06 # values     : -0.948, 0.844  (min, max)
fcover_06_13 # values     : -0.944, 0.952  (min, max)
fcover_13_20 # values     : -0.96, 0.704  (min, max)
fcover_99_20 # values     : -1, 0.628  (min, max)

fcover_gr_a <- colorRampPalette(colors = c("#F6F6F6", "#7CC57D", "#005600"))(84.8)
fcover_rd_a<- colorRampPalette(colors = c("#841859", "#F398C4", "#F6F6F6"))(94.8)
fcover_rd_gr_a <- c(fcover_rd_a, fcover_gr_a)
plot(fcover_99_06, col=fcover_rd_gr_a, colNA="light blue", main="1999 - 2006")

fcover_gr_b <- colorRampPalette(colors = c("#F6F6F6", "#7CC57D", "#005600"))(95.2)
fcover_rd_b<- colorRampPalette(colors = c("#841859", "#F398C4", "#F6F6F6"))(94.4)
fcover_rd_gr_b <- c(fcover_rd_b, fcover_gr_b)
plot(fcover_06_13, col=fcover_rd_gr_b, colNA="light blue", main="2006 - 2013")

fcover_gr_c <- colorRampPalette(colors = c("#F6F6F6", "#7CC57D", "#005600"))(70.4)
fcover_rd_c<- colorRampPalette(colors = c("#841859", "#F398C4", "#F6F6F6"))(96)
fcover_rd_gr_c <- c(fcover_rd_c, fcover_gr_c)
plot(fcover_13_20, col=fcover_rd_gr_c, colNA="light blue", main="2013 - 2020")

fcover_gr <- colorRampPalette(colors = c("#F6F6F6", "#7CC57D", "#005600"))(62.8)
fcover_rd<- colorRampPalette(colors = c("#841859", "#F398C4", "#F6F6F6"))(100)
fcover_rd_gr <- c(fcover_rd, fcover_gr)
plot(fcover_99_20, col=fcover_rd_gr, colNA="light blue", main="1999 - 2020")

# We can now plot all the difference values obtained from LAI, FAPAR, and FCover together (9 plots)
par(mfrow=c(3,3)) # make a multiframe 3x3
par(bg=NA, col.axis="#fde725", col.lab="#fde725", bg="transparent", col.main="#fde725", col.sub="#fde725", fg="#fde725") # change default par() options

# Plot!
plot(lai_99_06, col=lai_rd_gr_a, colNA="light blue", main="LAI 1999 - 2006")
plot(lai_06_13, col=lai_rd_gr_b, colNA="light blue", main="LAI 2006 - 2013")
plot(lai_13_20, col=lai_rd_gr_c, colNA="light blue", main="LAI 2013 - 2020")
plot(fapar_99_06, col=fapar_rd_gr_a, colNA="light blue", main="FAPAR 1999 - 2006")
plot(fapar_06_13, col=fapar_rd_gr_b, colNA="light blue", main="FAPAR 2006 - 2013")
plot(fapar_13_20, col=fapar_rd_gr_c, colNA="light blue", main="FAPAR 2013 - 2020")
plot(fcover_99_06, col=fcover_rd_gr_a, colNA="light blue", main="FCOVER 1999 - 2006")
plot(fcover_06_13, col=fcover_rd_gr_b, colNA="light blue", main="FCOVER 2006 - 2013")
plot(fcover_13_20, col=fcover_rd_gr_c, colNA="light blue", main="FCOVER 2013 - 2020")

# We can also sum the difference between 2020 and 1999 from each Copernicus service analysed

# Let's add the variables from the same timeframe, so we can make 3 plots in separated timeframes first
sum_99_06<-lai_99_06+fapar_99_06+fcover_99_06
sum_06_13<-lai_06_13+fapar_06_13+fcover_06_13
sum_13_20<-lai_13_20+fapar_13_20+fcover_13_20

sum_99_06 # values     : -6.963946, 6.662615  (min, max)
sum_06_13 # values     : -6.719948, 6.577275  (min, max)
sum_13_20 # values     : -7.998605, 5.867954  (min, max)

# Adjusting the palette
sum_gr_a <- colorRampPalette(colors = c("#F6F6F6", "#7CC57D", "#005600"))(66.62615 )
sum_rd_a<- colorRampPalette(colors = c("#841859", "#F398C4", "#F6F6F6"))(69.63946)
sum_rd_gr_a <- c(sum_rd_a, sum_gr_a)

sum_gr_b <- colorRampPalette(colors = c("#F6F6F6", "#7CC57D", "#005600"))(65.77275)
sum_rd_b<- colorRampPalette(colors = c("#841859", "#F398C4", "#F6F6F6"))(67.19948)
sum_rd_gr_b <- c(sum_rd_b, sum_gr_b)

sum_gr_c <- colorRampPalette(colors = c("#F6F6F6", "#7CC57D", "#005600"))(58.67954)
sum_rd_c<- colorRampPalette(colors = c("#841859", "#841859", "#F398C4", "#F398C4", "#F6F6F6"))(79.98605)
sum_rd_gr_c <- c(sum_rd_c, sum_gr_c)

# Plot a multiframe 3x1
par(mfrow=c(1,3))
par(bg=NA, col.axis="#fde725", col.lab="#fde725", bg="transparent", col.main="#fde725", col.sub="#fde725", fg="#fde725")
plot(sum_99_06, col=sum_rd_gr_a, colNA="light blue", main="VGT 1999 - 2006")
plot(sum_06_13, col=sum_rd_gr_b, colNA="light blue", main="VGT 2006 - 2013")
plot(sum_13_20, col=sum_rd_gr_c, colNA="light blue", main="VGT 2013 - 2020")

# Sum all the 3 timeframes into 1
total_sum<-sum_99_06+sum_06_13+sum_13_20
total_sum # values     : -8.006606, 6.285283  (min, max)

total_gr <- colorRampPalette(colors = c("#F6F6F6", "#7CC57D", "#005600"))(62.85283)
total_rd<- colorRampPalette(colors = c("#841859", "#F398C4", "#F6F6F6"))(80.06606)
total_rd_gr <- c(total_rd, total_gr)

# Export the obtained plot as a PNG
png(file="Sum of LAI, FAPAR and FCOVER.png", units="cm", width=20, height=20, res=600)
par(bg=NA, col.axis="#fde725", col.lab="#fde725", bg="transparent", col.main="#fde725", col.sub="#fde725", fg="#fde725")
plot(total_sum, col=total_rd_gr, colNA="light blue")
dev.off()

# I want to try using a "dark mode" palette; it highlights very well the changes on the map
black_green <- colorRampPalette(colors = c("#181818", "#11C638", "#95D69A"))(62.85283)

# Palette for the bottom half of the image, with negative values
orange_black <- colorRampPalette(colors = c("#F0BC95", "#EF9708","#181818"))(80.06606)

# Combine the two color palettes
orange_green <- c(orange_black, black_green)

# Compare the two plots
par(mfrow=c(1,2))
plot(total_sum, col=total_rd_gr, colNA="light blue")
plot(total_sum, col=orange_green, colNA="light blue")

# Lastly, I used the pairs function to compare the 9 plots of the difference values obtained from LAI, FAPAR, and FCover together
# Make a stack of all the variables
all_indicators<-stack(lai_99_06, lai_06_13, lai_13_20, fapar_99_06, fapar_06_13, fapar_13_20, fcover_99_06, fcover_06_13, fcover_13_20)

# Change the names; they will appear in the final plot
names(all_indicators) <- c("LAI.99.06", "LAI.06.13", "LAI.13.20", "FAPAR.99.06", "FAPAR.06.13", "FAPAR.13.20", "FCOVER.99.06", "FCOVER.06.13", "FCOVER.13.20")

pairs(all_indicators)

# Save the file with a PNG extention
png(file="PAIRS with all the differences.png", units="cm", width=30, height=30, res=600)
par(bg=NA, col.axis="#fde725", col.lab="#fde725", bg="transparent", col.main="#fde725", col.sub="#fde725", fg="#fde725")
pairs(all_indicators)
dev.off()
