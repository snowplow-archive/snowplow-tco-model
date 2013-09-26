toKilo <- function(x) (x/1024)
toMega <- function(x) (toKilo(toKilo(x)))
toGiga <- function(x) (toMega(toKilo(x)))
fromKilo <- function(x) (x*1024)
fromMega <- function(x) (fromKilo(fromKilo(x)))
fromGiga <- function(x) (fromMega(fromKilo(x)))

