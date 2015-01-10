## Script for the second plot of the first project ##

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
png(filename = "plot2.png",
    width = 480, height = 480, units = "px", bg = "transparent")

# Formats the time and date columns and mutates the data file creating
# a new DateTime column with the date and the time
data$DateTime <- as.POSIXct(paste(data$Date, data$Time), 
                            format = "%d/%m/%Y %H:%M:%S") 

# Creates the line scatter plot (plot 2) of the Global active power 
# with formatting
plot(data$DateTime, data$Global_active_power, 
     type = "l", xlab = "", ylab = "Global Active Power (kilowatts)")

# Close device
dev.off()