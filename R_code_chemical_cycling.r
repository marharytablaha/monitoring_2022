# R code for chemical cycling study
# Time series of NO2 change in Europe

# set the working directory
setwd("C:/lab/EN/")

# Import the files
library(raster)
EN01 <- raster("EN_0001.png")
# What is the range of the data? min and max 0 and 255

cl <- colorRampPalette(c('red','orange','yellow'))(100)
# Import the end of March and plot it 
EN13 <- raster("EN_0013.png")

# Build a multiframe window 
par(mfrow=c(2,1))
plot(EN01, col=cl)
plot(EN13, col=cl)

# Import all the sets and plot the sets all together

EN01 <- raster("EN_0001.png")
EN02 <- raster("EN_0002.png")
EN03 <- raster("EN_0003.png")
EN04 <- raster("EN_0004.png")
EN05 <- raster("EN_0005.png")
EN06 <- raster("EN_0006.png")
EN07 <- raster("EN_0007.png")
EN08 <- raster("EN_0008.png")
EN09 <- raster("EN_0009.png")
EN10 <- raster("EN_0010.png")
EN11 <- raster("EN_0011.png")
EN12 <- raster("EN_0012.png")
EN13 <- raster("EN_0013.png")

par(mfrow=c(4,4))
plot(EN01, col=cl)
plot(EN02, col=cl)
plot(EN03, col=cl)
plot(EN04, col=cl)
plot(EN05, col=cl)
plot(EN06, col=cl)
plot(EN07, col=cl)
plot(EN08, col=cl)
plot(EN09, col=cl)
plot(EN10, col=cl)
plot(EN11, col=cl)
plot(EN12, col=cl)
plot(EN13, col=cl)

# use the stack function instead to import the data, importing all the layers all together
EN <- stack(EN01,EN02,EN03,EN04,EN05,EN06,EN07,EN08,EN09,EN10,EN11,EN12,EN13)
# Plot the stack alltogether
plot(EN, col=c1)

# Plot only the first image from the stack
plot(EN$EN_0001, col=cl)

# Plot an RGB space 
plotRGB(EN, r=1, g=7, b=13, stretch="Lin")

dev.off()

# direct import
