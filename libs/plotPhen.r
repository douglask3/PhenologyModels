plotPhen <- function(x,y,title,cols=c("green","brown","blue","cyan","cyan",'cyan'),
                                ltys=c(1,1,1,2,3,4)) {
    rx=range(x)
    ry=range(y)
    
    plot(rx,ry,type='n',xlab='time',ylab='')
    lines(rx,c(0,0),lty=2)
    
    mapply(lines,y,col=cols,MoreArgs=list(x=x),lty=ltys)
    #legend('topleft',legend=c('Phenology','Production','Inertia','Force'),lty=1,col=cols)
    
    mtext(title,line=1,cex=0.8)
    mtext(paste("Water Force: ",Fw,";  Mass: ",m,";  Spring constant:",k,";   dt:",dt),cex=0.67)
}