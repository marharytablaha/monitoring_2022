# R_code_quantitative_estimate_land_cover.r

library(raster)

# set the working directory setwd("C:/lab/")
# import the files
# 1 list the files available
rlist<-list.files(pattern="defor")

# 2 lapply: apply a function to the list
list_rast<-lapply(rlist,brick)
list_rast

plot(list_rast[[1]])

plotRGB(list_rast[[1]], r=1, g=2, b=3, stretch="Lin")
l1992<-list_rast[[1]]
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin")
l2006<-list_rast[[2]]
plotRGB(l2006, r=1, g=2, b=3, stretch="Lin")

library(RStoolbox)
# unsupervised classification
l1992c<-unsuperClass(l1992, nClasses=2)
plot(l1992c$map)
# value 1 = forests
# value 2 = agricultural areas and water

freq(l1992c$map)

# forests = 1490490
# agricultural areas and water = 304628

total<-1800000
propagri<-304628/total
propforest<-1490490/total
# propforest = 0.82805 ~ 0.83
# propagri = 0.1692378 ~ 0.17

# build a dataframe
cover<-c("Forest", "Agriculture")
prop1992<-c(propforest, propagri)
proportion1992<-data.frame(cover, prop1992)

library(ggplot2)
ggplot(proportion1992, aes(x=cover, y=prop1992, color=cover)) + geom_bar(stat="identity", fill="white")

# Classification of 2006
# Unsupervised classification
l2006c<-unsuperClass(l2006, nClasses=2)
plot(l2006c$map)
freq(l2006c$map)

# forests = 3952566 
# agricultural areas and water = 3247434

total2006<-7200000
propagri2006<-3247434/total2006
propforest2006<-3952566/total2006
prop2006<-c(propforest2006,propagri2006)
proportion <-data.frame(cover,prop1992,prop2006)

ggplot(proportion, aes(x=cover, y=prop2006, color=cover)) + geom_bar(stat="identity", fill="white")
p1<-ggplot(proportion1992, aes(x=cover, y=prop1992, color=cover)) + geom_bar(stat="identity", fill="white")+ylim(0,1)
p2<-ggplot(proportion, aes(x=cover, y=prop2006, color=cover)) + geom_bar(stat="identity", fill="white")+ylim(0,1)

grid.arrange(p1, p2, nrow=1)

install.packages("patchwork")
library(patchwork)
p1+p2
# If you want to put one graph on top of the other:
p1/p2
l1992
# patchwork is working with raster data, but they should be plotted with ggRGB
# instead of using plogRGB we are going to use ggRGB
ggRGB(l1992, r=1, g=2, b=3)
ggRGB(l1992, r=1, g=2, b=3, stretch="lin")
ggRGB(l1992, r=1, g=2, b=3, stretch="hist")
ggRGB(l1992, r=1, g=2, b=3, stretch="sqrt")
ggRGB(l1992, r=1, g=2, b=3, stretch="log")

# patchwork
gp1<-ggRGB(l1992, r=1, g=2, b=3, stretch="lin")
gp2<-ggRGB(l1992, r=1, g=2, b=3, stretch="hist")
gp3<-ggRGB(l1992, r=1, g=2, b=3, stretch="sqrt")
gp4<-ggRGB(l1992, r=1, g=2, b=3, stretch="log")

gp1+gp2+gp3+gp4

# multitemporal patchwork
gp1 <- ggRGB(l1992, r=1, g=2, b=3)
gp5 <- ggRGB(l2006, r=1, g=2, b=3)
 
gp1 + gp5

