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
prop1992<-c(0.82805, 0.1692378)
proportion1992<-data.frame(cover, prop1992)

library(ggplot2)
ggplot(proportion1992, aes(x=cover, y=prop1992, color=cover)) + geom_bar(stat="identity", fill="white")
