rm(list=ls())
camino2="C:/Users/catac/Dropbox/RIntraday/Sin ceros falsos"

data <- read.csv2(paste(camino2,"/","AVAL2.csv",sep=""),sep=",")
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
    y <- paste(dias[i,],"AVAL",".csv",sep="")
    
    write.table ( x,file=paste(dias[i,],"AVAL",".csv",sep=""),row.names=FALSE )
    
  }
}

dias2 <- paste(dias[,1],"AVAL",".csv",sep="")
time <- lapply(dias2,read.csv)

t <- unlist(time,use.names = FALSE)

hist(t)

m <- median(t)
t <- c(t,m)
write.table(t,paste("frecuencia","AVAL",".csv",sep=""),sep=",",row.names = FALSE)
write.table(m,paste("mediana","AVAL",".csv",sep=""),sep=",",row.names = FALSE)

jpeg(filename=paste("complete","AVAL",".jpeg",sep="") )
hist(t,main=paste("Histogram of","AVAL"),xlab="minutes between transactions")
dev.off()


