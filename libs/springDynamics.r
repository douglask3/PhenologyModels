springDynamics <- function(twoSpring=FALSE,springFUN='Hookes',waterFun='Constant',visocityFun='None') {
    resistanceFUN   = match.fun(springFUN  )
    forcingFun      = match.fun(waterFun   )
    viscousFun      = match.fun(visocityFun)
    
    leaf=x=v=a=F=Fwx=Fr=Fv=rep(0,nt)

    for (t in 2:nt) {
        Fwx[t]=forcingFun(x[t-1])
        
        Fr[t]=resistanceFUN(x[t-1])
        if (twoSpring) Fr[t]=Fr[t]-resistanceFUN(-x[t-1])
        
        Fv[t]=viscousFun(v[t-1],x[t-1]);
        
        F[t]=Fwx[t]+Fr[t]+Fv[t]
        a[t]=F[t]/m
        v[t]=v[t-1]+a[t]*dt
        
        x[t]=x[t-1]+min(c(1,v[t]*dt))
        
        if (x[t]<=0) x[t]=v[t]=0
        
    }
    
    titl=paste("Spring:"       ,springFUN,
             c("Single Spring","Double Spring")[twoSpring+1],
          ";   Water Forcing: ",waterFun,
          ";   Viscocity: "    ,visocityFun)
            
    plotPhen(1:nt,list(x,v,a,F,Fwx,Fr,Fv),titl)
}

