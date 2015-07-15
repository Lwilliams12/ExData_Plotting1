readdata <- function(){
        # first download the file from UCI
        fileurl <- paste("http://d396qusza40orc.cloudfront.net/",
                          "exdata%2Fdata%2Fhousehold_power_consumption.zip",
                          sep="")
        fileloc <- paste("c:\\Users\\AsusCuda\\Downloads\\Coursera\\",
                         "Exploratory Data ",
                         "Analysis\\exdata-data-household_power_consumption",
                         "\\household_power_consumption.zip",sep="")
        download.file(fileurl, destfile = fileloc, method = "curl")
        
        # now read the file
        # cat(fileurl,"\n")
        # cat(fileloc,"\n")
        "success"
        
}