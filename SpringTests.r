##########################################################################################
## cfg                                                                                  ##
##########################################################################################
library(gitProjectExtras)
sourceAllLibs()
sourceAllLibs("springs")
sourceAllLibs("forces/forcing")
sourceAllLibs("forces/springs")
sourceAllLibs("forces/viscous")
source("springDynamics.r")
makeDir("figs/")

##########################################################################################
## Set up parameters                                                                    ##
##########################################################################################
## For model
nt=400; dt=0.1;
Fw=1; m=1; k=1;

## For plot
cols=c("green","brown","yellow","blue","cyan","cyan",'cyan')
ltys=c(1,1,1,1,2,3,4)


##########################################################################################
## Open Figure                                                                          ##
##########################################################################################
pdf("figs/Springs.pdf",height=18,width=18)
lmat=matrix(1:(6*4),6,4)
lmat=rbind(lmat,rep((6*4)+1,4))
layout(lmat,height=c(rep(1,6),0.7))

###########################################################################################
## Run tests                                                                             ##
###########################################################################################

## For each spring type, run 4 tests:
springDynamicss <- function(...) {
    FUN <- function(...) springDynamics(ltys=ltys,cols=cols,...)
    # 1. constant force; no viscocity
    FUN(...)
    # 2. dampened force; no viscocity
    FUN(waterFun='Dampend',...)
    # 3. constant force, with viscocity
    FUN(visocityFun='SpatiallyConstant',...)
    # 4. dampened force, with viscocity
    FUN(waterFun='Dampend',visocityFun='SpatiallyConstant',...)
    # 5. constnat force, with varying viscocity
    FUN(visocityFun='SpatiallyVarying',...)
    # 6. dampened force, with varying viscocity
    FUN(waterFun='Dampend',visocityFun='SpatiallyVarying',...)
}

## Hookes 1 spring ##
springDynamicss()

## Hookes 2 spring ##
springDynamicss(TRUE)

## Non-Linear ##
springDynamicss(springFUN='exponentialSpring')

## Non-Linear ##
springDynamicss(TRUE,springFUN='exponentialSpring')

plot.new()

legend('topleft',legend=c('Phenology','Inertia','Acceleration',"Overall Force",
                          "Water forcing","Resistance Force","Viscous Force"),
                          lty=ltys,col=cols,horiz=TRUE,xpd=TRUE)
                          
dev.off()