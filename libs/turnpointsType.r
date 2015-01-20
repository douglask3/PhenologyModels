turnpointsType <- function(tps,isPeak=TRUE) {
    pnts = tps$tppos
    Type = tps$peaks[pnts]
    if (isPeak) return(Type)

    pnts[ Type] = 'Peak'
    pnts[!Type] = 'Pit'
}
