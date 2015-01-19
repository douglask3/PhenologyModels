springDynamics <- function(twoSpring=FALSE,
                           springFUN='Hookes',waterFun='Constant',visocityFun='None',
                           ...) {
    
    ##############################
    ## Setup & Initialize       ##
    ##############################
    resistanceFUN   = match.fun(springFUN  )
    forcingFun      = match.fun(waterFun   )
    viscousFun      = match.fun(visocityFun)
    
    leaf=v=a=F=Fwx=Fr=Fv=rep(0,nt)

    ##############################
    ## Calculate                ##
    ##############################
    for (t in 2:nt) {
        ## Current water force
        Fwx[t]=forcingFun(leaf[t-1])
        
        if (t >200) Fwx[t]=0
        
        ## resistance force
        Fr[t]=resistanceFUN(leaf[t-1])
        if (twoSpring) Fr[t]=Fr[t]-resistanceFUN(-leaf[t-1])
        
        ## viscous force
        Fv[t]=0.1*viscousFun(v[t-1],leaf[t-1]);
        F[t]=Fwx[t]+Fr[t]+Fv[t]
        
        ## accleration on intertia
        a[t]=F[t]/m
        v[t]=v[t-1]+a[t]*dt
        
        ## fraction leafs on
        leaf[t]=leaf[t-1]+min(c(1,v[t]*dt))
        
        
        if (leaf[t]>1) leaf[t]=1
        if (leaf[t]<=0) leaf[t]=v[t]=0
        
    }
    
    ##############################
    ## Plot                     ##
    ##############################
    titl=paste("Spring:"       ,springFUN,
             c("Single Spring","Double Spring")[twoSpring+1],
          ";   Water Forcing: ",waterFun,
          ";   Viscocity: "    ,visocityFun)
            
    plotPhen(1:nt,list(leaf,v,a,F,Fwx,Fr,Fv),titl,...)
}

