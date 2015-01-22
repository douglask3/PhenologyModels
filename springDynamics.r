springDynamics <- function(Fe,r=1,d=1,returnFull=FALSE,dt=(1/10),initial=0) {
    
    ##############################
    ## Setup & Initialize       ##
    ##############################    
    vectors=forces=matrix(0,ncol=3,nrow=0)
    colnames(vectors) = c('a', 'v',  'x' )
    colnames(forces ) = c('F', 'Fr', 'Fd')
    x=v=initial
    
    ##############################
    ## Calculate                ##
    ##############################
    for (t in 1:length(Fe)) {
        ## resistance force
        Fr = -r * x
        Fd = -d * v
        F  = Fe[t] + Fr + Fd
        
        forces = rbind(forces,c(Fe[t],Fr,Fd))

        ## acceleration on intertia
        a = F
        v = v + a*dt
        
        ## fraction leafs on
        x = x + min(c(1,v*dt))
        
        if (x > 1) {
            x=1
            v=0
        }
        if (x <=0) x = v = 0

        vectors = rbind(vectors, c(a,v,x))
    }
    if (returnFull) return(list(forces,vectors))
        else return(vectors[,3])
}

