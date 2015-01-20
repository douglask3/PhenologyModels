library(gitProjectExtras)
setupProjectStructure()
sourceAllLibs()
lapply(c('pastecs','zoo'),installSource)

dataDir         = 'data/'

##########################################################################################
## Download Data                                                                        ##
##########################################################################################

SturtPlainsUrl  = 'http://bio.mq.edu.au/bcd/dingo/DINGO%20OUTPUTS/SturtPlains/'
SturtPlainsFile = 'Advanced_processed_data_SturtPlains_v12.csv'


SturtPlainsFile = download.data(SturtPlainsUrl,SturtPlainsFile,dataDir)
