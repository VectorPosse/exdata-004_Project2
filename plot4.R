require(dplyr)
require(ggplot2)

##  Uncomment the following line if NEI and SSC are not already in the global
##  environment:
##  source("read_files.R")

##  We need to filter NEI data to get emissions from sources that
##  involve any type of coal combustion.
##  These sources are found by looking in SCC$Short.Name for the words "coal"
##  and "comb". (Both words need to be present; there are many sources
##  that involve coal in some other way.)

SCC_coal_comb <- SCC[grep("coal.*comb|comb.*coal",
    SCC$Short.Name, ignore.case = TRUE), ]

##  Filter NEI by the codes in the SCC variable of the data frame 
##  from the previous step. Then group data by year and calculate 
##  the sum of all emissions for each year.

NEI_coal_comb <- summarize(group_by(filter(NEI, SCC %in% SCC_coal_comb$SCC),
    year), total_emissions = sum(Emissions))

##  Create line plot.

png("plot4.png", width = 480, height = 480)
plot4 <- qplot(year, total_emissions, data = NEI_coal_comb) +
    geom_path() +
    geom_point() + 
    scale_x_continuous(breaks = seq(1999, 2008, 3),
        minor_breaks = seq(1999, 2008, 1)) +
    ggtitle(expression('Total emissions from PM'[2.5]*' from coal combustion')) +
    xlab("Year") +
    ylab("Total emissions")
print(plot4)
dev.off()