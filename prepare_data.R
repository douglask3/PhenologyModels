#!/usr/bin/env Rscript
source("cfg.r")
outFile <- 'outputs/ecDaily.csv'

if (file.exists(outFile)) ecdata <- read.csv( file="outputs/ecDaily.csv", header=T, sep="," ) else {

    testFast=try(ecdata <- sqldf::read.csv.sql(file=SturtPlainsFile,
           sql="SELECT * FROM file",
           header=T, row.names=NULL, 
           filter = list('gawk -f prog', prog = '{ gsub(/"/, ""); print }')))
    
    if (class(testFast)=="try-error")
        ecdata <- read.csv(file=SturtPlainsFile,header=T, row.names=NULL)

    for( i in 1:length(names(ecdata))){
	    ecn <- names(ecdata)
    	print( paste(i,": ", ecn[i], sep=" ") )
    }

    datetime <- stringr::str_split( ecdata$DT, " " )
    date <- stringr::str_split( sapply( datetime, '[', 1 ), "-" )
    time <- stringr::str_split( sapply( datetime, '[', 2 ), ":" )

    # reapply time columns
    get.tindex <- function( x, i ) as.numeric( sapply( x, '[', i) )
    ecdata$Year <- get.tindex(date,1)
    ecdata$Month <- get.tindex(date,2)
    ecdata$Day <- get.tindex(date,3)

    ecdata$Hour <- get.tindex(time,1)
    ecdata$Minute <- get.tindex(time,2)
    ecdata$Second <- get.tindex(time,3)

    ecdata <- aggregate( cbind(Sws_Con,X250m_16_days_NDVI_new_smooth)~Day+Month+Year, data=ecdata, mean)

    write.csv(ecdata, outFile, row.names=F)
}


