#' @name pr
#' @title Calcula PR a partir de datos de generación real y radiación solar efectiva en el plano del panel
#' @description Calcula PR a partir de datos de generación real y radiación solar efectiva en el plano del panel
#' @param Gef Objeto xts con al menos una columna "Gef" con datos de radiación en el plano del panel FV y
#' otra columna "gen" con datos de generación de energía de ese sistema. Las unidades de ambas columnas
#' se deben corresponder.
#' @param int_entrada Cadena de caracteres. "MENSUAL" o "DIARIO", según lo sean los datos de entrada.
#' @param Pn Numérico. Potencia nominal del sistema en Wp.
#' @param year Numérico. Año al que corresponden los datos.
#' @return El objeto xts original con una columna adicional con el PR.
#' @author Daniel G. Paniagua
#' @references \itemize{
##'  \item{""}{van Sark, Wilfried & Reich, Nils & Müller, Björn & Armbruster, Alfons & Kiefer, Klaus & Reise,
##'  Christian. (2012). Review of PV performance ratio development. 10.13140/2.1.2138.7204. }
##' }
#' @example /tools/ej_pr.R
#' @export

pr <- function(Gef, int_entrada="MENSUAL", Pn=1560, year=as.POSIXlt(Sys.Date())$year+1900-1){

  # library(xts)

  if(int_entrada=="MENSUAL"){
    dias <- as.numeric(diff(seq(as.Date(paste(year,"-01-01", sep='')), as.Date(paste(year+1,"-01-01", sep='')), by = "month")))
    Gef$Gef_mensual <- Gef$Gef*dias
    Gef$PR <- (Gef$gen/Pn)/(Gef$Gef_mensual/1000)
  }

  if(int_entrada=="DIARIO"){
    Gef$PR <- (Gef$gen/Pn)/(Gef$Gef/1000)
  }

  return(Gef)

  }
