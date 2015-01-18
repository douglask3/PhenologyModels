plotPhen <- function(x,y,title,cols=rainbow(length(x)),ltys=1) {
    rx=range(x)
    ry=range(y)
    
    plot(rx,ry,type='n',xlab='time',ylab='')
    lines(rx,c(0,0),lty=2)
    
    mapply(lines,y,col=cols,MoreArgs=list(x=x),lty=ltys)
    
    mtext(title,line=1,cex=0.67)
    mtext(paste("Water Force: ",Fw,";  Mass: ",m,";  Spring constant:",k,";   dt:",dt),cex=0.5)
}