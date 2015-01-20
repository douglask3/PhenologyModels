#!/usr/bin/env Rscript

# Where to save the output PDF for the preliminary fitting
FeoutFile <- "outputs/Fe_k_Table.csv"
outPlot <- "figs/Fe_from_NDVI_and_SWC.pdf"

# Analysis parameters
swcRollingMean <- 30

# Import our trimmed-down Sturt Plains dataset
source("prepare_data.R")
names(ecdata) <- c("Day","Month","Year","SWC10","NDVI250X")

swc  = rollmean(ecdata$SWC10,swcRollingMean)
ndvi = ecdata$NDVI250X[1:length(swc)]


# Fine turning points
tps      = (turnpoints(ndvi))
tpsType  = turnpointsType(tps)
tpsSwc   = swc[tps$tppos]
tpsDswc  = apply(rbind(swc[tps$tppos+1],swc[tps$tppos-1]),2,diff)

swStable = (tpsType==1 & dswc>=0) | (tpsType==0 & dswc<=0)


tps=tps$tppos[swStable]


# There's probably a better way to extract these points


ndvi.raw    <- aggregate( NDVI250X~Year, ecdata, range )
ndvi.range  <- as.data.frame(cbind(ndvi.raw[,1],ndvi.raw[,2]))
names(ndvi.range) <- c("Year","Min","Max")

# Need to find soil water content values for min and max NDVI for each year
force.env <- subset( ecdata, (NDVI250X%in%ndvi.range$Min | NDVI250X%in%ndvi.range$Max) & NDVI250X>0, 
                   select=c(SWC10,NDVI250X) )

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



#================================================================================
# Linear
#================================================================================

# Cost function for determining global minimum (assuming IID ~ sigma=1)
fmin.lin <- function( k ) {
    res <- (yndvi-fenv(xswc,k))^2
    return( sum(res) )
}
# Find linear optimal solution 
res.lin <- optim( list(k=1), fmin.lin, method="Nelder-Mead", hessian=T )


#================================================================================
# Nonlinear
#================================================================================

# Cost function for determining global minimum (assuming IID ~ sigma=1)
fmin.nolin <- function( k ) {
    res <- (yndvi-fenv(xswc,k,linear=F))^2
    return( sum(res) )
}
# Find linear optimal solution 
res.nolin <- optim( list(k=1), fmin.nolin, method="Nelder-Mead", hessian=T )


#================================================================================
# Results
#================================================================================

par.out <- data.frame( Models=c("Linear","Nonlinear"), k=c(res.lin$par, res.nolin$par) )
write.table( par.out, file=FeoutFile, row.names=F, sep="," )

# Plot the data
pdf(file=outPlot, width=4.5, height=4)

    par( mar=c(4,4,1,1) )
    plot( xswc, yndvi, pch=19, col="black", xlab="", ylab="", las=1, ylim=c(0,0.7), xlim=c(0,0.3) )
    
    # calc model
    xmod <- seq(-0.1,0.4,0.01)
    ylin <- fenv(xmod, res.lin$par)
    ynol <- fenv(xmod, res.nolin$par, linear=F)
    # plot models
    lines( xmod, ylin, col='red', lwd=3 )
    lines( xmod, ynol, col='orange', lwd=3 )
    # labels
    mtext( expression(theta[soil]), side=1, line=2.5, cex=1.2 )
    mtext( expression(NDVI), side=2, line=2.7, cex=1. )
    # legend
    legend( "bottomright", 
           c(expression(NDVI==k*theta[s]), expression(NDVI==theta[s]/(k+theta[s]))),
           col=c("red","orange"), lwd=3, pch=-1, cex=0.8 )
dev.off()
