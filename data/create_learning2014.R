# R Script for the University of Helsinki course Introduction to Open Data Science
# RStudio Exercise 2.
# 
# Author: Pinja-Liina Jalkanen
# Created: Sat 28 Jan, 2017

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

# Read the requested input file to a dataframe.
lrn2014 <- as.data.frame(read.table('http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt',  sep="\t", header=TRUE))

# Dimensional exploration: the following test demonstrates that the data
# has 183 rows and 60 columns.
dim(lrn2014)
# Structural exploration: the following test shows the datatypes – most of
# them integers, but the gender variable is a factor with 2 levels.
str(lrn2014)

# Filter all observations with zero points.
lrn2014 <- filter(lrn2014, Points > 0)

# Create a new DF for the analysis dataset. Keep columns that are not averaged.
lrn2014a <- select(lrn2014, one_of(c('Age', 'Attitude', 'Points', 'gender')))

# Convert all analysis DF variable names to lowercase:
names(lrn2014a) <- tolower(names(lrn2014a))

# Define questions that became part of the averaged variables.
# (This is straight from the following DataCamp exercise:
# https://campus.datacamp.com/courses/helsinki-open-data-science/regression-and-model-validation?ex=3)
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D07","D14","D22","D30")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# Add averaged variables to the data frame.
lrn2014a$deep <- rowMeans(select(lrn2014, one_of(deep_questions)))
lrn2014a$stra <- rowMeans(select(lrn2014, one_of(surface_questions)))
lrn2014a$surf <- rowMeans(select(lrn2014, one_of(strategic_questions)))

# Write the output to a file
write.table(lrn2014a, file = "learning2014.csv", sep = "\t", col.names = TRUE)

# Clear memory, read the file back in and show its structure just for
# the sake of demonstration.
rm(list = ls()) # Note that the preset working directory is still preserved.
lrn2014a <- as.data.frame(read.table('learning2014.csv',  sep="\t", header=TRUE))
str(lrn2014a) # Show the structure.
head(lrn2014a, n = 10) # Show the first ten rows of the newly created DF.

