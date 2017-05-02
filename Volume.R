rm(list=ls())

source("vol.r")

##Conexion a Dropbox
#camino1="C:/Users/A79947917/Dropbox/Volatilidad (1)/MKT Quality/Trading Halts_Castro/inter-transaction"
camino2="C:/Users/catac/Dropbox/RIntraday/Sin ceros falsos"

#lstsb <- read.csv2(paste(camino2,"/Acciones1min.csv",sep=""), header=FALSE)
#lstsb <- read.csv2(paste(camino2,"/Acciones5min.csv",sep=""), header=FALSE)
lstsb <- read.csv2(paste(camino2,"/Acciones10min.csv",sep=""), header=FALSE)


lstsb <- data.frame(paste(camino2,"/",lstsb[,1],"2",".csv",sep=""))
mtable=apply(lstsb,1,vol)

