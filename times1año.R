rm(list=ls())
  
data <- read.csv2("PAZRIO2.csv",sep=",")
data <- data.frame(subset(data,data$tipo=="t",1:9))
fecha <- data$fecha
dias <- data.frame(unique(fecha[duplicated(fecha)]))

timestamp <- paste(data$fecha, data$hora, sep=" ")
timestamp <- paste(timestamp, data$minuto, data$segundo, sep=":")
  
timestamp <- strptime(timestamp,format="%Y-%m-%d %H:%M:%S")
data <- data.frame(data$fecha, timestamp, data$nombre,data$tipo,data$precio,data$volumen)

y="PAZRIO" 
dir.create(y, showWarnings = TRUE, recursive = FALSE, mode = "0777")

for (i in 1:length(dias[,1])) {
  x1 <- subset( data,data$data.fecha == dias[i,] ) 
  x <- matrix(nrow=(length(x1$timestamp)-1),ncol=1)
  for ( j in 1:( length( x1$timestamp )-1 ) ) {
    x [j,1] = as.numeric ( difftime ( x1$timestamp[j],x1$timestamp[j+1],units = "mins" ) )
    x <- abs(x)
    y <- paste(dias[i,],"PAZRIO",".csv",sep="")
    
    write.table( x,file=paste(dias[i,],".csv",sep=""),row.names=FALSE )
  
    }
    }


dias2 <- paste(dias[,1],".csv",sep="")
time <- lapply(dias2,read.csv)

t <- unlist(time,use.names = FALSE)

hist(t)

t2 <- subset(t,t <= ( median(t)+(3*mad(t) ) ))
hist(t2,main=paste("Histogram of","AVAL"),xlab="minutes between transactions")


write.table(t,paste("frecuencia",nameshare,".csv",sep=""),sep=",",row.names = FALSE)

jpeg(filename = paste("aval",".jpeg",sep="") )
hist(t2,main=paste("Histogram of","AVAL"),xlab="minutes between transactions")
dev.off()

