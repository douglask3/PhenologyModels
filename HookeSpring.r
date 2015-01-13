source("libs/plotPhen.r")

nt=1000; dt=0.01;
Fw=1; m=1; k=1;

twoSping=TRUE

x=v=a=rep(0,nt)

for (t in 2:nt) {
    Fr=-k*x[t-1]
    if (twoSping) Fr=-k*x[t-1]*2
    F=Fw+Fr
    a[t]=F/m
    v[t]=v[t-1]+a[t]*dt
    x[t]=x[t-1]+v[t]*dt
}

plotPhen(1:nt,list(x,v,a),paste("Hookes",c("1 spring","2 spring")[twoSping+1]))
