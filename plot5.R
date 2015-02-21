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

## Agregate emiisions per year for motor vehicle emission information
emissions.mvbaltimore <- NEI.DT[NEI$type=="ON-ROAD", sum(Emissions), by = c("year", "fips")][fips == "24510"]
colnames(emissions.mvbaltimore) <- c("year", "fips", "Emissions")

## plot the data using ggplot
png(filename = "plot5.png", width = 480, height = 480, units = "px")
motorvplot <- ggplot(emissions.mvbaltimore, aes(year, Emissions)) + geom_point(color = "blue") + geom_line(color = "dark red") +
        labs(x="Year") + labs(y=expression("Emissions (Tons)")) + 
        labs(title=expression("Total Annual PM2.5 Motor-Vehicle Emissions (1999-2008) BC"))
print(motorvplot)
dev.off()