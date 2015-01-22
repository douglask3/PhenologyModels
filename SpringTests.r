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
ecdata$Fe[ecdata$Fe>1]=1

fyear = ecdata$Year + (ecdata$Month-1)/12 +ecdata$Day/365

##########################################################################################
## Fit                                                    		                        ##
##########################################################################################
fit=nls(NDVI250X ~ springDynamics(Fe,r,d,initial=ecdata$NDVI250X[1]),start=list(r=1,d=1),data=ecdata)
ecdata$NDVISim=predict(fit)

##########################################################################################
## Open Figure and plot data                                                            ##
##########################################################################################
pdf("figs/PhenologyFit.pdf",height=9,width=9)
layout(matrix(2:1,nrow=2))
addLine <- function(colname,col,...) lines(fyear,ecdata[,colname],col=col,...)
plotStandard <- function(colnames,cols,xlab="",...) {
    plot(range(fyear),c(0,max(ecdata[,colnames])),type='n',xlab=xlab,...)
    mapply(addLine,colnames,col=cols)
    legend('top',colnames,lty=1,horiz=TRUE,col=cols,bty='n')
}


plotStandard(c('SWC10','Fe'),cols=c('dark blue','cyan'),ylab='moisture')
plotStandard(c('NDVI250X','NDVISim'),cols=c('dark green','green'),ylab='NDVI')




dev.off()
