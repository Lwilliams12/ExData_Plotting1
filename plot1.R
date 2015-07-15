downloaddata <- function(){
        # setup download of the file from UCI
        fileurl <- paste("http://d396qusza40orc.cloudfront.net/",
                          "exdata%2Fdata%2Fhousehold_power_consumption.zip",
                          sep="")
        fileloc <- paste("c:\\Users\\AsusCuda\\Downloads\\Coursera\\",
                         "Exploratory Data ",
                         "Analysis\\exdata-data-household_power_consumption",
                         "\\household_power_consumption.zip",sep="")
        # download it if it doesn't exist, otherwise skip this step
        if(!file.exists(fileloc)){
                download.file(fileurl, destfile = fileloc, method = "curl")
                dateDownloaded <- date()
        }
        
        # read the zipped file-first step is to let R figure colClasses
        #   Only do this once.
        if(!file.exists("datsub.RData")){
                fileunz <- "household_power_consumption.txt"
                t5rows <- read.table(unz(fileloc,fileunz), header = TRUE, sep=";",nrows=5)
                classes <- sapply(t5rows, class)
                # Date and Time are converted to Factors, we need them to be chars
                # so we can use POSIXct to convert them to Date/Time objects
                classes[1:2] <- "character"
                dat <- read.table(unz(fileloc,fileunz),header=TRUE,sep=";", 
                                  colClasses=classes,na.strings="?",
                                  stringsAsFactors = FALSE, nrows=2075259)
                # combine Date and Time into single R Date/Time object
                dat$Date <- as.POSIXct(paste(dat$Date, dat$Time), format =
                                               "%d/%m/%Y %H:%M:%S")
                # remove the superfluous Time column
                dat$Time <- NULL
                
                # subset rows to desired set
                datsub <- subset(dat,dat$Date >= "2007/02/01" & dat$Date < "2007/02/03")
                
                # save datsub so we only have to do the work once
                save(datsub, file = "datsub.RData")
        }
        else
                load("datsub.RData")
        
        # plot 1
        png(file="plot1.png",height=480,width=480)
        hist(datsub$Global_active_power,main="Global Active Power",
             xlab="Global Active Power (kilowatts)", ylab="Frequency",col="red")
        dev.off()
        
        # plot 2
        png(file="plot2.png",height=480,width=480)
        plot(datsub$Date,datsub$Global_active_power,main="",
             ylab="gloabal Active Power (kilowatts)", xlab="",
             pch="",lines(datsub$Date,
                          datsub$Global_active_power))
        dev.off()

        # plot 3
        png(file="plot3.png",height=480,width=480)
        date1 <- datsub$Date
        sm1 <- datsub$Sub_metering_1
        sm2 <- datsub$Sub_metering_2
        sm3 <- datsub$Sub_metering_3
        plot(date1,sm1,xlab="",ylab="Energy sub metering",
             pch="", type="n")
        lines(date1,sm1, col = "black")
        lines(date1,sm2, col = "red")
        lines(date1,sm3, col = "blue")
        legend("topright",lty=c(1,1,1),col=c("black","red","blue"),
                legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
        dev.off()
        
        # plot 4
        png(file="plot4.png",height=480,width=480)
        par(mfrow= c(2,2))
        svolt <- datsub$Voltage
        sactp <- datsub$Global_active_power
        sracp <- datsub$Global_reactive_power
        
        plot(date1,sactp,main="",pch="",xlab="",ylab="Global Active Power")
        lines(date1,sactp,col="black")
        
        plot(date1,svolt,main="",pch="",xlab="",ylab="Voltage")
        lines(date1,svolt,col="black")
        
        plot(date1,sm1,main="",pch="",xlab="",ylab="Energy sub metering")
        lines(date1,sm1,col="black")
        lines(date1,sm2,col="red")
        lines(date1,sm3,col="blue")
        legend("topright", lty=c(1,1,1),col=c("black","red","blue"),bty="n",
               legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"))
        
        plot(date1,sracp,main="",pch="",xlab="datetime",ylab="Global_reactive_power")
        lines(date1,sracp,col="black")
        dev.off()
}

