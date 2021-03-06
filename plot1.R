## Load Libraries
library(plyr)
library(ggplot2)
library(data.table)

## Read in the data:
## PM2.5 Emissions Data (summarySCC_PM25.rds): This file contains a data frame with all of the PM2.5 
## emissions data for 1999, 2002, 2005, and 2008. For each year, the table contains number of tons of PM2.5 
## emitted from a specific type of source for the entire year.
## Source Classification Code Table (Source_Classification_Code.rds): This table provides a mapping from 
## the SCC digit strings in the Emissions table to the actual name of the PM2.5 source. The sources are 
## categorized in a few different ways from more general to more specific.
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Convert data to data tables
NEI.DT = data.table(NEI)
SCC.DT = data.table(SCC)

## Agregate emiisions per year
total.emissions <- with(NEI, aggregate(Emissions/10^6, by = list(year), sum))
names(total.emissions) <- c('Year', 'TotalEm')

## plot the data
png(filename = "plot1.png", width = 480, height = 480, units = "px")
plot(total.emissions, type = "b", pch = 18, col = "dark red", ylab = "Emissions (10^6 Tons)", 
     xlab = "Year", main = "Total Annual PM2.5 Emissions (1999-2008) All Sources")
dev.off()

