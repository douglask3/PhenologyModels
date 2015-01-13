springDynamics <- function(twoSpring=FALSE,springFUN='Hookes') {
    FUN=match.fun(springFUN)
    x=v=a=rep(0,nt)

    for (t in 2:nt) {
        Fr=FUN(x[t-1])
        if (twoSpring) Fr=Fr-FUN(-x[t-1])
        F=Fw+Fr
        a[t]=F/m
        v[t]=v[t-1]+a[t]*dt
        x[t]=x[t-1]+v[t]*dt
    }

    plotPhen(1:nt,list(x,v,a),paste(springFUN,c("1 spring","2 spring")[twoSpring+1]))
}

