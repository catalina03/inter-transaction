rm(list=ls())

##Conexion a Dropbox
camino1="C:/Users/A79947917/Dropbox/Volatilidad (1)/MKT Quality/Trading Halts_Castro/inter-transaction"

##Local
#camino1="C:/R/TermStructure"
data <- read.csv2(paste(camino1,"/ECOPETL2.csv",sep=""),sep=",")
data <- data.frame(subset(data,data$tipo=="t",1:9))
dias <- data.frame(unique(data$fecha))



data1<-subset(data,data$fecha==dias[1,])
timestamp <- paste(data1$fecha, data1$hora, sep=" ")
timestamp <- paste(timestamp, data1$minuto, data1$segundo, sep=":")

timestamp <- strptime(timestamp,format="%Y-%m-%d %H:%M:%S")
data1 <- data.frame(timestamp, data1$nombre,data1$tipo,data1$precio,data1$volumen)

x1 <- rep(0,length(data1$timestamp)-1)

for (i in 1:length(x1)-1) {
  x1[i]=as.numeric(difftime(timestamp[i],timestamp[i+1],units = "mins"))
}


#Keep only assets (despues) with estimated coefs
#grepn<-function(xx){which(names(data)[-length(names(data))] == xx)}  
#kass<-sapply(names(coefs),grepn)

x1=abs(x1)
hist(x1)

#median(x1)+3*mad(x1)
#nuevo histograma

x11 <- subset(x1,x1<= ( median(x1)+3*mad(x1) ))
hist(x11)


