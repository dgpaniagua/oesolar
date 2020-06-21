#' @name rellena_huecos
#' @title Rellena huecos de datos faltantes en xts con datos de energía
#' @description Rellena huecos de datos faltantes en xts con datos de energía cada 15 minutos o cada 1 hora.
#' @param xts Objeto xts con datos de energía a rellenar. La columna con los datos debe llamarse "energia".
#' @param int_entrada Cadena de caracteres. "15MIN" O "HORA". Corresponde al
#' intervalo de tiempo entre los datos de entrada. No utilizar datos que mezclen estos valores.
#' @param na Cadena de caracteres. "CERO" o "INTERPOLAR", según cómo se quieran rellenar
#' los huecos: \itemize{
##'  \item{"CERO": }{rellena todos los huecos con ceros.}
##'  \item{"INTERPOLAR": }{ rellena huecos interpolando los datos faltantes con los datos anterior y posterior al hueco.
##'  Si \code{consumo=TRUE}, interpola para todos los horarios. Si \code{consumo=FALSE}, interpola en horarios diurnos
##'  y completa con cero en horarios nocturnos.}
##'  }
#' @param consumo Lógico. TRUE si los datos son de consumo. Si es FALSE (cuando los datos son de generación),
#' la interpolación para NA en horario nocturno no se hace y se completa con ceros.
#' @param indicar_na Lógico. Si es TRUE, los datos agregados se identifican con un "1" en una columna adicional
#' llamada "rellenado".
#' @return xts estrictamente regular según el intervalo de tiempo ingresado en \code{int_entrada}.
#' @author Daniel G. Paniagua
#' @example /tools/ej_rellena_huecos.R
#' @export

rellena_huecos <- function(xts, int_entrada="HORA", na="INTERPOLAR",
                           consumo=FALSE, indicar_na=FALSE){

  # library(zoo)
  # library(dplyr)
  # library(xts)

  ######CREA XTS ESTRICTAMENTE REGULAR#####
  #Crea xts estrictamente regular completando faltantes con NA
  if(int_entrada=="HORA"){
    xts.gen_data_com <- merge(xts, as.xts(seq(first(index(xts)),
                                              last(index(xts)),
                                              by="hour")))
  }
  if(int_entrada=="15MIN"){
    xts.gen_data_com <- merge(xts, as.xts(seq(first(index(xts)),
                                              last(index(xts)),
                                              by="15 mins")))
  }

  ##Reemplaza NA
  ###Si está habilitado el parámentro, agrega columna indicando cual se rellenó
  if(indicar_na){
    xts.gen_data_com$interpolado <- case_when(is.na(xts.gen_data_com$energia) ~ 1,
                                              !is.na(xts.gen_data_com$energia) ~ 0)
  }

  if(na=="CERO"){
    #Reemplaza NA en la columna energía con ceros
    xts.gen_data_com$energia <- na.fill(xts.gen_data_com$energia, c(0,0,0))
  }
  if(na=="INTERPOLAR"){
    if(!consumo){
      #Reemplaza NA en la columna energía entre los horarios de 0 a 6 (inclusive) con ceros (noche)
      xts.gen_data_com$energia <- na.fill(xts.gen_data_com$energia, c(0,0,0), ix = !is.na(xts.gen_data_com$energia) | between(as.POSIXlt(index(xts.gen_data_com))$hour, 7, 23))
      #Reemplaza NA en la columna energía interpolando con los valores anterior y posterior no-NA.
      xts.gen_data_com$energia <- na.approx(xts.gen_data_com$energia)
    }
    if(consumo){
      #Reemplaza NA en la columna energía interpolando con los valores anterior y posterior no-NA.
      xts.gen_data_com$energia <- na.approx(xts.gen_data_com$energia)
    }
  }

  return(xts.gen_data_com)
}
