#' @name descarga_optimum
#' @title Descarga datos de medidores de energía de Optimum
#' @description Descarga datos de medidores de energía de Optimum (Armstrong) y los devuelve como data.frame.
#' @param usuario Cadena de caracteres. Nombre de usuario para login en Optimum.
#' @param password Cadena de caracteres. Contraseña para login en Optimum.
#' @param medidores Cadena de caracteres.Se puede ingresar el nombre de alguno de los grupos predefinidos
#' que se detallan a continuación. En caso de no querer descargar ninguno de estos grupos predefinidos, se puede
#' detallar una cadena con el/los número/s de medidor/es con una coma delante.
#' \cr Por ejemplo: ',CIR0141437453,CIR0141449390,CIR0141449501'. \cr Los grupos predefinidos son: \itemize{
##'  \item{medidores="TODOS":}{ Todos los medidores Circutor de Optimum. Son 263 medidores. Todos se descargan del
##'  canal "Active Import Inc - 0", excepto la planta de piso y un medidor de generación cada una hora (ver detalle en siguientes ítems).}
##'  \item{medidores="GEN15MIN":}{ Corresponde a 6 medidores de generación con datos cada 15 minutos. Todos en
##'  canal "Active Import Inc - 0". }
##'  \item{medidores="GEN1HORA":}{ Corresponde a 5 medidores de generación con datos cada 1 hora con datos en
##'  canal "Active Import Inc - 0" y a uno (CIR0141668286) con datos en canal 'Active Export Inc - 0'. }
##'  \item{medidores="DEM15MIN":}{ Corresponde a 230 medidores de consumo con datos cada 15 minutos. Todos los datos
##'   en se descargan de canal "Active Import Inc - 0" (hasta actual estado de depuración). }
##'  \item{medidores="DEM1HORA":}{ Corresponde a 20 medidores de consumo con datos cada 1 hora. Todos los datos
##'   en se descargan de canal "Active Import Inc - 0" (hasta actual estado de depuración). }
##'  \item{medidores="PLANTAPISO":}{ Corresponde a datos de la planta de piso, los datos están
##'  en canal "Sum Li Active Power + (QI+QIV) (time integral 5) - 0".}}
#' @param fecha_inicio Cadena de caracteres. Fecha de inicio de los datos a descargar, en formato "YYYY-MM-DD".
#' @param fecha_fin Cadena de caracteres. Fecha final de los datos a descargar, en formato "YYYY-MM-DD".
#' @param channel Cadena de caracteres. Canal del medidor que contiene los datos a descargar. Los más utilizados son:
#' "Active Import Inc - 0" (la mayoría está en este canal), 'Active Export Inc - 0', "Sum Li Active Power + (QI+QIV) (time integral 5) - 0"
#' (solo planta de piso). Ver detalle en descripción de parámetro "medidores".
#' @return data.frame con los datos descargados, con la misma disposición que la tabla descargada desde la web de Optimum.
#' @author Daniel G. Paniagua
#' @example /tools/ej_descarga_optimum.R
#' @export

descarga_optimum <- function(usuario, password,
                             medidores="GEN1HORA", fecha_inicio="2019-01-01",
                             fecha_fin="2019-01-02", channel="Active Import Inc - 0"){

  # library(reticulate)
  # library(dplyr)

  py_file <- system.file("extdata", "descarga_optimumR_v1.py", package = "OESolar")
  py_run_file(py_file)
  descarga_optimumR <- py$descarga_optimumR

  if(medidores!="TODOS" & medidores!="GEN15MIN" & medidores!="GEN1HORA" & medidores!="DEM15MIN" & medidores!="DEM1HORA" & medidores!="PLANTAPISO"){
    datos <- descarga_optimumR(usuario=usuario, password=password, medidores=medidores,
                               fecha_inicio=fecha_inicio, fecha_fin=fecha_fin, channel=channel)
  }

  #Grupos de medidores predefinidos
  if(medidores=="TODOS"){
    ###DECLARACIÓN DE MEDIDORES
    gen_15min_6 <- ',CIR0141437451,CIR0141437454,CIR0141449346,CIR0141449576,CIR0141452066,CIR0141452067'
    gen_1hora_5 <- ',CIR0141437453,CIR0141449390,CIR0141449501,CIR0141613281,CIR0141668285'
    gen_1hora_1exp <- ',CIR0141668286'
    dem_15min_230 <- c(',CIR0141232342,CIR0141449301,CIR0141449302,CIR0141449303,CIR0141449304,CIR0141449305,CIR0141449306,CIR0141449307,CIR0141449308,CIR0141449309',
                       ',CIR0141449310,CIR0141449311,CIR0141449312,CIR0141449314,CIR0141449315,CIR0141449316,CIR0141449317,CIR0141449318,CIR0141449319,CIR0141449320',
                       ',CIR0141449321,CIR0141449322,CIR0141449323,CIR0141449324,CIR0141449325,CIR0141449326,CIR0141449327,CIR0141449328,CIR0141449329,CIR0141449331',
                       ',CIR0141449332,CIR0141449333,CIR0141449334,CIR0141449335,CIR0141449336,CIR0141449337,CIR0141449338,CIR0141449339,CIR0141449340,CIR0141449341',
                       ',CIR0141449342,CIR0141449343,CIR0141449344,CIR0141449345,CIR0141449347,CIR0141449362,CIR0141449363,CIR0141449364,CIR0141449366,CIR0141449367',
                       ',CIR0141449381,CIR0141449382,CIR0141449383,CIR0141449384,CIR0141449385,CIR0141449386,CIR0141449387,CIR0141449388,CIR0141449389,CIR0141449391',
                       ',CIR0141449392,CIR0141449393,CIR0141449395,CIR0141449396,CIR0141449397,CIR0141449398,CIR0141449399,CIR0141449400,CIR0141449401,CIR0141449402',
                       ',CIR0141449403,CIR0141449404,CIR0141449405,CIR0141449406,CIR0141449407,CIR0141449408,CIR0141449409,CIR0141449410,CIR0141449411,CIR0141449412',
                       ',CIR0141449413,CIR0141449416,CIR0141449417,CIR0141449418,CIR0141449419,CIR0141449420,CIR0141449421,CIR0141449422,CIR0141449423,CIR0141449424',
                       ',CIR0141449425,CIR0141449426,CIR0141449427,CIR0141449428,CIR0141449430,CIR0141449431,CIR0141449432,CIR0141449433,CIR0141449434,CIR0141449435',
                       ',CIR0141449436,CIR0141449437,CIR0141449438,CIR0141449439,CIR0141449440,CIR0141449441,CIR0141449442,CIR0141449443,CIR0141449444,CIR0141449445',
                       ',CIR0141449446,CIR0141449447,CIR0141449448,CIR0141449449,CIR0141449450,CIR0141449461,CIR0141449462,CIR0141449463,CIR0141449464,CIR0141449465',
                       ',CIR0141449466,CIR0141449467,CIR0141449468,CIR0141449469,CIR0141449470,CIR0141449481,CIR0141449482,CIR0141449483,CIR0141449484,CIR0141449485',
                       ',CIR0141449486,CIR0141449487,CIR0141449488,CIR0141449489,CIR0141449490,CIR0141449491,CIR0141449492,CIR0141449493,CIR0141449494,CIR0141449495',
                       ',CIR0141449496,CIR0141449497,CIR0141449498,CIR0141449499,CIR0141449500,CIR0141449502,CIR0141449503,CIR0141449504,CIR0141449505,CIR0141449508',
                       ',CIR0141449509,CIR0141449510,CIR0141449511,CIR0141449512,CIR0141449513,CIR0141449514,CIR0141449515,CIR0141449516,CIR0141449517,CIR0141449518',
                       ',CIR0141449519,CIR0141449520,CIR0141449521,CIR0141449523,CIR0141449524,CIR0141449525,CIR0141449526,CIR0141449527,CIR0141449528,CIR0141449529',
                       ',CIR0141449530,CIR0141449541,CIR0141449542,CIR0141449543,CIR0141449544,CIR0141449545,CIR0141449546,CIR0141449547,CIR0141449548,CIR0141449549',
                       ',CIR0141449562,CIR0141449563,CIR0141449564,CIR0141449565,CIR0141449566,CIR0141449567,CIR0141449568,CIR0141449569,CIR0141449570,CIR0141449577',
                       ',CIR0141449578,CIR0141449580,CIR0141449591,CIR0141449593,CIR0141449594,CIR0141449595,CIR0141449597,CIR0141449598,CIR0141449599,CIR0141449600',
                       ',CIR0501409765,CIR0501409766,CIR0501409767,CIR0501409768,CIR0501409769,CIR0501409770,CIR0501409771,CIR0501409772,CIR0501409774,CIR0501409775',
                       ',CIR0501409776,CIR0501409777,CIR0501409778,CIR0501409779,CIR0501409780,CIR0501409781,CIR0501409782,CIR0501409789,CIR0501409790,CIR0501409791',
                       ',CIR0501409793,CIR0501409794,CIR0501409795,CIR0501409796,CIR0501409801,CIR0501409802,CIR0501409805,CIR0501409807,CIR0501409809,CIR0501409811')
    dem_1hora_20 <- c(',CIR0141449348,CIR0141449349,CIR0141449350,CIR0141449361,CIR0141449365,CIR0141449368,CIR0141449369,CIR0141449370,CIR0141449414,CIR0141449415',
                      ',CIR0141449429,CIR0141449522,CIR0141449571,CIR0141449572,CIR0141449573,CIR0141449574,CIR0141449575,CIR0141449592,CIR0501409783,CIR0501409804')
    planta_piso_1 <- ',65010158'

    ###1.GEN15MIN
    medidores <- gen_15min_6
    datos1 <- descarga_optimumR(usuario=usuario, password=password, medidores=medidores,
                               fecha_inicio=fecha_inicio, fecha_fin=fecha_fin, channel=channel)

    ###2-3.GEN1HORA
    medidores <- gen_1hora_5
    datos2 <- descarga_optimumR(usuario=usuario, password=password, medidores=medidores,
                               fecha_inicio=fecha_inicio, fecha_fin=fecha_fin, channel=channel)

    medidores <- gen_1hora_1exp
    datos3 <- descarga_optimumR(usuario=usuario, password=password, medidores=medidores,
                                fecha_inicio=fecha_inicio, fecha_fin=fecha_fin, channel='Active Export Inc - 0')

    ###4.DEM15MIN
    medidores <- dem_15min_230[1]
    datos4 <- descarga_optimumR(usuario=usuario, password=password, medidores=medidores,
                               fecha_inicio=fecha_inicio, fecha_fin=fecha_fin, channel=channel)
    for(i in 2:length(dem_15min_230)){
      medidores <- dem_15min_230[i]
      datos4_1 <- descarga_optimumR(usuario=usuario, password=password, medidores=medidores,
                                  fecha_inicio=fecha_inicio, fecha_fin=fecha_fin, channel=channel)
      datos4 <- rbind(datos4, datos4_1)
    }

    ###5.DEM1HORA
    medidores <- dem_1hora_20[1]
    datos5 <- descarga_optimumR(usuario=usuario, password=password, medidores=medidores,
                               fecha_inicio=fecha_inicio, fecha_fin=fecha_fin, channel=channel)
    medidores <- dem_1hora_20[2]
    datos5_1 <- descarga_optimumR(usuario=usuario, password=password, medidores=medidores,
                                fecha_inicio=fecha_inicio, fecha_fin=fecha_fin, channel=channel)
    datos5 <- rbind(datos5, datos5_1)

    ###6.PLANTAPISO
    medidores <- planta_piso_1
    datos6 <- descarga_optimumR(usuario=usuario, password=password, medidores=medidores,
                               fecha_inicio=fecha_inicio, fecha_fin=fecha_fin, channel="Sum Li Active Power + (QI+QIV) (time integral 5) - 0")


    datos <- rbind(datos1, datos2, datos3, datos4, datos5, datos6)
  }

  if(medidores=="GEN15MIN"){
    gen_15min_6 <- ',CIR0141437451,CIR0141437454,CIR0141449346,CIR0141449576,CIR0141452066,CIR0141452067'

    medidores <- gen_15min_6
    datos <- descarga_optimumR(usuario=usuario, password=password, medidores=medidores,
                               fecha_inicio=fecha_inicio, fecha_fin=fecha_fin, channel=channel)
  }

  if(medidores=="GEN1HORA"){
    gen_1hora_5 <- ',CIR0141437453,CIR0141449390,CIR0141449501,CIR0141613281,CIR0141668285'
    gen_1hora_1exp <- ',CIR0141668286'

    medidores <- gen_1hora_5
    datos <- descarga_optimumR(usuario=usuario, password=password, medidores=medidores,
                               fecha_inicio=fecha_inicio, fecha_fin=fecha_fin, channel=channel)

    medidores <- gen_1hora_1exp
    datos1 <- descarga_optimumR(usuario=usuario, password=password, medidores=medidores,
                               fecha_inicio=fecha_inicio, fecha_fin=fecha_fin, channel='Active Export Inc - 0')

    datos <- rbind(datos, datos1)
  }

  if(medidores=="DEM15MIN"){
    dem_15min_230 <- c(',CIR0141232342,CIR0141449301,CIR0141449302,CIR0141449303,CIR0141449304,CIR0141449305,CIR0141449306,CIR0141449307,CIR0141449308,CIR0141449309',
                   ',CIR0141449310,CIR0141449311,CIR0141449312,CIR0141449314,CIR0141449315,CIR0141449316,CIR0141449317,CIR0141449318,CIR0141449319,CIR0141449320',
                   ',CIR0141449321,CIR0141449322,CIR0141449323,CIR0141449324,CIR0141449325,CIR0141449326,CIR0141449327,CIR0141449328,CIR0141449329,CIR0141449331',
                   ',CIR0141449332,CIR0141449333,CIR0141449334,CIR0141449335,CIR0141449336,CIR0141449337,CIR0141449338,CIR0141449339,CIR0141449340,CIR0141449341',
                   ',CIR0141449342,CIR0141449343,CIR0141449344,CIR0141449345,CIR0141449347,CIR0141449362,CIR0141449363,CIR0141449364,CIR0141449366,CIR0141449367',
                   ',CIR0141449381,CIR0141449382,CIR0141449383,CIR0141449384,CIR0141449385,CIR0141449386,CIR0141449387,CIR0141449388,CIR0141449389,CIR0141449391',
                   ',CIR0141449392,CIR0141449393,CIR0141449395,CIR0141449396,CIR0141449397,CIR0141449398,CIR0141449399,CIR0141449400,CIR0141449401,CIR0141449402',
                   ',CIR0141449403,CIR0141449404,CIR0141449405,CIR0141449406,CIR0141449407,CIR0141449408,CIR0141449409,CIR0141449410,CIR0141449411,CIR0141449412',
                   ',CIR0141449413,CIR0141449416,CIR0141449417,CIR0141449418,CIR0141449419,CIR0141449420,CIR0141449421,CIR0141449422,CIR0141449423,CIR0141449424',
                   ',CIR0141449425,CIR0141449426,CIR0141449427,CIR0141449428,CIR0141449430,CIR0141449431,CIR0141449432,CIR0141449433,CIR0141449434,CIR0141449435',
                   ',CIR0141449436,CIR0141449437,CIR0141449438,CIR0141449439,CIR0141449440,CIR0141449441,CIR0141449442,CIR0141449443,CIR0141449444,CIR0141449445',
                   ',CIR0141449446,CIR0141449447,CIR0141449448,CIR0141449449,CIR0141449450,CIR0141449461,CIR0141449462,CIR0141449463,CIR0141449464,CIR0141449465',
                   ',CIR0141449466,CIR0141449467,CIR0141449468,CIR0141449469,CIR0141449470,CIR0141449481,CIR0141449482,CIR0141449483,CIR0141449484,CIR0141449485',
                   ',CIR0141449486,CIR0141449487,CIR0141449488,CIR0141449489,CIR0141449490,CIR0141449491,CIR0141449492,CIR0141449493,CIR0141449494,CIR0141449495',
                   ',CIR0141449496,CIR0141449497,CIR0141449498,CIR0141449499,CIR0141449500,CIR0141449502,CIR0141449503,CIR0141449504,CIR0141449505,CIR0141449508',
                   ',CIR0141449509,CIR0141449510,CIR0141449511,CIR0141449512,CIR0141449513,CIR0141449514,CIR0141449515,CIR0141449516,CIR0141449517,CIR0141449518',
                   ',CIR0141449519,CIR0141449520,CIR0141449521,CIR0141449523,CIR0141449524,CIR0141449525,CIR0141449526,CIR0141449527,CIR0141449528,CIR0141449529',
                   ',CIR0141449530,CIR0141449541,CIR0141449542,CIR0141449543,CIR0141449544,CIR0141449545,CIR0141449546,CIR0141449547,CIR0141449548,CIR0141449549',
                   ',CIR0141449562,CIR0141449563,CIR0141449564,CIR0141449565,CIR0141449566,CIR0141449567,CIR0141449568,CIR0141449569,CIR0141449570,CIR0141449577',
                   ',CIR0141449578,CIR0141449580,CIR0141449591,CIR0141449593,CIR0141449594,CIR0141449595,CIR0141449597,CIR0141449598,CIR0141449599,CIR0141449600',
                   ',CIR0501409765,CIR0501409766,CIR0501409767,CIR0501409768,CIR0501409769,CIR0501409770,CIR0501409771,CIR0501409772,CIR0501409774,CIR0501409775',
                   ',CIR0501409776,CIR0501409777,CIR0501409778,CIR0501409779,CIR0501409780,CIR0501409781,CIR0501409782,CIR0501409789,CIR0501409790,CIR0501409791',
                   ',CIR0501409793,CIR0501409794,CIR0501409795,CIR0501409796,CIR0501409801,CIR0501409802,CIR0501409805,CIR0501409807,CIR0501409809,CIR0501409811')

    medidores <- dem_15min_230[1]
    datos <- descarga_optimumR(usuario=usuario, password=password, medidores=medidores,
                               fecha_inicio=fecha_inicio, fecha_fin=fecha_fin, channel=channel)
    for(i in 2:length(dem_15min_230)){
      medidores <- dem_15min_230[i]
      datos1 <- descarga_optimumR(usuario=usuario, password=password, medidores=medidores,
                                 fecha_inicio=fecha_inicio, fecha_fin=fecha_fin, channel=channel)
      datos <- rbind(datos, datos1)
    }
  }

  if(medidores=="DEM1HORA"){
    dem_1hora_20 <- c(',CIR0141449348,CIR0141449349,CIR0141449350,CIR0141449361,CIR0141449365,CIR0141449368,CIR0141449369,CIR0141449370,CIR0141449414,CIR0141449415',
                      ',CIR0141449429,CIR0141449522,CIR0141449571,CIR0141449572,CIR0141449573,CIR0141449574,CIR0141449575,CIR0141449592,CIR0501409783,CIR0501409804')

    medidores <- dem_1hora_20[1]
    datos <- descarga_optimumR(usuario=usuario, password=password, medidores=medidores,
                               fecha_inicio=fecha_inicio, fecha_fin=fecha_fin, channel=channel)
    medidores <- dem_1hora_20[2]
    datos1 <- descarga_optimumR(usuario=usuario, password=password, medidores=medidores,
                               fecha_inicio=fecha_inicio, fecha_fin=fecha_fin, channel=channel)
    datos <- rbind(datos, datos1)
  }

  if(medidores=="PLANTAPISO"){
    planta_piso_1 <- ',65010158'

    medidores <- planta_piso_1
    datos <- descarga_optimumR(usuario=usuario, password=password, medidores=medidores,
                               fecha_inicio=fecha_inicio, fecha_fin=fecha_fin, channel="Sum Li Active Power + (QI+QIV) (time integral 5) - 0")
  }

  names(datos) <- c("medidor", "punto_med", "canal", "fecha", "energia", "unidad", "log", "tipo lectura")
  datos <- datos[order(datos$medidor, datos$fecha),]
  return(datos)
}
