# R Script for the University of Helsinki course Introduction to Open Data Science
# RStudio Exercise 4/5 (script part of both exercises, data used in Exercise 5).
# 
# Author: Pinja-Liina Jalkanen
# Created: Mon 13 Feb, 2017. Exercise 5 related parts added Sat 18 Feb, 2017.
# 
# For the Exercise 4 only version of this script, see the following commit:
# https://github.com/pinjaliina/IODS-project/commit/2f278015e26db5d96819ff8590486159f812d0ed
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
library(stringr)

# Reset graphical parameters and save the defaults.
plot.new()
.pardefault <- par(no.readonly = TRUE)
dev.off()

####################################
## Data wranging part, exercise 4 ##
####################################

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

# File above was overwritten by the subsequent Exercise 5 commit. For
# the old version, see the following commit:
# https://github.com/pinjaliina/IODS-project/commit/2f278015e26db5d96819ff8590486159f812d0ed

####################################
## Data wranging part, exercise 5 ##
####################################

# Mutate gni_cap so that it's actually numeric.
human <- mutate(human, gni_cap = as.numeric(str_replace(human$gni_cap, pattern=",", replace ="")))

# Exclude variables that aren't needed.
human <- select(human, one_of('country','se_f_of_m','lfp_f_of_m','edu_exp','life_exp','gni_cap','mmr','abr','mp_share'))

# Filter out incomplete records.
human <- na.omit(human)

# The last seven observations aren't countries. Remove them.
human <- head(human, -7)

# Define countries as rownames and remove the country field from the DF.
rownames(human) <- human$country
human <- human[,-1]

# Overwrite the data that was written in the end of Exercise 4.
write.table(human, file = "human.csv", sep = "\t", col.names = TRUE)