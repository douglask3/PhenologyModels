download.data <- function(url,fileName) {
    remotefName = paste(url,fileName,sep="")
    localfName  = paste("data/",fileName,sep="")

    if (!file.exists(localfName))
        download.file(remotefName,destfile=localfName)
        
    return(localfName)
}