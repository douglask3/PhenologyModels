##########################################################################################
## cfg                                                                                  ##
##########################################################################################
library(gitProjectExtras)
sourceAllLibs()
sourceAllLibs("springs")
sourceAllLibs("forces/forcing")
sourceAllLibs("forces/springs")
sourceAllLibs("forces/viscous")

##########################################################################################
## Set up parameters                                                                    ##
##########################################################################################
nt=400; dt=0.1;
Fw=1; m=1; k=1;

##########################################################################################
## Open Figure                                                                          ##
##########################################################################################
pdf("Springs.pdf",height=12,width=24)
par(mfrow=c(4,4))

###########################################################################################
## Run tests                                                                             ##
###########################################################################################

## For each spring type, run 4 tests:
springDynamicss <- function(...) {
    # 1. constant force; no viscocity
    springDynamics(...)
    # 2. dampened force; no viscocity
    springDynamics(waterFun='Dampend',...)
    # 3. constant force, with viscocity
    springDynamics(visocityFun='SpatiallyConstant',...)
    # 4. dampened force, with viscocity
    springDynamics(waterFun='Dampend',visocityFun='SpatiallyConstant',...)
    # 3. constnat force, with varying viscocity
    springDynamics(visocityFun='SpatiallyVarying',...)
    # 3. dampened force, with varying viscocity
    springDynamics(waterFun='Dampend',visocityFun='SpatiallyVarying',...)
}

## Hookes 1 spring ##
springDynamicss()

## Hookes 2 spring ##
springDynamicss(TRUE)

## Non-Linear ##
springDynamicss(springFUN='exponentialSpring')

## Non-Linear ##
springDynamicss(TRUE,springFUN='exponentialSpring')

dev.off()