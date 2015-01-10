## Script for the first plot of the first project ##

# Set your working directory to the one where your script will be executed 
# If the data is not there, the script will download the file

# Load necessary packages (data.table)
require(data.table)

# Check if the file is in the working directory
# If the file is not there, it will be downloaded and extracted to the wd
if (file.exists("household_power_consumption.txt") == FALSE) {
        download.file(
        "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",
        destfile = "temp.zip", method = "curl")
        unzip("temp.zip")
        # deletes the temporary zipped file
        unlink("temp.zip")
}

# Read data file (only the two necessary days) thanks to the forums for this nice solution
dtime <- difftime(as.POSIXct("2007-02-03"), as.POSIXct("2007-02-01"),units="mins")
rowsToRead <- as.numeric(dtime)
# Reads the data (starting at 1/2/2007 and just the number of rows specified)
data <- fread("household_power_consumption.txt", skip="1/2/2007", nrows = rowsToRead, na.strings = c("?", ""))
# Removes the unnecessary variables from the environment
rm(rowsToRead, dtime)
# Add the names back to the columns, nrows=0 just return column names and types
setnames(data, colnames(fread("household_power_consumption.txt", nrows=0)))

# Open png device
png(filename = "plot1.png",
    width = 480, height = 480, units = "px", bg = "transparent")

# Creates the histogram (plot 1) of the Global active power with formatting
hist(data$Global_active_power, 
     main = "Global Active Power", 
     xlab = "Global Active Power (kilowatts)", 
     col = "red")

# Close device
dev.off()