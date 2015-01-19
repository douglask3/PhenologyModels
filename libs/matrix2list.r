matrix2list  <- function(...) matrix2lists(...)
matrix2lists <- function(x)
    split(as.matrix(x), rep(1:ncol(x), each = nrow(x)))
