#' @name rad_nasa
#' @title Obtiene datos de radiación de Nasa Power
#' @description Obtiene datos de radiación solar global en el plano horizontal y
#' de temperatura de la base de datos Nasa Power.
#' @param intervalo Una cadena de caracteres.\cr
#' \code{intervalo="DIARIO"} para datos diarios.\cr
#' \code{intervalo="MENSUAL"} para datos mensuales de un año especificado en "fechas".\cr
#' \code{intervalo="HISTORICO"} para promedio mensual sobre período de 30 años.\cr
#' @param lonlat Vector con longitud y latitud de la localidad.
#' @param fechas Para:
#' \code{intervalo="DIARIO"}, vector con fecha inicio y fin. Ej: c("2018-01-01", "2018-12-31").\cr
#' \code{intervalo="MENSUAL"}, especificar un año con número.\cr
#' \code{intervalo="HISTORICO"}, especificar un año con número. Los datos no corresponderán al año
#' especificado, sino que será un promedio sobre los últimos 30 años. Este valor se utilizará para asignar
#' un año a los datos, que será útil para futuras comparaciones con datos de generación y cálculo de PR.
#' Valor por defecto: año anterior al año en curso.
#' @return Un xts con dos columnas: G0 y Ta (radiación global en el plano horizontal
#' y temperatura ambiente media). Para "HISTORICO" y "MENSUAL" el formato del índice de fechas es yearmon.
#' @author Daniel G. Paniagua
#' @references \itemize{
##'  \item{}{Sparks A (2019). nasapower: NASA-POWER Data from R. R package version 1.1.3,
##'  https://CRAN.R-project.org/package=nasapower. }
##'  \item{}{Sparks AH (2018). “nasapower: A NASA POWER Global Meteorology, Surface Solar Energy and Climatology
##'  Data Client for R.” The Journal of Open Source Software, 3(30), 1035. doi: 10.21105/joss.01035. }
##'  }
#' @example /tools/ej_rad_nasa.R
#' @export


rad_nasa <- function(intervalo="HISTORICO",
                     lonlat=c(-60.8,-32.9),
                     fechas=as.POSIXlt(Sys.Date())$year+1900-1){

  if(intervalo=="HISTORICO") intervalo <- "CLIMATOLOGY"
  if(intervalo=="MENSUAL") intervalo <- "INTERANNUAL"
  if(intervalo=="DIARIO") intervalo <- "DAILY"

  # library(nasapower)
  # library(dplyr)
  # library(zoo)
  # library(xts)

  if(intervalo=="INTERANNUAL") {fechas <- c(fechas-1, fechas)}

  rad_temp <- get_power(community="SSE",
                   pars=c("ALLSKY_SFC_SW_DWN","T2M"),
                   temporal_average=intervalo,
                   lonlat=lonlat,
                   dates = fechas)

  if(intervalo=="DAILY"){
    rad <- select(rad_temp, date=YYYYMMDD, G0=ALLSKY_SFC_SW_DWN, Ta=T2M)
  }

  else{
    rad_Ta <- filter(rad_temp, PARAMETER=="T2M")
    rad_G0 <- filter(rad_temp, PARAMETER=="ALLSKY_SFC_SW_DWN")

    rad <- data.frame(date=character(12),
                      G0=numeric(12),
                      Ta=numeric(12))
    rad$date <- "a"

    if(intervalo=="INTERANNUAL"){i <- 2} else {i <- 1}
    rad$G0[1] <- rad_G0[i,]$JAN
    rad$G0[2] <- rad_G0[i,]$FEB
    rad$G0[3] <- rad_G0[i,]$MAR
    rad$G0[4] <- rad_G0[i,]$APR
    rad$G0[5] <- rad_G0[i,]$MAY
    rad$G0[6] <- rad_G0[i,]$JUN
    rad$G0[7] <- rad_G0[i,]$JUL
    rad$G0[8] <- rad_G0[i,]$AUG
    rad$G0[9] <- rad_G0[i,]$SEP
    rad$G0[10] <- rad_G0[i,]$OCT
    rad$G0[11] <- rad_G0[i,]$NOV
    rad$G0[12] <- rad_G0[i,]$DEC

    rad$Ta[1] <- rad_Ta[i,]$JAN
    rad$Ta[2] <- rad_Ta[i,]$FEB
    rad$Ta[3] <- rad_Ta[i,]$MAR
    rad$Ta[4] <- rad_Ta[i,]$APR
    rad$Ta[5] <- rad_Ta[i,]$MAY
    rad$Ta[6] <- rad_Ta[i,]$JUN
    rad$Ta[7] <- rad_Ta[i,]$JUL
    rad$Ta[8] <- rad_Ta[i,]$AUG
    rad$Ta[9] <- rad_Ta[i,]$SEP
    rad$Ta[10] <- rad_Ta[i,]$OCT
    rad$Ta[11] <- rad_Ta[i,]$NOV
    rad$Ta[12] <- rad_Ta[i,]$DEC

    if(intervalo=="INTERANNUAL"){
      r1 <- as.yearmon(paste(fechas[2],"-01-01", sep=""))
      r2 <- as.yearmon(paste(fechas[2],"-02-01", sep=""))
      r3 <- as.yearmon(paste(fechas[2],"-03-01", sep=""))
      r4 <- as.yearmon(paste(fechas[2],"-04-01", sep=""))
      r5 <- as.yearmon(paste(fechas[2],"-05-01", sep=""))
      r6 <- as.yearmon(paste(fechas[2],"-06-01", sep=""))
      r7 <- as.yearmon(paste(fechas[2],"-07-01", sep=""))
      r8 <- as.yearmon(paste(fechas[2],"-08-01", sep=""))
      r9 <- as.yearmon(paste(fechas[2],"-09-01", sep=""))
      r10 <- as.yearmon(paste(fechas[2],"-10-01", sep=""))
      r11 <- as.yearmon(paste(fechas[2],"-11-01", sep=""))
      r12 <- as.yearmon(paste(fechas[2],"-12-01", sep=""))

      rad$date <- c(r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12)
    }
    if(intervalo=="CLIMATOLOGY"){
      r1 <- as.yearmon(paste(fechas,"-01-01", sep=""))
      r2 <- as.yearmon(paste(fechas,"-02-01", sep=""))
      r3 <- as.yearmon(paste(fechas,"-03-01", sep=""))
      r4 <- as.yearmon(paste(fechas,"-04-01", sep=""))
      r5 <- as.yearmon(paste(fechas,"-05-01", sep=""))
      r6 <- as.yearmon(paste(fechas,"-06-01", sep=""))
      r7 <- as.yearmon(paste(fechas,"-07-01", sep=""))
      r8 <- as.yearmon(paste(fechas,"-08-01", sep=""))
      r9 <- as.yearmon(paste(fechas,"-09-01", sep=""))
      r10 <- as.yearmon(paste(fechas,"-10-01", sep=""))
      r11 <- as.yearmon(paste(fechas,"-11-01", sep=""))
      r12 <- as.yearmon(paste(fechas,"-12-01", sep=""))

      rad$date <- c(r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12)
    }

  }
  xts.rad <- xts(data.frame(G0=rad$G0, Ta=rad$Ta), order.by = rad$date)
  return(xts.rad)
}
