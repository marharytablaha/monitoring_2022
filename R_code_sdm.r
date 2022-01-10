# R code for Spacial Distribution Modelling, namely the distribution of individuals

library(sdm)
library(rgdal) # predictors: environmental variables
library(raster) # species: vector data

# species data
# .shp is the extension used a lot in shape geography
file <- system.file("external/species.shp", package="sdm")
file

species <- shapefile(file) # exatcly as the raster function for raster files
# how many occurrences are there? Subset a DataFrame
species[species$Occurrence == 1,]

presences <- species[species$Occurrence == 1,]
absences <- species[species$Occurrence == 0,]

# plot!
plot(species, pch=19, col="red")

# plot presences and absences
plot(presences, pch=19, col="blue")
points(absences, pch=19, col="red")

# let's look at the predictors
path <- system.file("external", package="sdm")
lst <- list.files(path, pattern='asc', full.names=TRUE)
lst

# you canuse the lapply function with the raster function but in this case it is not needed because the system file has a asc extention
preds <- stack(lst)
cl <- colorRampPalette(c('blue','orange','red','yellow')) (100)
plot(preds, col=cl)

plot(preds$elevation, col=cl)
points(presences, pch=19)

plot(preds$temperature, col=cl)
points(presences, pch=19)

plot(preds$vegetation, col=cl)
points(presences, pch=19)

plot(preds$precipitation, col=cl)
points(presences, pch=19)

# set the data for the sdm
