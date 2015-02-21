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

## Agregate emiisions per year for baltimore i.e. fips 24510
NEI.BALT <- NEI[which(NEI$fips == "24510"), ]
emissions.baltimore <- aggregate(Emissions ~ year, NEI.BALT,sum)
colnames(emissions.baltimore) <- c("Year", "TotalEm")

## plot the data using ggplot
png(filename = "plot3.png", width = 960, height = 960, units = "px")
baltimoreplot <- ggplot(NEI.BALT,aes(factor(year),Emissions,fill=type)) + geom_bar(stat="identity") + 
        theme_bw() + guides(fill=FALSE)+ facet_grid(.~type,scales = "free",space="free") + 
        labs(x="Year", y=expression("Emissions (Tons)")) + 
        labs(title=expression("Total Annual PM2.5 Emissions (1999-2008) Baltimore by Source Type"))

print(baltimoreplot)
dev.off()