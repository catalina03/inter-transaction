vol = function(nameshare){
  
  library("xts")
  library("zoo")
  
  camino2="C:/Users/catac/Dropbox/RIntraday/Sin ceros falsos"
  #camino2="C:/Users/A79947917/Dropbox/RIntraday/Sin ceros falsos"
  data <- read.csv2(nameshare,sep=",")
  data <- data.frame(subset(data,data$tipo=="t",1:9))
  dias <- data.frame(unique(data$fecha))
  
  timestamp <- paste(data$fecha, data$hora, sep=" ")
  timestamp <- paste(timestamp, data$minuto, data$segundo, sep=":")
  timestamp <- strptime(timestamp,format="%Y-%m-%d %H:%M:%S")
  
  data1 <- data.frame(data$fecha, timestamp, data$nombre,data$tipo,data$precio,data$volumen)
  volume=xts( data1[,c(3,4,5,6)],order.by =data1$timestamp)
  
  #p1min<-endpoints(volume, on="minutes",k=1)
  #p5min<-endpoints(volume, on="minutes",k=5)
  p10min<-endpoints(volume, on="minutes",k=10)
  
  
  #volume1min<-period.apply(as.numeric(volume[,"data.volumen"]),INDEX=p1min, FUN=sum)
  #volume5min<-period.apply(as.numeric(volume[,"data.volumen"]),INDEX=p5min, FUN=sum)
  volume10min<-period.apply(as.numeric(volume[,"data.volumen"]),INDEX=p10min, FUN=sum)
  
  #spread1min<-period.apply(as.numeric(volume[,"data.price"]),INDEX=p1min, FUN=mean)
  #spread5min<-period.apply(as.numeric(volume[,"data.price"]),INDEX=p5min, FUN=mean)
  spread10min<-period.apply(as.numeric(volume[,"data.price"]),INDEX=p10min, FUN=mean)
  
  #volume1min <- xts(volume1min,order.by =index(volume[p1min]))
  #volume5min <- xts(volume5min,order.by =index(volume[p5min]))
  volume10min <- xts(volume10min,order.by =index(volume[p10min]))
  
  #vol <- split.xts(volume1min,"days")
  #vol <- split.xts(volume5min,"days")
  vol <- split.xts(volume10min,"days")
  
  for ( i in 1:length(dias[,1])){
    dias2 <- paste(nameshare,dias[i,1],".csv")
    write.csv(vol[i],dias2)
  }
  
}
