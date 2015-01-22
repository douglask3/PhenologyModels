##########################################################################################
## cfg                                                                                  ##
##########################################################################################
source("cfg.r")
source("springDynamics.r")


##########################################################################################
## Set up parameters                                                                    ##
##########################################################################################
## For plot
graphics.off()
cols=c("green","brown","yellow","blue","cyan","cyan",'cyan')
ltys=c(1,1,1,1,2,3,4)

## Data
source("find_Fe_function.R")

ecdata$Fe=predict(res.sig,list(SWC10=ecdata$SWC10))

fyear = ecdata$Year + (ecdata$Month-1)/12 +ecdata$Day/365

##########################################################################################
## Open Figure and plot data                                                            ##
##########################################################################################
pdf("figs/PhenologyFit.pdf",height=18,width=18)


plot(range(fyear),c(0,0.5),type='n',xlab='',ylab='')
mtext(side=1,'Year')
mtext(side=2,'NDVI')
mtext(side=3,'Soil Water Content (%)')

addLine <- function(...) lines(fyear,...)

addLine(ecdata$NDVI250X,col='green')
addLine(ecdata$SWC10,col='dark blue')
addLine(ecdata$Fe,col='red')
addLine(ecdata$Fe,col='red')

###########################################################################################
## Fit and plot                                                                          ##
###########################################################################################
fit=nls(NDVI250X ~ springDynamics(Fe,r,d,initial=ecdata$NDVI250X[1]),start=list(r=1,d=1),data=ecdata)

addLine(predict(fit),col='dark green')

dev.off()
