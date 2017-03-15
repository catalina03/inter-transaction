ts = function(nameshare){

  data <- read.csv2(nameshare,sep=",")
  data <- data.frame(subset(data,data$tipo=="t",1:9))
    
  timestamp <- paste(data$fecha, data$hora, sep=" ")
  timestamp <- paste(timestamp, data$minuto, data$segundo, sep=":")
  
  timestamp <- strptime(timestamp,format="%Y-%m-%d %H:%M:%S")
  data <- data.frame(data$fecha, timestamp, data$nombre,data$tipo,data$precio,data$volumen)
  
  x=0
  
  for (i in 1:(length(data$timestamp)-1)) {
    if ( data$timestamp[i]==data$timestamp[i+1] & data$data.precio[i]==data$data.precio[i+1] ) {
      x = (x+1)
    }  
  }
  
  for ( i in 1:(length(data$timestamp)-x-1) ) {
    while ( data$timestamp[i] == data$timestamp[i+1] & data$data.precio[i] == data$data.precio[i+1] ) {
      data <- data[-(i+1),]
    }
  }
  
  fecha <- data$data.fecha
  dias <- data.frame(unique(fecha[duplicated(fecha)]))
  
  
    for (i in 1:length(dias[,1])) {
    x1 <- subset( data,data$data.fecha == dias[i,] ) 
    x <- matrix(nrow=(length(x1$timestamp)-1),ncol=1)
    for ( j in 1:( length( x1$timestamp )-1 ) ) {
      x [j,1] = as.numeric ( difftime ( x1$timestamp[j],x1$timestamp[j+1],units = "mins" ) )
      x <- abs(x)
      y <- paste(nameshare,dias[i,],".csv",sep="")
    
      write.table ( x,file=paste(nameshare,dias[i,],".csv",sep=""),row.names=FALSE )
      
    }
  }
  
  
  dias2 <- paste(nameshare,dias[,1],".csv",sep="")
  time <- lapply(dias2,read.csv)
  
  t <- unlist(time,use.names = FALSE)
  
  hist(t)
  
  m <- median(t)
  t <- c(t,m)
  write.table(t,paste(nameshare,"frecuencia",".csv",sep=""),sep=",",row.names = FALSE)
  write.table(m,paste(nameshare,"mediana",".csv",sep=""),sep=",",row.names = FALSE)
  
  jpeg(filename=paste(nameshare,"complete",".jpeg",sep="") )
  hist(t,main=paste("Histogram of",nameshare),xlab="minutes between transactions")
  dev.off()
  
  #t2 <- subset(t,t<= ( median(t)+3*mad(t) ))
  #hist(t2,main=paste("Histogram of",nameshare),xlab="minutes between transactions")
 
  }
