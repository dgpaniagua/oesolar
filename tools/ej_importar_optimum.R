#
# ################A partir de archivo xlsx##############
# gen_data_mes <- importar_optimum("D:/Pruebas R/prodGCPV/PANEL SALA VELATORIA 1 2019.xlsx")
#
# gen_data_dia <- importar_optimum("D:/Pruebas R/prodGCPV/PANEL SALA VELATORIA 1 2019.xlsx",
#                                  int_salida = "DIARIO")
#
# gen_data_hora <- importar_optimum("D:/Pruebas R/prodGCPV/PANEL SALA VELATORIA 1 2019.xlsx",
#                                   int_salida = "HORA")
#
#
# ################A partir de data.frame devuelto por descarga_optimum##############
# #Descarga datos de 230 medidores con datos cada 15 minutos, por el periodo de 13 meses. En la
# #prueba realizada se descargaron 7.841.964 datos en 973 segundos (16min 12seg aprox). Se deben
# #ingresar usuario y password validos (no incluidos en el ejemplo)
# prueba_dem_year <- descarga_optimum(usuario="usuario valido", password = "password valido",
#                                    medidores = "DEM15MIN", fecha_inicio = "2019-03-01",
#                                    fecha_fin = "2020-04-30")
#
# #Importa los datos descargados, pasandolos a un "list" donde cada elemento corresponde a un
# #medidor distinto y es un objeto "xts". Para este ejemplo, la funcion se ejecuto
# #en 385 segundos (6min 25seg aprox)
# list.prueba_dem_year <- importar_optimum(file=prueba_dem_year, int_entrada = "15MIN",
#                                         mult_us = TRUE, consumo = TRUE)
#
#
# ################Descargando datos directamente##############
# #El ejemplo anterior se puede ejecutar usando directamente la funcion importar_optimum.
# #Para este ejemplo, la funcion se ejecuto en 1433 segundos (23min 53seg aprox).:
# list.prueba_dem_year <- importar_optimum(usuario="usuario_valido", password = "password_valido",
#                                         medidores = "DEM15MIN", fecha_inicio = "2019-03-01",
#                                         fecha_fin = "2020-04-30",int_entrada = "15MIN",
#                                         mult_us = TRUE, consumo = TRUE)
