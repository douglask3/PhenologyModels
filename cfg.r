library(gitProjectExtras)
setupProjectStructure()
sourceAllLibs()

##########################################################################################
## Download Data                                                                        ##
##########################################################################################

SturPlainsUrl  = 'http://bio.mq.edu.au/bcd/dingo/DINGO%20OUTPUTS/SturtPlains/'
SturPlainsFile = 'Advanced_processed_data_SturtPlains_v11b.csv'


SturPlainsFile = download.data(SturPlainsUrl,SturPlainsFile)