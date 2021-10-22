# This is my first code in GitHub!

# Here are the input data
# Costanza data on streams
water <- c(100, 200, 300, 400, 500)
water

# Marta data on fishes genomes
fishes <- c(10, 50, 60, 100, 200)
fishes

# plot the diversity of fishes (y) versus the amount of water (x)
# a function is used with arguments inside!
plot(water, fishes)

# the data we developed can be stored in a table
# a table in R is called data frame

streams <- data.frame(water,fishes)

# From now on, we are going to import and or export data

# setwd for Windows
setwd("C:/lab/")

# Let's export our table!
write.table(streams, file="my_first_table.txt")

# Some colleagues sent us a table. How to import it in R?
read.table("my_first_table.txt")

# Assign the table to a name
margotable <- read.table("my_first_table.txt")
margotable

# the first statistics for lazy beautiful people
summary(margotable)

# Marta does not like water
# Marta wants to get info only on fishes
summary(margotable$fishes)

# histogram
hist(margotable$fishes)
hist(margotable$water)
