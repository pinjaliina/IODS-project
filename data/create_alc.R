# R Script for the University of Helsinki course Introduction to Open Data Science
# RStudio Exercise 3.
# 
# Author: Pinja-Liina Jalkanen
# Created: Sun 5 Feb, 2017
#
# Source data:
# F. Pagnotta & H. M. Amran (2008). Using Data Mining To Predict Secondary
# School Student Alcohol Consumption. Department of Computer Science,
# University of Camerino. Referred 05/02/17.
# https://archive.ics.uci.edu/ml/datasets/STUDENT+ALCOHOL+CONSUMPTION

###########################
## Initialise the script ##
###########################

# Clear memory.
rm(list = ls())

# Define packages required by this script.
library(dplyr)

# Reset graphical parameters and save the defaults.
plot.new()
.pardefault <- par(no.readonly = TRUE)
dev.off()

########################
## Data wranging part ##
########################

# Set working directory.
setwd('/Users/pinsku/Dropbox/HY/Tilastotiede/IODS/IODS-project/data')

# Read in data.
math <- as.data.frame(read.table('student/student-mat.csv', sep=';', header = TRUE))
portugese <- as.data.frame(read.table('student/student-por.csv', sep=';', header = TRUE))

# Explore structure and dimensions of the data frames with glimpse().
glimpse(math)
glimpse(portugese)

# Create an inner join of the math and portugese tables on fields
# defined by the exercise instructions.
alc <- inner_join(math, portugese, by = c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet"), suffix = c("_m", "_p"))

# Explore structure and dimensions of the DF of the joined data.
glimpse(alc)

# Loop through columns and combine data of columns not used on joining.
# If the suffix of the name is '_m', test whether it's numeric; if true, select
# both it and its counterpart with suffix '_p' and calculate their rowmeans.
# If it's not numeric, just assign its values to new column without the suffix.
# Finally, drop all columns with name suffixes.
# (This is method 'b' of the instructions!)
for(name in colnames(alc)) {
  if(grepl('_m$', name, perl = TRUE)) {
    newname <- sub('_m$', '', name, perl = TRUE)
    mc_name <- name
    pc_name <- paste(newname, '_p', sep = '')
    mc <- select(alc, matches(mc_name))
    # Calculate rowmeans of mc and pc, if the variable is numeric.
    if(is.numeric(mc)) {
      both <- select(alc, one_of(c(mc_name, pc_name)))
      alc[newname] <- round(rowMeans(both))
    }
    # Else just assign mc to a new name.
    else {
      alc[newname] <- mc
    }
    alc[name] <- NULL # Drop the original '_m' column.
  }
  if(grepl('_p$', name, perl = TRUE)) {
    alc[name] <- NULL # Drop the original '_p' column.
  }
}

# Calculate the average (of weekends and weekdays) alcohol consumption.
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# Define a logical column of high use.
alc <- mutate(alc, high_use = alc_use > 2)

# Explore structure and dimensions of the DF with glimpse().
glimpse(alc)

# Write the DF to a file.
write.table(alc, file = "alc.csv", sep = "\t", col.names = TRUE)