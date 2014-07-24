require(dplyr)
require(ggplot2)

##  Uncomment the following line if NEI and SSC are not already in the global
##  environment:
##  source("read_files.R")

##  Filter NEI data to get emissions for Baltimore City, MD, 
##  then group data by year and then calculate the sum of all
##  emissions for each year.

NEI_Baltimore_type <- summarize(regroup(filter(NEI, fips == "24510"),
    list("year","type")), total_emissions = sum(Emissions))

##  Create grouped line plot.

png("plot3.png", width = 480, height = 480)
plot3 <- qplot(year, total_emissions, data = NEI_Baltimore_type, color = type) +
    geom_path() +
    geom_point() + 
    scale_x_continuous(breaks = seq(1999, 2008, 3),
        minor_breaks = seq(1999, 2008, 1)) +
    ggtitle(expression('Total emissions from PM'[2.5]*' in Baltimore City, MD')) +
    xlab("Year") +
    ylab("Total emissions")
print(plot3)
dev.off()