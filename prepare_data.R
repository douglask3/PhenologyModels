#!/usr/bin/env Rscript

# set wd
setwd("~/Work/Research_Work/Savanna_Project/Data/ADVANCED RESULTS/")

ecdata  <- sqldf::read.csv.sql(file="SturtPlains/Advanced_processed_data_SturtPlains_v11b.csv", 
           sql="SELECT * FROM file",
           header=T, row.names=NULL, 
           filter = list('gawk -f prog', prog = '{ gsub(/"/, ""); print }'))

for( i in 1:length(names(ecdata))){
    ecn <- names(ecdata)
    print( paste(i,": ", ecn[i], sep=" ") )
}

isplitstr <- function(x,f,...) t(sapply(x,function(i,...) strsplit(i,...)[[1]],f,...))
datetime <- isplitstr( ecdata$DT, " " )
date <- isplitstr( datetime[,1], "-" )
time <- isplitstr( datetime[,2], ":" )

# reapply time columns
ecdata$Year <- as.numeric(date[,1])
ecdata$Month <- as.numeric(date[,2])
ecdata$Day <- as.numeric(date[,3])

ecdata$Hour <- as.numeric(time[,1])
ecdata$Minute <- as.numeric(time[,2])
ecdata$Second <- as.numeric(time[,3])

ecdata_daily <- aggregate( cbind(Sws_Con,X250m_16_days_NDVI_new_smooth)~Day+Month+Year, data=ecdata, mean)

plot( ecdata[,184], type='l', col='red' )
