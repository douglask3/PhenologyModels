#!/usr/bin/env Rscript

# Where to save the output PDF for the preliminary fitting
outFile <- "outputs/Fe_k_Table.csv"
outPlot <- "figs/Fe_from_NDVI_and_SWC.pdf"

# Import our trimmed-down Sturt Plains dataset
ecdata <- read.csv( file="outputs/ecDaily.csv", header=T, sep="," )
names(ecdata) <- c("Day","Month","Year","SWC10","NDVI250X")

# There's probably a better way to extract these points
ndvi.raw    <- aggregate( NDVI250X~Year, ecdata, range )
ndvi.range  <- as.data.frame(cbind(ndvi.raw[,1],ndvi.raw[,2]))
names(ndvi.range) <- c("Year","Min","Max")

#================================================================================
# Fit data with a set of models
#================================================================================

# Need to find soil water content values for min and max NDVI for each year
force.env <- subset( ecdata, (NDVI250X%in%ndvi.range$Min | NDVI250X%in%ndvi.range$Max) & NDVI250X>0, 
                   select=c(SWC10,NDVI250X) )

# Function to explain the relationship between Min/Max SWC and NDVI
fenv <- function( swc, k, linear=T ) {
    if( linear==T ) {
        return(k*swc)
    } else {
        return(swc/(swc+k))
    }
}

# Set global X & Y variables (I know...)
yndvi   <- force.env$NDVI250X
xswc    <- force.env$SWC10

# Linear
res.lin <- nls( NDVI250X~k*SWC10, data=force.env, start=list(k=1) )
# Nonlinear (asymptote - NDVI can be negative)
res.nol <- nls( NDVI250X~SWC10/(k+SWC10), data=force.env, start=list(k=1) )
# Nonlinear (sigmoid - NDVI must be positive)
res.sig <- nls( NDVI250X~s+1/(1+exp(k*(SWC10))), data=force.env, start=list(s=0,k=1) )



#================================================================================
# Results
#================================================================================

get.par <- function(object) summary(object)[10][[1]][1]
par.out <- data.frame( Models=c("Linear","Nonlinear","Sigmoid"), k=sapply( list(res.lin, res.nol, res.sig), get.par) )
write.table( par.out, file=outFile, row.names=F, sep="," )

# Plot the data
pdf(file=outPlot, width=4.5, height=4)
with( force.env, {
    par( mar=c(4,4,1,1) )
    plot( SWC10, NDVI250X, pch=19, col="black", xlab="", ylab="", las=1, ylim=c(0,0.7), xlim=c(0,0.3) )
    })
    # calc model
    xmod <- seq(-0.1, 0.4, 0.01)
    # plot model
    lines( xmod, predict(res.lin, list(SWC10=xmod)), col='red', lwd=3 )
    lines( xmod, predict(res.nol, list(SWC10=xmod)), col='orange', lwd=3 )
    lines( xmod, predict(res.sig, list(SWC10=xmod)), col='purple', lwd=3 )
    # labels
    mtext( expression(theta[soil]), side=1, line=2.5, cex=1.2 )
    mtext( expression(NDVI), side=2, line=2.7, cex=1. )
    # legend
    legend( "bottomright", 
           c(expression(k*theta[s]), 
             expression(theta[s]/(k+theta[s])),
             expression(n+1/(1+exp(-k*theta[s])))
             ),
           col=c("red","orange","purple"), lwd=3, pch=-1, cex=0.8 )
dev.off()
