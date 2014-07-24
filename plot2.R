require(dplyr)

##  Uncomment the following line if NEI and SSC are not already in the global
##  environment:
##  source("read_files.R")

##  Filter NEI data to get emissions for Baltimore City, MD, 
##  then group data by year and then calculate the sum of all
##  emissions for each year.

NEI_Baltimore <- summarize(group_by(filter(NEI, fips == "24510"), year),
    total_emissions = sum(Emissions))

##  Create line plot.

png("plot2.png", width = 480, height = 480)
with(NEI_Baltimore, plot(year, total_emissions,
    pch = 19,
    xaxp  = c(1999, 2008, 3),
    main = expression('Total emissions from PM'[2.5]*' in Baltimore City, MD'),
    xlab = "Year",
    ylab = "Total emissions"))
with(NEI_Baltimore, lines(year, total_emissions))
dev.off()