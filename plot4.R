## Script for the fourth plot of the first project ##

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
png(filename = "plot4.png",
    width = 480, height = 480, units = "px", bg = "transparent")

# Formats the time and date columns and mutates the data file creating
# a new DateTime column with the date and the time
data$DateTime <- as.POSIXct(paste(data$Date, data$Time), 
                            format = "%d/%m/%Y %H:%M:%S") 

# Creates the four plots, changing the mfrow paremeter
par(mfrow = c(2, 2))

# First plot (Global active power)
plot(data$DateTime, data$Global_active_power, 
     type = "l", xlab = "", ylab = "Global Active Power")

# Second plot (Voltage)
plot(data$DateTime, data$Voltage, 
     type = "l", xlab = "datetime", ylab = "Voltage")

# Third plot (sub meterings)
# First variable
plot(data$DateTime, data$Sub_metering_1, 
     type = "l", xlab = "", ylab = "Energy sub metering")
# Second variable
lines(data$DateTime, data$Sub_metering_2, type = "l", col = "red")
# Third variable
lines(data$DateTime, data$Sub_metering_3, type = "l", col = "blue")
# Legend
legend("topright", col = c("black", "blue", "red"), 
       legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), 
       lwd = 1, bty = "n")

# Fourth plot (Global Reactive Power)
plot(data$DateTime, data$Global_reactive_power, 
     type = "l", xlab = "datetime", ylab = "Global_reactive_power")

# Close device
dev.off()