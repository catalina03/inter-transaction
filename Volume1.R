rm(list=ls())

library("highfrequency")

camino2="C:/Users/catac/Dropbox/RIntraday/Sin ceros falsos"

data <- read.csv2(paste(camino2,"/","ECOPETL2.csv",sep=""),sep=",")
data <- data.frame(subset(data,data$tipo=="t",1:9))
dias <- data.frame(unique(data$fecha))
data1<-subset(data,data$fecha==dias[1,])

timestamp <- paste(data1$fecha, data1$hora, sep=" ")
timestamp <- paste(timestamp, data1$minuto, data1$segundo, sep=":")

timestamp <- strptime(timestamp,format="%Y-%m-%d %H:%M:%S")
data1 <- data.frame(data1$fecha, timestamp, data1$nombre,data1$tipo,data1$precio,data1$volumen)
volume=xts( data1[,c(3,4,5,6)],order.by =data1$timestamp)
#volume=xts( data1[,c(6)],order.by =data1$timestamp)

colnames(volume) <- c("SYMBOL","EX","PRICE","SIZE")
as.numeric(volume$SIZE)

v<- aggregatets(volume,FUN="sum",on="minutes",k=1)

v <- aggregateTrades(volume,k=1,on="minutes",marketopen="8:30:00",marketclose="14:55:00")

plot(index(v),coredata(v),type="h",lwd=8,col=heat.colors(50))

sum(as.numeric(volume$SIZE[1:4]))
