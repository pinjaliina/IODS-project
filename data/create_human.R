# R Script for the University of Helsinki course Introduction to Open Data Science
# RStudio Exercise 4/5 (script part of exercise 4, data used in exercise 5).
# 
# Author: Pinja-Liina Jalkanen
# Created: Mon 13 Feb, 2017
#
# Source data: United Nations Human Development Report 2015:
# Human Development Index (HDI; http://hdr.undp.org/en/composite/HDI)
# and Gender Inequality Index (GII; http://hdr.undp.org/en/composite/GII)

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

# Read in the data.
hd <- as.data.frame(read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F))
gii <- as.data.frame(read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = ".."))

# Explore structure and dimensions of the data frames with glimpse().
glimpse(hd)
glimpse(gii)

# Summarise the variables.
summary(hd)
summary(gii)

# Shorten column names. There are several methods for this. For details, see:
# http://www.cookbook-r.com/Manipulating_data/Renaming_columns_in_a_data_frame/
names(hd)[1] <- 'hdi_r'
names(hd)[2] <- 'country'
names(hd)[3] <- 'hdi'
names(hd)[4] <- 'life_exp'
names(hd)[5] <- 'edu_exp'
names(hd)[6] <- 'edu_mean'
names(hd)[7] <- 'gni_cap'
names(hd)[8] <- 'gni_r_sub_hdi_r'
names(gii)[1] <- 'gii_r'
names(gii)[2] <- 'country'
names(gii)[3] <- 'gii'
names(gii)[4] <- 'mmr'
names(gii)[5] <- 'abr'
names(gii)[6] <- 'mp_share'
names(gii)[7] <- 'se_f'
names(gii)[8] <- 'se_m'
names(gii)[9] <- 'lfp_f'
names(gii)[10] <- 'lfp_m'

# Extend the GII DF with some new variables.
gii <- mutate(gii, se_f_of_m = se_f/se_m)
gii <- mutate(gii, lfp_f_of_m = lfp_f/lfp_m)

# Join the datasets.
human <- inner_join(hd, gii, by = 'country')

# Write the joined DF to a file.
write.table(human, file = "human.csv", sep = "\t", col.names = TRUE)