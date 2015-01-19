download.data <- function(url,fileName,dataDir="data/") {
    remotefName = paste(url,fileName,sep="")
    localfName  = paste(dataDir,fileName,sep="")

    if (!file.exists(localfName))
        download.file(remotefName,destfile=localfName)
        
    return(localfName)
}