#!/usr/bin/env Rscript
source("cfg.r")
outFile <- 'outputs/ecDaily.csv'

if (file.exists(outFile)) read.csv(outFile) else {

    ecdata <- sqldf::read.csv.sql(file=SturtPlainsFile,
           sql="SELECT * FROM file",
           header=T, row.names=NULL, 
           filter = list('gawk -f prog', prog = '{ gsub(/"/, ""); print }'))

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

    ecdata_daily <- aggregate( cbind(Sws_Con,X250m_16_days_NDVI_new_smooth)~Day+Month+Year, data=ecdata, mean)

    write.csv(ecdata_daily, outFile, row.names=F)
}

plot( ecdata[,184], type='l', col='red' )
