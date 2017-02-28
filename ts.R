ts = function(nameshare){

  data <- read.csv2(nameshare,sep=",")
  data <- data.frame(subset(data,data$tipo=="t",1:9))
  fecha <- data$fecha
  dias <- data.frame(unique(fecha[duplicated(fecha)]))
  
  timestamp <- paste(data$fecha, data$hora, sep=" ")
  timestamp <- paste(timestamp, data$minuto, data$segundo, sep=":")
  
  timestamp <- strptime(timestamp,format="%Y-%m-%d %H:%M:%S")
  data <- data.frame(data$fecha, timestamp, data$nombre,data$tipo,data$precio,data$volumen)
  
  
    for (i in 1:length(dias[,1])) {
    x1 <- subset( data,data$data.fecha == dias[i,] ) 
    x <- matrix(nrow=(length(x1$timestamp)-1),ncol=1)
    for ( j in 1:( length( x1$timestamp )-1 ) ) {
      x [j,1] = as.numeric ( difftime ( x1$timestamp[j],x1$timestamp[j+1],units = "mins" ) )
      x <- abs(x)
      y <- paste(dias[i,],"AVAL",".csv",sep="")
    
      write.table ( x,file=paste(dias[i,],nameshare,".csv",sep=""),row.names=FALSE )
      
    }
  }
  
  
  dias2 <- paste(dias[,1],nameshare,".csv",sep="")
  time <- lapply(dias2,read.csv)
  
  t <- unlist(time,use.names = FALSE)
  
  hist(t)
  
  t2 <- subset(t,t<= ( median(t)+3*mad(t) ))
  hist(t2,main=paste("Histogram of",nameshare),xlab="minutes between transactions")
  
  
  write.table(t,paste("frecuencia",nameshare,".csv",sep=""),sep=",",row.names = FALSE)
  
  jpeg(filename=paste("complete",nameshare,".jpeg",sep="") )
  hist(t,main=paste("Histogram of",nameshare),xlab="minutes between transactions")
  dev.off()
  
  jpeg(filename=paste("truncated",nameshare,".jpeg",sep="") )
  hist(t2,main=paste("Truncated histogram of",nameshare),xlab="minutes between transactions")
  dev.off()
}