#' @name prod_energia
#' @title Calcula la producción de energía de un generador fotovoltaico conectado a red.
#' @description Calcula la producción de energía de un generador fotovoltaico
#' conectado a red a partir de datos de radiación solar global y temperatura media en el plano horizontal
#' y de parámetros característicos de los paneles FV, inversor y otros componentes.
#' Los datos de radiación pueden ser intradiarios, diarios o mensuales.

#' @param G0 xts con dos columnas: "G0" con radiación en el plano horizontal en kW/m² y
#' "Ta" con temperatura media en ºC. Para datos mensuales, el índice de fechas en formato yearmon.
#' Para datos intradiarios, el índice de fechas debe incluir el huso horario correspondiente.
#' Puede ser el resultado de \code{rad_nasa} o \code{importar_epw}.
#' @param int_entrada Cadena de caracteres: "MENSUAL", "DIARIO" o "INTRADIARIO" según corresponda a los
#' datos de radiación y temperatura provistos en GO.
#' @param int_salida Cadena de caracteres: "MENSUAL", "DIARIO" o "INTRADIARIO" según se prefieran los
#' datos de salida de la función. Para \code{int_entrada="MENSUAL"}, los datos de salida intradiarios
#' corresponden a un día por mes (día medio mensual). Ademas, para \code{int_entrada="MENSUAL"}, el
#' objeto xts devuelto para \code{int_salida="MENSUAL"} y para \code{int_salida="DIARIO"} es el mismo.
#' @param lon Numérico. Longitud de la ubicación del lugar en grados. Solo utilizado para datos
#' de entrada intradiarios.
#' @param lat Numérico. Latitud de la ubicación del lugar en grados. Negativo para hemisferio sur.
#' @param beta Numérico. Inclinación del panel en grados.
#' @param alfa Numérico. Azimuth en grados. Para hemisferio norte, el sur es cero, es negativo hacia el este
#' y positivo hacia el oeste. El package solaR no especifica para el hemisferio sur, pero se verificó que el norte es cero.
#' Tomar mismo criterio que para hemisferio norte para este y oeste.
#' @param Pn Numérico. Potencia nominal del sistema en kWp.
#' @param iS Numérico. Grado de suciedad. Su valor  puede ser 0,1,2,3,4. iS=0 no considera el efecto
#' de suciedad y reflexión. iS=1 a iS=4 tiene en cuenta el efecto de suciedad y reflexión, donde
#' iS=1 corresponde a una superficie limpia e iS=4 corresponde a una superficie sucia. El valor por defecto es 2.
#' @param year Numérico. Indicar año al que corresponden los datos.
#' @param modulo Objeto "list". Datos según package solaR: Ver sección "Details" y
#' "Usage" para valores por defecto. Ver además argumento \code{module} en \link[solaR]{prodGCPV}.
#' @param generador Objeto "list". Datos según package solaR. Ver sección "Details" y
#' "Usage" para valores por defecto. Ver además argumento \code{generator} en \link[solaR]{prodGCPV}.
#' @param inversor Objeto "list". Datos según package solaR. Ver sección "Details" y
#' "Usage" para valores por defecto. Ver además argumento \code{inverter} en \link[solaR]{prodGCPV}.
#' @param rendimientos Objeto "list". Datos según package solaR. Ver sección "Details" y
#' "Usage" para valores por defecto. Ver además argumento \code{effSys} en \link[solaR]{prodGCPV}.
#'
#' @details Descripción adicional de parámetros. Elementos de los siguientes objetos "list".\cr
#' \cr modulo (valores por defecto para módulo LV Energy LVE60PS):\itemize{
##'  \item{Vocn: }{open-circuit voltage of the module at Standard Test Conditions (V).}
##'  \item{Iscn: }{short circuit current of the module at Standard Test Conditions (A).}
##'  \item{Vmn: }{maximum power point voltage of the module at Standard Test Conditions (V).}
##'  \item{Imn: }{Maximum power current of the module at Standard Test Conditions (A).}
##'  \item{Ncs: }{number of cells in series inside the module.}
##'  \item{Ncp: }{number of cells in parallel inside the module.}
##'  \item{CoefVT: }{coefficient of decrement of voltage of each cell with the temperature (volts per celsius degree).}
##'  \item{TONC: }{nominal operational cell temperature (ºC).}
##'  }
#'
#' generador (valores por defecto para techos solares PRIER Armstrong):\itemize{
##'  \item{Nms: }{number of modules in series.}
##'  \item{Nmp: }{number of modules in parallel.}
##'  }
#
#' inversor (valores por defecto para inversor SMA SB 1.5):\itemize{
##'  \item{Ki: }{vector of three values, coefficients of the efficiency curve of the inverter (default c(0.0095, 0.015, 0.02),
##'  SMA SB 1.5), or a matrix of nine values (3x3) if there is dependence with the voltage (see references solaR).}
##'  Estos coeficientes corresponden a una función que modela el rendimiento de los inversores. Se pueden ajustar graficando en planilla de cálculos
##'  la tabla de valores que dá el fabricante en la hoja de datos del inversor y la dicha función modificando los coeficientes hasta que
##'  coincidan (es sencillo partiendo de los valores por defecto dados aquí). La función es: n=p0/(p0+k0+k1.p0+k2.p0), donde "n" es
##'  el rendimiento del inversor, p0 es la potencia de salida normalizada en por unidad (eje x de la gráfica) y k0, k1 y k2 son
##'  los tres coeficientes respectivamente (en los valores por defecto: k0=0.0095, k1=0.015 y k2=0.02). Se puede ver
##'  detalle en libro de O. Perpiñan (ver referencias).
##'  \item{Pinv: }{nominal inverter power (W).}
##'  \item{Vmin, Vmax: }{minimum and maximum voltages of the MPP range of the inverter (V).}
##'  \item{Gumb: }{minimum irradiance for the inverter to start (W/m²) (default value 20W/m²).}
##'  }
#'
#' rendimientos (valores por defecto de package solaR ajustados con NREL):\itemize{
##'  \item{ModQual: }{average tolerance of the set of modules (porciento), default value is 3.}
##'  \item{ModDisp: }{module parameter disperssion losses (porciento), default value is 2.}
##'  \item{OhmDC: }{Joule losses due to the DC wiring (porciento), default value is 1.5.}
##'  \item{OhmAC: }{Joule losses due to the AC wiring (porciento), default value is 1.5.}
##'  \item{MPP: }{average error of the MPP algorithm of the inverter (porciento), default value is 1.}
##'  \item{TrafoMT: }{losses due to the MT transformer (porciento), default value is 0.}
##'  \item{Disp: }{losses due to stops of the system (porciento), default value is 0.5.}
##'  }
#'
#' @return Devuelve objeto xts con las columnas detalladas a continuación:\itemize{
##'  \item{Para int_salida="MENSUAL": }{G0dm (kW/m²), Tadm (ºC), Gefdm (o Gdm si iS=0) (kW/m²), Eac_dm (energía producida
##'  en un día en kWh), Eac_m (energía producida en el mes en kWh) y PRdm (PR diario mensual del sistema calculado).}
##'  \item{Para int_salida="DIARIO": }{G0d (kW/m²), Tad (ºC), Gefd (o Gd si iS=0) (kW/m²), Eac_d (energía producida
##'  en un día en kWh) y PRd (PR diario del sistema calculado).}
##'  \item{Para int_salida="INTRADIARIO": }{G0 (kW/m²), Ta (ºC), Gef (o G si iS=0) (kW/m²), Pac (potencia producida
##'  en el intervalo de tiempo en kW) y PR (PR en el intervalo de tiempo del sistema calculado).}
##'  }
#'
#' @author Daniel G. Paniagua
#' @references \itemize{
##'  \item{}{Perpiñán, O, Energía Solar Fotovoltaica, 2015. (http://oscarperpinan.github.io/esf/)}
##'  \item{}{Perpiñán O (2012). “solaR: Solar Radiation and Photovoltaic Systems with R.” Journal
##'  of Statistical Software, 50(9), 1–32. http://www.jstatsoft.org/v50/i09/. }
##'  }
#' @example /tools/ej_prod_energia.R
#' @export

prod_energia <- function(G0, int_entrada="MENSUAL", int_salida="MENSUAL",
                         lon=-62.8, lat=-32.9, beta=30, alfa=0, Pn=1.5, iS = 2,
                         year=as.POSIXlt(Sys.Date())$year+1900-1,
                         modulo=list(Vocn=37.7, Iscn=8.95,
                                     Vmn=30.3, Imn=8.58,
                                     Ncs=60, Ncp=1,
                                     CoefVT=0.00292, TONC=45),
                         generador=list(Nms=6, Nmp=1),
                         inversor=list(Ki=c(0.0095, 0.015, 0.02),
                                       Pinv=1500, Vmin=160, Vmax=500, Gumb=20),
                         rendimientos=list(ModQual=3, ModDisp=2,
                                           OhmDC=1.5, OhmAC=1.5,
                                           MPP=1, TrafoMT=0, Disp=0.5))
  {

  # library(solaR)
  # library(xts)
  # library(dplyr)

  #Acomoda unidad G0 (kW -> W)
  G0$G0 <- G0$G0*1000
  G0$G0 <- na.approx(G0$G0)
  #Crea zoo a partir de xts
  z.G0 <- zoo(G0)
  #Crea data.frame a partir de xts
  df.G0 <- data.frame(date=index(G0), G0=coredata(G0$G0), Ta=coredata(G0$Ta))

  ##########1)DATOS ENTRADA INTRADIARIOS###########
  if(int_entrada=="INTRADIARIO"){

    #####1.1)Cálculo sin considerar pérdidas por reflexión y suciedad####
    if(iS==0){
      G0$G0 <- G0$G0/1000
      G <- rad_inclin(G0, lat=lat, beta=beta, int_entrada=int_entrada, iS=0, year=year)
      G$Gef[is.na(G$Gef)] <- 0 ####REVISAR SEGUN RESPUESTA O.PERPIÑAN (consulta 03/05/2020)
      df.G <- data.frame(date=index(G), G0=coredata(G$G0), Ta=coredata(G$Ta), Gef=coredata(G$Gef))
      df.G$Gef <- df.G$Gef*1000
      prod <- fProd(df.G, module=modulo, generator=generador,
                    inverter=inversor, effSys=rendimientos)

      #Crea xts de salida con datos intradiarios
      prod_intra <- mutate(df.G0, G=as.numeric(G$Gef), Pac=prod$Pac/1000)
      prod_intra <- mutate(prod_intra, PR=prod_intra$Pac/(prod_intra$G*Pn))
      prod_intra$PR[is.na(prod_intra$PR)] <- 0
      xts.prod_intra <- xts(data.frame(G0=prod_intra$G0/1000,
                                       Ta=prod_intra$Ta,
                                       G=prod_intra$G,
                                       Pac=prod_intra$Pac,
                                       PR=prod_intra$PR),
                            order.by = as.POSIXlt(prod_intra$date))

      #Crea xts de salida con datos diarios
      G0d <- aggregate(xts.prod_intra$G0, as.Date, sum)
      Tad <- aggregate(xts.prod_intra$Ta, as.Date, mean)
      Gd <- aggregate(xts.prod_intra$G, as.Date, sum)
      Eac_d <- aggregate(xts.prod_intra$Pac, as.Date, sum)
      xts.prod_dia <- merge(G0d, Tad, Gd, Eac_d)
      xts.prod_dia <- xts(xts.prod_dia)
      xts.prod_dia$PRd <- xts.prod_dia$Eac_d/(xts.prod_dia$Gd*Pn)

      #Crea xts de salida con datos mensuales
      G0dm <- aggregate(xts.prod_dia$G0d, as.yearmon, mean)
      Tadm <- aggregate(xts.prod_dia$Tad, as.yearmon, mean)
      Gdm <- aggregate(xts.prod_dia$Gd, as.yearmon, mean)
      Eac_dm <- aggregate(xts.prod_dia$Eac_d, as.yearmon, mean)
      Eac_m <- aggregate(xts.prod_intra$Pac, as.yearmon, sum)
      xts.prod_mes <- merge(G0dm, Tadm, Gdm, Eac_dm, Eac_m)
      xts.prod_mes <- xts(xts.prod_mes)
      xts.prod_mes$PRdm <- xts.prod_mes$Eac_dm/(xts.prod_mes$Gdm*Pn)

    }
    #####1.2)Cálculo considerando pérdidas por reflexión y suciedad####
    if(iS!=0){
      idx_local <- index(G0)
      idx_solar <- local2Solar(idx_local, lon = lon)
      bd_i <- zoo(coredata(G0), order.by = idx_solar)
      prod <- prodGCPV(lat=lat,
                       modeTrk='fixed',
                       modeRad='bdI',
                       dataRad=bd_i,
                       beta=beta, alfa=alfa, iS=iS,
                       module=modulo,
                       generator=generador,
                       inverter=inversor,
                       effSys=rendimientos)

      #Crea xts de salida con datos intradiarios
      prod_intra <- mutate(df.G0, Gef=prod@GefI$Gef/1000, Pac=prod@prodI$Pac/1000)
      prod_intra$G0 <- prod_intra$G0/1000
      prod_intra$Gef[is.na(prod_intra$Gef)] <- 0 ####REVISAR SEGUN RESPUESTA O.PERPIÑAN (consulta 03/05/2020)
      prod_intra$Pac[is.na(prod_intra$Pac)] <- 0 ####REVISAR SEGUN RESPUESTA O.PERPIÑAN (consulta 03/05/2020)
      prod_intra <- mutate(prod_intra, PR=Pac/(Gef*Pn))
      prod_intra$PR[is.na(prod_intra$PR)] <- 0
      xts.prod_intra <- xts(data.frame(G0=prod_intra$G0,
                                       Ta=prod_intra$Ta,
                                       Gef=prod_intra$Gef,
                                       Pac=prod_intra$Pac,
                                       PR=prod_intra$PR),
                            order.by = as.POSIXlt(prod_intra$date))

      #Crea xts de salida con datos diarios
      G0d <- aggregate(xts.prod_intra$G0, as.Date, sum)
      Tad <- aggregate(xts.prod_intra$Ta, as.Date, mean)
      Gefd <- aggregate(xts.prod_intra$Gef, as.Date, sum)
      Eac_d <- aggregate(xts.prod_intra$Pac, as.Date, sum)
      xts.prod_dia <- merge(G0d, Tad, Gefd, Eac_d)
      xts.prod_dia <- xts(xts.prod_dia)
      xts.prod_dia$PRd <- xts.prod_dia$Eac_d/(xts.prod_dia$Gefd*Pn)

      #Crea xts de salida con datos mensuales
      G0dm <- aggregate(xts.prod_dia$G0d, as.yearmon, mean)
      Tadm <- aggregate(xts.prod_dia$Tad, as.yearmon, mean)
      Gefdm <- aggregate(xts.prod_dia$Gefd, as.yearmon, mean)
      Eac_dm <- aggregate(xts.prod_dia$Eac_d, as.yearmon, mean)
      Eac_m <- aggregate(xts.prod_intra$Pac, as.yearmon, sum)
      xts.prod_mes <- merge(G0dm, Tadm, Gefdm, Eac_dm, Eac_m)
      xts.prod_mes <- xts(xts.prod_mes)
      xts.prod_mes$PRdm <- xts.prod_mes$Eac_dm/(xts.prod_mes$Gefdm*Pn)
    }

  }

  ##########2)DATOS ENTRADA DIARIOS###########
  if(int_entrada=="DIARIO"){

    bd_d <- zoo2Meteo(z.G0, lat=lat)

    #####2.1)Cálculo sin considerar pérdidas por reflexión y suciedad####
    if(iS==0){
      prod <- prodGCPV(lat=lat,
                       modeTrk='fixed',
                       modeRad='bd',
                       dataRad=bd_d,
                       beta=beta, alfa=alfa,
                       module=modulo,
                       generator=generador,
                       inverter=inversor,
                       effSys=rendimientos)

      df.G <- data.frame(date=index(prod@G0I),
                      G0=coredata(prod@G0I$G0),
                      Ta=coredata(prod@Ta),
                      Gef=coredata(prod@GefI$G))

      prod <- fProd(df.G, module=modulo, generator=generador,
                    inverter=inversor, effSys=rendimientos)

      #Crea xts de salida con datos intradiarios
      names(df.G) <- c("date","G0", "Ta", "G")
      prod_intra <- mutate(df.G, Pac=prod$Pac)
      prod_intra$G0[is.na(prod_intra$G0)] <- 0
      prod_intra$G[is.na(prod_intra$G)] <- 0
      prod_intra$Pac[is.na(prod_intra$Pac)] <- 0
      prod_intra <- mutate(prod_intra, PR=prod_intra$Pac/(prod_intra$G*Pn))
      prod_intra$PR[is.na(prod_intra$PR)] <- 0
      xts.prod_intra <- xts(data.frame(G0=prod_intra$G0/1000,
                                       Ta=prod_intra$Ta,
                                       G=prod_intra$G/1000,
                                       Pac=prod_intra$Pac/1000,
                                       PR=prod_intra$PR),
                            order.by = as.POSIXlt(prod_intra$date))

      #Crea xts de salida con datos diarios
      G0d <- aggregate(xts.prod_intra$G0, as.Date, sum)
      Tad <- aggregate(xts.prod_intra$Ta, as.Date, mean)
      Gd <- aggregate(xts.prod_intra$G, as.Date, sum)
      Eac_d <- aggregate(xts.prod_intra$Pac, as.Date, sum)
      xts.prod_dia <- merge(G0d, Tad, Gd, Eac_d)
      xts.prod_dia <- xts(xts.prod_dia)
      xts.prod_dia$PRd <- xts.prod_dia$Eac_d/(xts.prod_dia$Gd*Pn)

      #Crea xts de salida con datos mensuales
      G0dm <- aggregate(xts.prod_dia$G0d, as.yearmon, mean)
      Tadm <- aggregate(xts.prod_dia$Tad, as.yearmon, mean)
      Gdm <- aggregate(xts.prod_dia$Gd, as.yearmon, mean)
      Eac_dm <- aggregate(xts.prod_dia$Eac_d, as.yearmon, mean)
      Eac_m <- aggregate(xts.prod_intra$Pac, as.yearmon, sum)
      xts.prod_mes <- merge(G0dm, Tadm, Gdm, Eac_dm, Eac_m)
      xts.prod_mes <- xts(xts.prod_mes)
      xts.prod_mes$PRdm <- xts.prod_mes$Eac_dm/(xts.prod_mes$Gdm*Pn)
    }

    #####2.2)Cálculo considerando pérdidas por reflexión y suciedad####
    if(iS!=0){
      prod <- prodGCPV(lat=lat,
                       modeTrk='fixed',
                       modeRad='bd',
                       dataRad=bd_d,
                       beta=beta, alfa=alfa, iS=iS,
                       module=modulo,
                       generator=generador,
                       inverter=inversor,
                       effSys=rendimientos)

      #Crea tabla de salida con datos intradiarios
      prod_intra <- data.frame(date=index(prod@G0I),
                               G0=prod@G0I$G0/1000,
                               Ta=prod@Ta,
                               Gef=prod@GefI$Gef/1000,
                               Pac=prod@prodI$Pac/1000)
      prod_intra$G0[is.na(prod_intra$G0)] <- 0
      prod_intra$Gef[is.na(prod_intra$Gef)] <- 0
      prod_intra$Pac[is.na(prod_intra$Pac)] <- 0
      prod_intra <- mutate(prod_intra, PR=Pac/(Gef*Pn))
      prod_intra$PR[is.na(prod_intra$PR)] <- 0
      xts.prod_intra <- xts(data.frame(G0=prod_intra$G0,
                                       Ta=prod_intra$Ta,
                                       Gef=prod_intra$Gef,
                                       Pac=prod_intra$Pac,
                                       PR=prod_intra$PR),
                            order.by = as.POSIXlt(prod_intra$date))

      #Crea xts de salida con datos diarios
      G0d <- aggregate(xts.prod_intra$G0, as.Date, sum)
      Tad <- aggregate(xts.prod_intra$Ta, as.Date, mean)
      Gefd <- aggregate(xts.prod_intra$Gef, as.Date, sum)
      Eac_d <- aggregate(xts.prod_intra$Pac, as.Date, sum)
      xts.prod_dia <- merge(G0d, Tad, Gefd, Eac_d)
      xts.prod_dia <- xts(xts.prod_dia)
      xts.prod_dia$PRd <- xts.prod_dia$Eac_d/(xts.prod_dia$Gefd*Pn)

      #Crea xts de salida con datos mensuales
      G0dm <- aggregate(xts.prod_dia$G0d, as.yearmon, mean)
      Tadm <- aggregate(xts.prod_dia$Tad, as.yearmon, mean)
      Gefdm <- aggregate(xts.prod_dia$Gefd, as.yearmon, mean)
      Eac_dm <- aggregate(xts.prod_dia$Eac_d, as.yearmon, mean)
      Eac_m <- aggregate(xts.prod_intra$Pac, as.yearmon, sum)
      xts.prod_mes <- merge(G0dm, Tadm, Gefdm, Eac_dm, Eac_m)
      xts.prod_mes <- xts(xts.prod_mes)
      xts.prod_mes$PRdm <- xts.prod_mes$Eac_dm/(xts.prod_mes$Gefdm*Pn)

    }
  }

  ##########3)DATOS ENTRADA MENSUALES###########
  if(int_entrada=="MENSUAL"){

    #####3.1)Cálculo sin considerar pérdidas por reflexión y suciedad####
    if(iS==0){
      #Llama a la función prodGCPV con iS por defecto, ya que solo toma el valor G.
      prod <- prodGCPV(lat=lat,
                       modeTrk='fixed',
                       modeRad='prom',
                       dataRad=list(G0dm=df.G0$G0, Ta=df.G0$Ta, year=year),
                       beta=beta, alfa=alfa,
                       module=modulo,
                       generator=generador,
                       inverter=inversor,
                       effSys=rendimientos)

      df.G <- data.frame(date=index(prod@G0I),
                         G0=coredata(prod@G0I$G0),
                         Ta=coredata(prod@Ta),
                         Gef=coredata(prod@GefI$G)) ##Toma el valor G, que es distinto a Gef
    }
    #####3.2)Cálculo considerando pérdidas por reflexión y suciedad####
    if(iS!=0){
      #Llama a la función prodGCPV con iS=iS
      prod <- prodGCPV(lat=lat,
                       modeTrk='fixed',
                       modeRad='prom',
                       dataRad=list(G0dm=df.G0$G0, Ta=df.G0$Ta, year=year),
                       beta=beta, alfa=alfa, iS=iS,
                       module=modulo,
                       generator=generador,
                       inverter=inversor,
                       effSys=rendimientos)

      df.G <- data.frame(date=index(prod@G0I),
                         G0=coredata(prod@G0I$G0),
                         Ta=coredata(prod@Ta),
                         Gef=coredata(prod@GefI$Gef)) #Toma el valor Gef
    }

    prod <- fProd(df.G, module=modulo, generator=generador,
                  inverter=inversor, effSys=rendimientos)

    #Crea xts de salida con datos intradiarios (solo un día representativo de cada mes)
    names(df.G) <- c("date","G0", "Ta", "G")
    prod_intra <- mutate(df.G, Pac=prod$Pac)
    prod_intra <- mutate(prod_intra, PR=prod_intra$Pac/(prod_intra$G*Pn))
    prod_intra$PR[is.na(prod_intra$PR)] <- 0
    xts.prod_intra <- xts(data.frame(G0=prod_intra$G0/1000,
                                     Ta=prod_intra$Ta,
                                     G=prod_intra$G/1000,
                                     Pac=prod_intra$Pac/1000,
                                     PR=prod_intra$PR),
                          order.by = as.POSIXlt(prod_intra$date))

    #Crea xts de salida con datos diarios
    ##No se hace tabla diaria porque sería todos los días del mes iguales

    #Crea xts de salida con datos mensuales (promedios diarios)
    G0dm <- aggregate(xts.prod_intra$G0, as.yearmon, sum)
    Tadm <- aggregate(xts.prod_intra$Ta, as.yearmon, mean)
    Gdm <- aggregate(xts.prod_intra$G, as.yearmon, sum)
    Eac_dm <- aggregate(xts.prod_intra$Pac, as.yearmon, sum)
    dias <- as.numeric(diff(seq(as.Date(paste(year,"-01-01", sep='')), as.Date(paste(year+1,"-01-01", sep='')), by = "month")))
    Eac_m <- aggregate(xts.prod_intra$Pac, as.yearmon, sum)*dias
    xts.prod_mes <- merge(G0dm, Tadm, Gdm, Eac_dm, Eac_m)
    xts.prod_mes <- xts(xts.prod_mes)
    xts.prod_mes$PRdm <- xts.prod_mes$Eac_dm/(xts.prod_mes$Gdm*Pn)

    #Asigna datos mensuales a xts.prod_dia para evitar que de error si se seleccion int_salida="DIARIO"
    xts.prod_dia <- xts.prod_mes

    #Cambia nombres si iS!=0
    if(iS!=0){
      names(xts.prod_intra) <- c("G0", "Ta", "Gef", "Pac", "PR")
      names(xts.prod_dia) <- c("G0dm", "Tadm", "Gefdm", "Eac_dm", "Eac_m", "PRdm")
      names(xts.prod_mes) <- c("G0dm", "Tadm", "Gefdm", "Eac_dm", "Eac_m", "PRdm")
    }
  }

  if(int_salida=="INTRADIARIO") return(xts.prod_intra)
  if(int_salida=="DIARIO") return(xts.prod_dia)
  if(int_salida=="MENSUAL") return(xts.prod_mes)

}

