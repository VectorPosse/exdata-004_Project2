require(dplyr)

##  Uncomment the following line if NEI and SSC are not already in the global
##  environment:
##  source("read_files.R")

##  Group NEI data by year and then calculate the sum of all
##  emissions for each year.

NEI_by_year <- summarize(group_by(NEI, year), total_emissions = sum(Emissions))

##  Create line plot.

png("plot1.png", width = 480, height = 480)
with(NEI_by_year, plot(year, total_emissions,
    pch = 19,
    xaxp  = c(1999, 2008, 3),
    main = expression('Total emissions from PM'[2.5]),
    xlab = "Year",
    ylab = "Total emissions"))
with(NEI_by_year, lines(year, total_emissions))
dev.off()