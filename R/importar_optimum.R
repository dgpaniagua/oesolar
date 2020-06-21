#' @name importar_optimum
#' @title Importa y descarga datos de generación de energía de Optimum
#' @description Importa datos de generación de energía del sistema Optimum, descargándolos directamente, de archivos
#' en formato csv o xls/xlsx descargados desde la web, o de data.frame devuelto por descarga_optimum().
#' @param file Cadena de caracteres, data.frame o NULL. Ruta del archivo a importar o nombre del data.frame.
#' Puede ser xls, xlsx o csv. Para csv, el caracter separador debe ser coma. Para descargar datos directamente
#' de Optimum debe ser NULL (por defecto).
#' @param usuario Cadena de caracteres. Nombre de usuario para login en Optimum. Solo se utiliza si los
#' datos se descargan directamente de Optimum. Parámetro de \link[OESolar]{descarga_optimum}.
#' @param password Cadena de caracteres. Contraseña para login en Optimum. Solo se utiliza si los
#' datos se descargan directamente de Optimum. Parámetro de \link[OESolar]{descarga_optimum}.
#' @param medidores Ver detalles en \link[OESolar]{descarga_optimum}.
#' @param fecha_inicio Cadena de caracteres. Fecha de inicio de los datos a descargar, en formato "YYYY-MM-DD". Solo se utiliza si los
#' datos se descargan directamente de Optimum. Parámetro de \link[OESolar]{descarga_optimum}.
#' @param fecha_fin Cadena de caracteres. Fecha final de los datos a descargar, en formato "YYYY-MM-DD". Solo se utiliza si los
#' datos se descargan directamente de Optimum. Parámetro de \link[OESolar]{descarga_optimum}.
#' @param channel Cadena de caracteres. Canal del medidor que contiene los datos a descargar. Solo se utiliza si los
#' datos se descargan directamente de Optimum. Parámetro de \link[OESolar]{descarga_optimum}.
#' @param int_entrada Cadena de caracteres. "15MIN" u "HORA". Corresponde al
#' intervalo de tiempo entre los datos de entrada. No utilizar datos que mezclen estos valores.
#' @param int_salida Cadena de caracteres. "15MIN", "HORA", "DIARIO" o "MENSUAL". Corresponde al
#' intervalo de tiempo entre los datos que se desee para el objeto xts de salida.
#' @param na Cadena de caracteres. NULL, "CERO" o "INTERPOLAR", según cómo se quieran rellenar
#' los huecos: \itemize{
##'  \item{NULL: }{no se rellenan los huecos.}
##'  \item{"CERO": }{rellena todos los huecos con ceros.}
##'  \item{"INTERPOLAR": }{ rellena huecos interpolando los datos faltantes con los datos anterior y posterior al hueco.
##'  Si \code{consumo=TRUE}, interpola para todos los horarios. Si \code{consumo=FALSE}, interpola en horarios diurnos
##'  y completa con cero en horarios nocturnos.}
##'  }
#' @param mult_us Lógico. Si es TRUE, los datos a importar corresponden a más de un usuario.
#' @param consumo Lógico. TRUE si los datos son de consumo. Si es FALSE (cuando los datos son de generación),
#' la interpolación para NA en horario nocturno no se hace y se completa con ceros.
#' @param indicar_na Lógico. Si es TRUE, los datos agregados se identifican con un "1" en una columna adicional
#' llamada "rellenado".
#' @return \itemize{
##'  \item{Si mult_us=FALSE: }{Un objeto xts con la fecha como índice y el valor de energía en el campo "energia"}
##'  \item{Si mult_us=TRUE: }{Un objeto "list" cuyos elementos son "xts" como los descriptos en ítem anterior
##'  y cada uno corresponde a un usuario distinto}
##'  }
#' @author Daniel G. Paniagua
#' @example /tools/ej_importar_optimum.R
#' @export

importar_optimum <- function(file=NULL, usuario, password,
                             medidores="GEN1HORA", fecha_inicio="2019-01-01",
                             fecha_fin="2019-01-02", channel="Active Import Inc - 0",
                             int_entrada="HORA", int_salida=NULL, na="INTERPOLAR",
                             mult_us=FALSE, consumo=FALSE, indicar_na=FALSE){

  # #Carga paquetes necesarios
  # library(readxl)
  # library(zoo)
  # library(dplyr)
  # library(xts)
  # library(tools)
  # library(OESolar)

  ######IMPORTA DATOS POR DESCARGA DIRECTA DE OPTIMUM#####
  if(is.null(file)){
    gen_data <- descarga_optimum(usuario=usuario, password=password, medidores=medidores,
                               fecha_inicio=fecha_inicio, fecha_fin=fecha_fin, channel=channel)
  }

  ######IMPORTA DATOS A PARTIR DE ARCHIVO EXCEL O CVS#####
  if(!is.null(file)){
    #Si no es data.frame, importa archivo
    if(!class(file)=="data.frame"){
      tipo_archivo <- file_ext(file)
      #Crea variable con vector de nombre de columnas de la tabla a importar
      col_names <- c("medidor", "punto_med", "canal", "fecha", "energia", "unidad", "log", "tipo lectura")

      if(tipo_archivo=="xls"|tipo_archivo=="xlsx"){
        #Importa el archivo de Excel. 'skip = 2' es para que saltee las dos primeras filas.
        gen_data <- read_excel(file, skip = 2, col_names = col_names)
      }
      if(tipo_archivo=="csv"){
        #Importa el archivo csv.
        gen_data <- read.csv(file=file, col.names = col_names)
      }
    }
    #Si es data.frame, lo asigna a gen_data
    if(class(file)=="data.frame"){
      gen_data <- file
    }

    #Ordena por medidor y luego por fecha (ya sea data.frame o archivo importado)
    gen_data <- gen_data[order(gen_data$medidor, gen_data$fecha),]
  }

  #####ADAPTA DATOS Y CREA LIST####
  #Pasa la energía a kWh
  gen_data$energia <- as.double(gen_data$energia)
  gen_data <- mutate(gen_data, energia = case_when(unidad=="Wh" ~ energia/1000,
                                                   unidad=="kWh" ~ energia))

  #Toma los nombres de medidores para nombrar elementos de list más adelante
  nombre_medidores <- levels(as.factor(gen_data$medidor))

  #Si el campo "medidor" no es solo numérico, extrae números (xts solo admite números)
  if(is.numeric(gen_data$medidor[1]) == FALSE){
    gen_data$medidor <- as.numeric(gsub("CIR","", gen_data$medidor))
  }

  #Crea objeto "list" con tantos data.frame como usuarios (medidores) haya.
  list.gen_data <- split(gen_data, gen_data$medidor)

  ####CREA OBJETO XTS A PARTIR DE DATA.FRAME####
  #Crea objeto xts, descartando todas las columnas excepto "energia".
  list.xts.gen_data <- lapply(list.gen_data, function(x) {xts(x$energia, order.by = as.POSIXlt(x$fecha))})

  #Nombra a la columna "energia"
  for(i in 1:length(list.xts.gen_data)){
    names(list.xts.gen_data[[i]]) <- "energia"
  }

  #Nombra a cada uno de los xts del list con el nombre de medidores completo (con "CIR0")
  names(list.xts.gen_data) <- nombre_medidores

  ####INTERPOLAR####
  if(!is.null(na)){
    if(na=="INTERPOLAR" | na=="CERO"){
      list.xts.gen_data <- lapply(list.xts.gen_data,
                                  function(x) {rellena_huecos(xts=x, int_entrada=int_entrada,
                                                                na=na, indicar_na=indicar_na,
                                                                consumo=consumo)})
    }
  }

  ####AGRUPAR####
  if(!is.null(int_salida)){
    list.xts.gen_data <- lapply(list.xts.gen_data,
                                function(x) {x <- agrupar_por(xts=x, int_salida=int_salida); x })
  }

  #####SALIR#####
  if(mult_us){
    return(list.xts.gen_data)
  }
  if(!mult_us){
    return(list.xts.gen_data[[1]])
  }
}
