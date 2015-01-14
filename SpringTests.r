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
pdf("Springs.pdf",height=12,width=12)
par(mfrow=c(4,2))

springDynamicss <- function(...) {
    springDynamics(...)
    springDynamics(waterFun='Dampend',...)
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