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
##  from the previous step, and for Baltimore City, MD, and Los Angeles, CA.
##  Then group data by year and calculate the sum of all emissions for each year.

NEI_motor_vehicles2 <- summarize(regroup(filter(
    NEI, (SCC %in% SCC_motor_vehicles$SCC & (fips == "24510" | fips == "06037"))),
    list("year", "fips")), total_emissions = sum(Emissions))

## Next we compute a new variable that represents total emissions as a 
## percentage of the level in 1999.

emissions_1999 <- NEI_motor_vehicles2[
    NEI_motor_vehicles2$year == 1999, "total_emissions"]

NEI_motor_vehicles2 <- mutate(NEI_motor_vehicles2,
    init_value = emissions_1999,
    percent_change = 100* total_emissions / init_value - 100 )


##  Create grouped line plots.

source("multiplot.R")

png("plot6.png", width = 480, height = 480)
plot6_1 <- qplot(year, total_emissions, data = NEI_motor_vehicles2, color = fips ) +
    geom_path() +
    geom_point() + 
    scale_x_continuous(breaks = seq(1999, 2008, 3),
        minor_breaks = seq(1999, 2008, 1)) +
    ggtitle(expression('Total emissions from PM'[2.5]*' from motor vehicles')) +
    scale_color_discrete(name  ="City",
        breaks=c("06037", "24510"),
        labels=c("Los Angeles, CA", "Baltimore, MD")) +
    xlab("Year") +
    ylab("Total emissions")
plot6_2 <- qplot(year, percent_change, data = NEI_motor_vehicles2, color = fips ) +
    geom_path() +
    geom_point() + 
    scale_x_continuous(breaks = seq(1999, 2008, 3),
        minor_breaks = seq(1999, 2008, 1)) +
    ggtitle(expression('PM'[2.5]*' from motor vehicles: percent change from 1999')) +
    scale_color_discrete(name  ="City",
        breaks=c("06037", "24510"),
        labels=c("Los Angeles, CA", "Baltimore, MD")) +
    xlab("Year") +
    ylab("% change from 1999")
plot6 <- multiplot(plot6_1, plot6_2)
print(plot6)
dev.off()