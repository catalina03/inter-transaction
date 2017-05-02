rm(list=ls())

library("xts")
library("zoo")

camino2="C:/Users/catac/Dropbox/RIntraday/Sin ceros falsos"
#camino2="C:/Users/A79947917/Dropbox/RIntraday/Sin ceros falsos"
data <- read.csv2(paste(camino2,"/","PFBCOLO2.csv",sep=""),sep=",")
data <- data.frame(subset(data,data$tipo=="t",1:9))
dias <- data.frame(unique(data$fecha))

timestamp <- paste(data$fecha, data$hora, sep=" ")
timestamp <- paste(timestamp, data$minuto, data$segundo, sep=":")
timestamp <- strptime(timestamp,format="%Y-%m-%d %H:%M:%S")

data1 <- data.frame(data$fecha, timestamp, data$nombre,data$tipo,data$precio,data$volumen)
volume=xts( data1[,c(3,4,5,6)],order.by =data1$timestamp)
p5min<-endpoints(volume, on="minutes",k=5)
volume5min<-period.apply(as.numeric(volume[,"data.volumen"]),INDEX=p5min, FUN=sum)
spread5min<-period.apply(as.numeric(volume[,"data.price"]),INDEX=p5min, FUN=mean)


#fecha <- as.matrix(strftime(index(volume[p5min]), format = "%Y-%m-%d"))
#volume5min<-cbind(fecha,volume5min)
volume5min <- xts(volume5min,order.by =index(volume[p5min]))
vol <- split.xts(volume5min,"days")

for ( i in 1:length(dias[,1])){
  dias2 <- paste(dias[i,1],"PREC.csv")
  write.csv(vol[i],dias2)
}



