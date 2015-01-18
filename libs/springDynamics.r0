springDynamics <- function(twoSpring=FALSE,springFUN='Hookes',waterFun='Constant') {
    resistanceFUN   = match.fun(springFUN)
    forcingFun      = match.fun(waterFun )
    
    leaf=x=v=vx=vy=a=rep(0,nt)

    for (t in 2:nt) {
        Fwx=forcingFun(x[t-1])
        if (t>200) Fw <<- Fw*0.5
        
        Fr=resistanceFUN(x[t-1])
        if (twoSpring) Fr=Fr-resistanceFUN(-x[t-1])
        
        if (x<Fw) Fv=-(1/dt)*v[t-1]*x[t-1] else Fv=0
        #Fv=-(1/dt)*v[t-1]*x[t-1]
        
        #if (t==10) browser()
        F=Fwx+Fr+Fv
        a[t]=F/m
        v[t]=v[t-1]+a[t]*dt
        
        x[t]=x[t-1]+min(c(1,v[t]*dt))
        
        if (x[t]<=0) x[t]=v[t]=0
        
    }

    plotPhen(1:nt,list(x,v,a),paste(springFUN,waterFun,c("1 spring","2 spring")[twoSpring+1]))
}

