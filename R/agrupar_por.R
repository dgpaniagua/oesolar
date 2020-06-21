#' @name agrupar_por
#' @title Agrupa datos de objeto xts según intervalo de tiempo dado
#' @description Agrupa datos de objeto xts según intervalo de tiempo dado. El intervalo de tiempo de los datos del
#' xts de salida pueden ser cada una hora "HORA", cada un día "DIARIO" o cada un mes "MENSUAL". El intervalo
#' de datos del xts de entrada debe ser menor que el de salida. Por ejemplo, se puede pasar de datos cada
#' 15 minutos a datos cada una hora, o de datos cada un día a datos cada un mes.
#' @param xts xts de entrada. La columna de datos a agrupar debe llamarse "energia".
#' @param int_salida Cadena de caracteres para especificar el nuevo intervalo de tiempo entre datos.
#' Puede ser: "HORA", "DIARIO", "MENSUAL", según lo detallado en la descripción de la función
#' @return xts con los datos agrupados según el nuevo intervalo de tiempo, con una sola columna llamada "energia".
#' @author Daniel G. Paniagua
#' @example /tools/ej_agrupar_por.R
#' @export

#Crea objeto xts con datos por hora
agrupar_por <- function(xts, int_salida="MENSUAL") {

  # library(xts)

  if(int_salida=="HORA"){
    ep <- endpoints(xts, 'hours') + 1
    ep[length(ep)] <- ep[length(ep)]-1
    xts <- period.apply(xts$energia, ep, sum)
    names(xts[1]) <- "energia"
  }

  if(int_salida=="DIARIO"){
    xts <- xts(aggregate(xts$energia, as.Date, sum))
    names(xts[1]) <- "energia"
  }

  if(int_salida=="MENSUAL"){
    xts <- xts(aggregate(xts$energia, as.yearmon, sum))
    names(xts[1]) <- "energia"
  }


  return(xts)
}

