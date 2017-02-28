rm(list=ls())

source("ts.r")

lstsb <- read.csv2("Acciones.csv", header=TRUE)
lstsb <- data.frame(paste(lstsb[,1],"2",".csv",sep=""))
mtable=apply(lstsb,1,ts)
