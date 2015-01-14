springDynamics <- function(twoSpring=FALSE,springFUN='Hookes',waterFun='Constant',visocityFun='None') {
    resistanceFUN   = match.fun(springFUN  )
    forcingFun      = match.fun(waterFun   )
    viscousFun      = match.fun(visocityFun)
    
    leaf=x=v=vx=vy=a=rep(0,nt)

    for (t in 2:nt) {
        Fwx=forcingFun(x[t-1])
        if (t>200) Fw <<- Fw*0.5
        
        Fr=resistanceFUN(x[t-1])
        if (twoSpring) Fr=Fr-resistanceFUN(-x[t-1])
        
        Fv=viscousFun(v);
        
        F=Fwx+Fr+Fv
        a[t]=F/m
        v[t]=v[t-1]+a[t]*dt
        
        x[t]=x[t-1]+min(c(1,v[t]*dt))
        
        if (x[t]<=0) x[t]=v[t]=0
        
    }
    
    titl=paste("Spring:"       ,springFUN,
             c("Single Spring","Double Spring")[twoSpring+1],
          ";   Water Forcing: ",waterFun,
          ";   Viscocity: "    ,visocityFun)
            
    plotPhen(1:nt,list(x,v,a),titl)
}

