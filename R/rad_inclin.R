#' @name rad_inclin
#' @title Calcula el valor de radiación solar en el plano inclinado.
#' @description Calcula el valor de radiación solar en el plano inclinado
#' a partir de la radiación solar en el plano horizontal y la temperatura.
#' Funciona para datos diarios y datos mensuales.
#' @param horiz xts con dos columnas: "G0" con radiación en el plano horizontal en kW/m² y
#' "Ta" con temperatura media en ºC. Para datos mensuales, el índice de fechas en formato yearmon.
#' Para datos intradiarios, el índice de fechas debe incluir el huso horario correspondiente.
#' @param lon Numérico. Longitud de la ubicación del lugar en grados. Solo utilizado para datos
#' de entrada intradiarios.
#' @param lat Numérico. Latitud de la ubicación del lugar en grados. Negativo para hemisferio sur.
#' @param beta Numérico. Inclinación del panel en grados.
#' @param alfa Numérico. Azimuth en grados. Para hemisferio norte, el sur es cero, es negativo hacia el este
#' y positivo hacia el oeste. El package solaR no especifica para el hemisferio sur, pero se verificó que el norte es cero.
#' Tomar mismo criterio que para hemisferio norte para este y oeste.
#' @param int_entrada Cadena de caracteres: "MENSUAL", "DIARIO" o "INTRADIARIO" según corresponda a los
#' datos de radiación y temperatura provistos en horiz.
#' @param iS Numérico. Grado de suciedad. Su valor  puede ser 0,1,2,3,4. iS=0 no considera el efecto
#' de suciedad y reflexión. iS=1 a iS=4 tiene en cuenta el efecto de suciedad y reflexión, donde
#' iS=1 corresponde a una superficie limpia e iS=4 corresponde a una superficie sucia. El valor por defecto es 2.
#' @param year Numérico. Año al que corresponden los datos. Solo utilizado para datos mensuales.
#' Valor por defecto: año anterior al actual.
#' @return Devuelve el xts \code{horiz} con una columna adicional con la radiación en el plano del panel.
#' @author Daniel G. Paniagua
#' @references \itemize{
##'  \item{}{Perpiñán, O, Energía Solar Fotovoltaica, 2015. (http://oscarperpinan.github.io/esf/)}
##'  \item{}{Perpiñán O (2012). “solaR: Solar Radiation and Photovoltaic Systems with R.” Journal
##'  of Statistical Software, 50(9), 1–32. http://www.jstatsoft.org/v50/i09/. }
##'  }
#' @example /tools/ej_rad_inclin.R
#' @export

rad_inclin <- function(horiz, lon=-62.8, lat=-32.9, beta=45, alfa=0, int_entrada="MENSUAL",
                       iS=2, year=as.POSIXlt(Sys.Date())$year+1900-1){

  # library(solaR)
  # library(dplyr)
  # library(xts)

  horiz$G0 <- horiz$G0*1000
  if(int_entrada=="INTRADIARIO"){
    idx_local <- index(horiz)
    idx_solar <- local2Solar(idx_local, lon = lon)
    z.horiz <- zoo(coredata(horiz), order.by = idx_solar)
  }
  horiz <- data.frame(date=index(horiz), G0=coredata(horiz$G0), Ta=coredata(horiz$Ta))

  #####CREA OBJETO DE CLASE Gef (solaR)#####
  ###"Gef": clase tipo S4, "irradiation and irradiance on the generator plane"

  #Crea objeto Meteo a partir de dataframe "horiz"

  if(int_entrada=="INTRADIARIO"){
    bd_i <- zoo2Meteo(z.horiz, lat=lat)
    #Crea objeto Gef para datos diarios
    if(iS!=0){
      Gef_inclin <- calcGef(lat=lat,
                            modeTrk='fixed',
                            modeRad='bdI',
                            dataRad=bd_i,
                            beta=beta, alfa=alfa, iS=iS)
      horiz <- mutate(horiz, Gef=Gef_inclin@GefI$Gef/1000)
    }
    if(iS==0){
      Gef_inclin <- calcGef(lat=lat,
                            modeTrk='fixed',
                            modeRad='bdI',
                            dataRad=bd_i,
                            beta=beta, alfa=alfa)
      horiz <- mutate(horiz, Gef=Gef_inclin@GefI$G/1000)
    }

    horiz$G0 <- horiz$G0/1000
  }

  if(int_entrada=="DIARIO"){
    bd <- df2Meteo(horiz, lat=lat, format='%Y-%m-%d')
    #Crea objeto Gef para datos diarios
    if(iS!=0){
      Gef_inclin <- calcGef(lat=lat,
                            modeTrk='fixed',
                            modeRad='bd',
                            dataRad=bd,
                            beta=beta, alfa=alfa, iS=iS)
      horiz <- mutate(horiz, Gef=Gef_inclin@GefD$Gefd/1000)
    }
    if(iS==0){
      Gef_inclin <- calcGef(lat=lat,
                            modeTrk='fixed',
                            modeRad='bd',
                            dataRad=bd,
                            beta=beta, alfa=alfa)
      horiz <- mutate(horiz, Gef=Gef_inclin@GefD$Gd/1000)
    }
    horiz$G0 <- horiz$G0/1000
  }

  if(int_entrada=="MENSUAL"){
    bd <- readG0dm(G0dm = horiz$G0, Ta = horiz$Ta, lat = lat,
                   year = year)
    #Crea objeto Gef para datos mensuales
    if(iS!=0){
      Gef_inclin <- calcGef(lat=lat,
                            modeTrk='fixed',
                            modeRad='bd',
                            dataRad=bd,
                            beta=beta, alfa=alfa, iS=iS)
      horiz <- mutate(horiz, Gef=Gef_inclin@Gefdm$Gefd)
    }
    if(iS==0){
      Gef_inclin <- calcGef(lat=lat,
                            modeTrk='fixed',
                            modeRad='bd',
                            dataRad=bd,
                            beta=beta, alfa=alfa)
      horiz <- mutate(horiz, Gef=Gef_inclin@Gefdm$Gd)
    }
    horiz$G0 <- horiz$G0/1000
  }

  xts.horiz <- xts(data.frame(G0=horiz$G0, Ta=horiz$Ta, Gef=horiz$Gef), order.by = horiz$date)

  return(xts.horiz)
}
