plotPhen <- function(x,y,title,cols=c("green","brown","blue")) {
    rx=range(x)
    ry=range(y)
    
    plot(rx,ry,type='n',xlab='time',ylab='')
    lines(rx,c(0,0),lty=2)
    
    mapply(lines,y,col=cols,MoreArgs=list(x=x),lty=c(1,2,1,1,1))
    #legend('topleft',legend=c('Phenology','Production','Inertia','Force'),lty=1,col=cols)
    
    mtext(title,line=1)
    mtext(paste("Water Force: ",Fw,";  Mass: ",m,";  Spring constant:",k,";   dt:",dt),cex=0.67)
}