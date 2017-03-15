rm(list=ls())

source("ts.r")

##Conexion a Dropbox
#camino1="C:/Users/A79947917/Dropbox/Volatilidad (1)/MKT Quality/Trading Halts_Castro/inter-transaction"
camino2="C:/Users/catac/Dropbox/RIntraday/Sin ceros falsos"
  
lstsb <- read.csv2(paste(camino2,"/Acciones.csv",sep=""), header=TRUE)
lstsb <- data.frame(paste(lstsb[,1],"2",".csv",sep=""))
mtable=apply(lstsb,1,ts)
