#' @name info_huecos
#' @title Devuelve data.frame con cantidad de datos por intervalo de tiempo
#' @description Devuelve data.frame con cantidad de datos del xts segmentado por intervalo de tiempo,
#' indicando si existen huecos y detallando su cantidad y longitud.
#' @param xts Objeto xts a examinar.
#' @return data.frame con dos columnas: \itemize{
##'  \item{"dif": }{contiene todos los intervalos de tiempo (en minutos) entre datos, incluyendo el estándar. Si
##'  solo hay una fila, quiere decir que no hay huecos.}
##'  \item{"cant": }{cantidad de datos faltantes (huecos) del intervalo de tiempo correspondiente.}
##'  }
#' @author Daniel G. Paniagua
#' @example /tools/ej_info_huecos.R
#' @export


info_huecos <- function(xts){
  # library(xts)

  huecos <- data.frame(dif=as.numeric(diff(index(xts)), units='mins'), cant=1) %>% group_by(dif) %>% summarise(cant = sum(cant))

  return(huecos)
}

