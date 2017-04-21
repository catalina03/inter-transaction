rm(list=ls())

library("xts")
library("zoo")

#camino2="C:/Users/catac/Dropbox/RIntraday/Sin ceros falsos"
camino2="C:/Users/A79947917/Dropbox/RIntraday/Sin ceros falsos"
data <- read.csv2(paste(camino2,"/","ECOPETL2.csv",sep=""),sep=",")
data <- data.frame(subset(data,data$tipo=="t",1:9))
dias <- data.frame(unique(data$fecha))
data1<-subset(data,data$fecha==dias[1,])

timestamp <- paste(data1$fecha, data1$hora, sep=" ")
timestamp <- paste(timestamp, data1$minuto, data1$segundo, sep=":")

timestamp <- strptime(timestamp,format="%Y-%m-%d %H:%M:%S")
data1 <- data.frame(data1$fecha, timestamp, data1$nombre,data1$tipo,data1$precio,data1$volumen)
volume=xts( data1[,c(3,4,5,6)],order.by =data1$timestamp)
p5min<-endpoints(volume, on="minutes",k=5)
volume5min<-period.apply(as.numeric(volume[,"data1.volumen"]),INDEX=p5min, FUN=sum)
volume5min<-xts(volume5min,order.by =index(volume[p5min]))
