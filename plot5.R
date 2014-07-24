require(dplyr)
require(ggplot2)

##  Uncomment the following line if NEI and SSC are not already in the global
##  environment:
##  source("read_files.R")

##  We need to filter NEI data to get emissions from motor vehicle sources.
##  These sources are found by looking in SCC$Short.Name for the words "motor"
##  or "vehicle". (This seems to work better than searching for
##  "motor vehicle"--or "motor"/"vehicle" individually--since we want things
##  like "Light Duty Vehicles" and "Motorcycles" which both count
##  as motor vehicles.)

SCC_motor_vehicles <- SCC[grep("motor|vehicles",
    SCC$Short.Name, ignore.case = TRUE), ]

##  Filter NEI by the codes in the SCC variable of the data frame 
##  from the previous step, and for Baltimore City, MD. Then group 
##  data by year and calculate the sum of all emissions for each year.

NEI_motor_vehicles <- summarize(group_by(filter(
    NEI, (SCC %in% SCC_motor_vehicles$SCC & fips == "24510")),
    year), total_emissions = sum(Emissions))

##  Create line plot.

png("plot5.png", width = 480, height = 480)
plot5 <- qplot(year, total_emissions, data = NEI_motor_vehicles) +
    geom_path() +
    geom_point() + 
    scale_x_continuous(breaks = seq(1999, 2008, 3),
        minor_breaks = seq(1999, 2008, 1)) +
    ggtitle(expression('Total emissions from PM'[2.5]*
        ' from motor vehicles in Baltimore City, MD')) +
    xlab("Year") +
    ylab("Total emissions")
print(plot5)
dev.off()