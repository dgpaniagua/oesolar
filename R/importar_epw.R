#' @name importar_epw
#' @title Importa datos de radiación y temperatura de archivo meteorológico epw
#' @description Importa datos de radiación solar global en el plano horizontal y
#' de temperatura de un archivo epw.
#' @param rutaepw Cadena de caracteres con ruta del archivo epw.
#' @return Un objeto xts con dos columnas: \itemize{
##'  \item{G0: }{Radiación solar global en el plano horizontal (kWh/m2)}
##'  \item{Ta: }{Temperatura media (ºC)}
##' }
#' @details La función debe asignar un año a los datos, ya que en un archivo epw
#' los datos de los distintos meses generalmente corresponden a distintos años no
#' consecutivos. El año es asignado por el método "data()" de la clase
#' Epw (ver \link[eplusr]{Epw}), que tiene en cuenta no generar errores por años bisiestos.
#' Si bien el método permite asignar el año, se prefiere no hacerlo para no generar
#' este tipo de errores. Puede suceder que quede un dato correspondiente al año siguiente,
#' Esto es porque la hora del dato siempre corresponde a la correspondiente al fin del
#' intervalo de tiempo, generando un dato del año siguiente a las cero horas.
#' \cr. Por otra parte, la hora en el índice del objeto xts devuelto incluye el huso horario
#' contenido en el archivo epw.
#' @author Daniel G. Paniagua
#' @references \itemize{
##'  \item{}{Jia H (2020). eplusr: A Toolkit for Using EnergyPlus in R.
##'  R package version 0.12.0, https://CRAN.R-project.org/package=eplusr.}
##' }
#' @example /tools/ej_importar_epw.R
#' @export

importar_epw <- function(rutaepw){

  # library(eplusr)
  # library(xts)
  # library(dplyr)
  # library(lubridate)

  epw <- read_epw(rutaepw)
  data <- epw$data()
  location <- epw$location()
  time_zone <- location$time_zone
  rad <- select(data, date=datetime, G0=global_horizontal_radiation,
                Ta=dry_bulb_temperature)
  rad$date <- force_tz(rad$date, tzone=case_when(time_zone==0 ~ "UTC",
                                                 time_zone==-1 ~ "Etc/GMT+1",
                                                 time_zone==-2 ~ "Etc/GMT+2",
                                                 time_zone==-3 ~ "Etc/GMT+3",
                                                 time_zone==-4 ~ "Etc/GMT+4",
                                                 time_zone==-5 ~ "Etc/GMT+5",
                                                 time_zone==-6 ~ "Etc/GMT+6",
                                                 time_zone==-7 ~ "Etc/GMT+7",
                                                 time_zone==-8 ~ "Etc/GMT+8",
                                                 time_zone==-9 ~ "Etc/GMT+9",
                                                 time_zone==-10 ~ "Etc/GMT+10",
                                                 time_zone==-11 ~ "Etc/GMT+11",
                                                 time_zone==-12 ~ "Etc/GMT+12",
                                                 time_zone==+1 ~ "Etc/GMT-1",
                                                 time_zone==+2 ~ "Etc/GMT-2",
                                                 time_zone==+3 ~ "Etc/GMT-3",
                                                 time_zone==+4 ~ "Etc/GMT-4",
                                                 time_zone==+5 ~ "Etc/GMT-5",
                                                 time_zone==+6 ~ "Etc/GMT-6",
                                                 time_zone==+7 ~ "Etc/GMT-7",
                                                 time_zone==+8 ~ "Etc/GMT-8",
                                                 time_zone==+9 ~ "Etc/GMT-9",
                                                 time_zone==+10 ~ "Etc/GMT-10",
                                                 time_zone==+11 ~ "Etc/GMT-11",
                                                 time_zone==+12 ~ "Etc/GMT-12",
                                                 time_zone==+13 ~ "Etc/GMT-13",
                                                 time_zone==+14 ~ "Etc/GMT-14"))
  rad$G0 <- rad$G0/1000

  xts.rad <- xts(data.frame(G0=rad$G0, Ta=rad$Ta), order.by = rad$date)

  return(xts.rad)
}
