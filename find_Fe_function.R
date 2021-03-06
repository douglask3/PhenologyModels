#!/usr/bin/env Rscript

# Where to save the output PDF for the preliminary fitting
FeoutFile <- "outputs/Fe_k_Table.csv"
outPlot <- "figs/Fe_from_NDVI_and_SWC.pdf"

# Analysis parameters
swcRollingMean <- 30
swcAllowedGrad <- 1E-3

# Import our trimmed-down Sturt Plains dataset
source("prepare_data.R")
names(ecdata) <- c("Day","Month","Year","SWC10","NDVI250X")
ecdata$NDVI250X = ecdata$NDVI250X-min(ecdata$NDVI250X)+0.001

swc  = rollmean(ecdata$SWC10,swcRollingMean)
ndvi = ecdata$NDVI250X[1:length(swc)]


# Fine turning points
tps      = (turnpoints(ndvi))
tpsType  = turnpointsType(tps)
tpsSwc   = swc[tps$tppos]

tpsDswc  = lapply(tps[[10]],function(i) swc[(i-7):(i+1)])
tpsDswc  = sapply(tpsDswc,function(i) {
                  x <- 1:length(i)
                  lm(i~x)[[1]][2]
})

swStable = (tpsType==1 & tpsDswc>=-swcAllowedGrad) | (tpsType==0 & tpsDswc<=swcAllowedGrad)
tps=tps$tppos[swStable]

#================================================================================
# Fit data with a set of models
#================================================================================

# Need to find soil water content values for min and max NDVI for each year
force.env <-ecdata[tps,c('SWC10','NDVI250X')]

# Set global X & Y variables (I know...)
yndvi   <- ndvi[tps]
xswc    <- swc[tps]

# Function to explain the relationship between Min/Max SWC and NDVI
fenv <- function( swc, k, linear=T ) {
    if( linear==T ) {
        return(k*swc)
    } else {
        return(swc/(swc+k))
    }
}

nlsFun <- function(form,nlsFun=nls,...) nlsFun(form, data=force.env,...)
# Linear
res.lin <- nlsFun( NDVI250X~k*SWC10, start=list(k=1) )
# Nonlinear (asymptote - NDVI can be negative)
res.nol <- nlsFun( NDVI250X~SWC10/(k+SWC10), start=list(k=1) )
# Nonlinear (sigmoid - NDVI must be positive)
res.sig <- nlsFun( NDVI250X~1/(1+exp(k*SWC10-s)), start=list(s=0,k=-1) )
res.exp <- nlsFun( NDVI250X~b*exp(k*SWC10)-s, start=list(b=1,s=1,k=1 ),control=list(minFactor=1E-5,maxiter=1000))

#================================================================================
# Results
#================================================================================

get.par <- function(object) summary(object)[10][[1]][1]
par.out <- data.frame( Models=c("Linear","Nonlinear","Sigmoid","Exp"), k=sapply( list(res.lin, res.nol, res.sig,res.exp), get.par) )
write.table( par.out, file=FeoutFile, row.names=F, sep="," )

# Plot the data
pdf(file=outPlot, width=4.5, height=4)

    par( mar=c(4,4,1,1) )
    plot( xswc, yndvi, pch=19, col="black", xlab="", ylab="", las=1, ylim=c(0,0.7), xlim=c(0,0.3) )
    
    # calc model
    xmod <- seq(-0.1, 0.4, 0.01)
    # plot model
    lines( xmod, predict(res.lin, list(SWC10=xmod)), col='red'   , lwd=3 )
    lines( xmod, predict(res.nol, list(SWC10=xmod)), col='orange', lwd=3 )
    lines( xmod, predict(res.sig, list(SWC10=xmod)), col='purple', lwd=3 )
    lines( xmod, predict(res.exp, list(SWC10=xmod)), col='blue'  , lwd=3 )
    # labels
    mtext( expression(theta[soil]), side=1, line=2.5, cex=1.2 )
    mtext( expression(NDVI), side=2, line=2.7, cex=1. )
    # legend
    legend( "bottomright", 
           c(expression(k*theta[s]), 
             expression(theta[s]/(k+theta[s])),
             expression(1/(1+exp(-k*theta[s]-n))),
             expression(exp(-k*theta[s]))
             ),
           col=c("red","orange","purple",'blue'), lwd=3, pch=-1, cex=0.8 )
dev.off()
