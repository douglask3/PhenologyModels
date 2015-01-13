source("libs/plotPhen.r")
source("libs/springDynamics.r")
source("springs/Hookes.r")

source("springs/exponentialSpring.r")

nt=2000; dt=0.01;
Fw=1; m=1; k=1;

pdf("Springs.pdf",height=12,width=4)
par(mfrow=c(4,1))

## Hookes 1 spring ##
springDynamics()

## Hookes 2 spring ##
springDynamics(TRUE)

## Non-Linear ##
springDynamics(springFUN='exponentialSpring')

## Non-Linear ##
springDynamics(TRUE,springFUN='exponentialSpring')

dev.off()