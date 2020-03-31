### Exploratory Data Analysis  - Course Project 1
## Analysis: Plot 1 - Global Active Power
## Author: Luccas Betton
## Date: 01/04/2020

## Libraries necessary for Script Running
library(sqldf)
library(dplyr)
## Data Download
directory <- "./Electric_Power_data"
zipname <- "Data_EletricPower.zip"
filename <- "./Electric_Power_data/household_power_consumption.txt"

if(!file.exists(filename)){
    
    if(!file.exists(zipname)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(fileURL, destfile = zipname, method = "curl")
    }
    
    if(!dir.exists(directory)) dir.create(directory)
    unzip(zipname, exdir = directory)
}

## Data Importation
Power_Data <- read.csv.sql(filename,header = TRUE,sep = ";", sql = "Select * from file WHERE Date = '1/2/2007' OR Date = '2/2/2007'") #Extract only dates 2007-02-01 and 2007-02-02 in the variable Power_Data

## Convert Date and Time Columns 
Power_Data <- mutate(Power_Data,CompDate = paste(Date,Time)) # Merge Date and Time
Power_Data$CompDate <- strptime(Power_Data$CompDate,format = "%d/%m/%Y %T") # Transform date and time in for Date-Time Variable

## Create PNG - Plot 4

png(file = "Plot4.png") #Create file
par(mfrow = c(2, 2)) #Devide plot for 4 graphs (2 rows and, 2 columns)

#Plot 1 - 1
with(Power_Data,plot(CompDate,Global_active_power,xlab = "", type = "l",ylab = "Global Active Power"))

#Plot 1 - 2
with(Power_Data,plot(CompDate,Voltage,xlab = "", type = "l",ylab = "Voltage")) 

#Plot 2 - 1
with(Power_Data,plot(CompDate,Sub_metering_1,xlab = "", type = "l",ylab = "Energy Sub Metering")) # Plot Serie 1
with(Power_Data,lines(CompDate,Sub_metering_2,col = "red")) #Plot Serie 2
with(Power_Data,lines(CompDate,Sub_metering_3,col = "blue")) #Plot Serie 3
legend("topright",legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty = 1, col = c("black","red","blue"), bty = "n")

#Plot 2 - 2
with(Power_Data,plot(CompDate,Global_reactive_power,xlab = "", type = "l",ylab = "Global Reactive Power")) 

dev.off() #Close Png file device
