rm(list=ls())

library("xts")
library("zoo")


#Sys.setenv(TZ = “America/Bogota”)
#Sys.setenv(TZ = “UTC”)

#camino2="C:/Users/catac/Dropbox/RIntraday/Sin ceros falsos"
camino2="C:/Users/A79947917/Dropbox/RIntraday/Sin ceros falsos"
data <- read.csv2(paste(camino2,"/","PFBCOLO2.csv",sep=""),sep=",")
data <- data.frame(subset(data,data$tipo=="t",1:9))
dias <- data.frame(unique(data$fecha))

timestamp <- paste(data$fecha, data$hora, sep=" ")
timestamp <- paste(timestamp, data$minuto, data$segundo, sep=":")
timestamp <- strptime(timestamp,format="%Y-%m-%d %H:%M:%S")

data1 <- data.frame(data$fecha, timestamp, data$nombre,data$tipo,data$precio,data$volumen)
volume=xts( data1[,c(3,4,5,6)],order.by =data1$timestamp, tzone = "America/Chicago") #misma q bogota Mayo
p5min<-endpoints(volume, on="minutes",k=5)
volume5min<-period.apply(as.numeric(volume[,"data.volumen"]),INDEX=p5min, FUN=sum)

volume5min <- xts(volume5min,order.by =index(volume[p5min]))
#sx1 <- rbind(volume5min["2010-03-14/2010-11-07"],volume5min["2011-03-13/2011-11-06"],volume5min["2012-03-11/2010-11-04"])
#sx2 <- rbind(volume5min["2010-11-08/2011-03-12"],volume5min["2011-11-07/2012-03-10"])
#index(sx2) <- index(sx2)-3600

#volume5min <- rbind(sx1,sx2)

vol <- split.xts(volume5min,"days")

for ( i in 1:length(dias[,1])){
  dias2 <- paste(dias[i,1],"PREC.csv")
  write.csv(vol[i],dias2)
}

#Ejemplo cambiar time, con timezone, antes de merge
d1<-volume5min["20110630"]
indexTZ(d1)
tzone(d1)<-"Asia/Hong_Kong" #offset by 1 hour check relevant time zone.

#round up time with align.time

#extracting xts object from list
ck<-vol[[1]]

#create axis for plots
hoursp <- seq.POSIXt(as.POSIXlt("2016-01-01 08:00:00"), length = length(ck),
                     by = (as.numeric(index(ck)[length(ck)]-index(ck[1]))*(60**2))/(length(ck)))

#Plots
barplot(ck, xaxt="n", yaxt="n")
axis.POSIXct(side=1, at=hoursp, format="%H")
axis(side=2,las=2)


library("ggplot2")
ggplot(ck,aes(x=index(ck),y=coredata(ck))) + geom_bar(stat="identity")

