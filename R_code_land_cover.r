library(raster)
library(patchwork)
setwd("C:/lab/Land Cover Malaysia")
LC2015<-brick("LC2015_TreeCoverFraction.tif")
LC2019<-brick("LC2019_TreeCoverFraction.tif")

# recall the variables to read the descriptors

# let's plot the images
plot(LC2015)
plot(LC2019)

# crop
ext<-c(99.6419, 119.2758, 0.8527, 7.3529)
LC2015<-crop(LC2015,ext)
LC2019<-crop(LC2019,ext)

# multiframe
par(mfrow=c(1,2))
plot(LC2015)
plot(LC2019)

# let's change the palette
library(viridis)
viridis(3) #generate a palette
viridis<-colorRampPalette(c("#440154FF", "#21908CFF", "#FDE725FF"))(100) 

par(mfrow=c(2,1))
plot(LC2015, col=viridis)
plot(LC2019, col=viridis)

library(RStoolbox)
LC2015c<-unsuperClass(LC2015, nClasses=2)
plot(LC2015c$map)
# value 1 = urban and crop area
# value 2 = forest
freq(LC2015c$map)

# result
#      value    count
# [1,]     1 35620029
# [2,]     2  9980411
# [3,]    NA 81704920

total<-35620029+9980411
propurbanagri<-9980411/total
propforest<-35620029/total
# propforest = 0.7811334 ~ 0.78
# propurbanagri = 0.2188666 ~ 0.22

# build a dataframe
cover<-c("Forest", "Urban and Agriculture")
prop2015<-c(propforest, propurbanagri)
proportion2015<-data.frame(cover, prop2015)

library(ggplot2)
ggplot(proportion2015, aes(x=cover, y=prop2015, color=cover)) + geom_bar(stat="identity", fill="white")
