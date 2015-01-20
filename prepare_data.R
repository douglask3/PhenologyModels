#!/usr/bin/env Rscript
source("cfg.r")
outFile <- 'outputs/ecDaily.csv'

if( file.exists(outFile) ) {
    
    cat("\n==> File already exists:\nCheck the outputs/ folder\n\n")

} else {
    # import using SQL
    testFast <- try(
        ecdata <- sqldf::read.csv.sql(file=SturtPlainsFile,
        sql="SELECT * FROM file",
        header=T, row.names=NULL, 
        filter = list('gawk -f prog', prog = '{ gsub(/"/, ""); print }'))
    )
    # if fails then import using slower base read
    if (class(testFast)=="try-error")
        ecdata <- read.csv(file=SturtPlainsFile,header=T, row.names=NULL)
    # print headers on the file
    for( i in 1:length(names(ecdata))){
	    ecn <- names(ecdata)
    	print( paste(i,": ", ecn[i], sep=" ") )
    }
    # string acrobatics to pull out date and time components
    datetime    <- stringr::str_split( ecdata$DT, " " )
    date        <- stringr::str_split( sapply( datetime, '[', 1 ), "-" )
    time        <- stringr::str_split( sapply( datetime, '[', 2 ), ":" )

    # reapply time columns
    get.tindex  <- function( x, i ) as.numeric( sapply( x, '[', i) )
    ecdata$Year     <- get.tindex(date,1)
    ecdata$Month    <- get.tindex(date,2)
    ecdata$Day      <- get.tindex(date,3)
    ecdata$Hour     <- get.tindex(time,1)
    ecdata$Minute   <- get.tindex(time,2)
    ecdata$Second   <- get.tindex(time,3)

    # convert data from hourly timesetp to daily timestep
    ecdata_daily <- aggregate( cbind(Sws_Con,X250m_16_days_NDVI_new_smooth)~Day+Month+Year, data=ecdata, mean)
    names(ecdata_daily) <- c("Day","Month","Year","SWC10","NDVI250X")

    # write to file
    write.csv(ecdata_daily, outFile, row.names=F)
}
