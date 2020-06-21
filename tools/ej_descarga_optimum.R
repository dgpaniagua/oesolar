# #Descarga datos de 230 medidores con datos cada 15 minutos, por el período de 13 meses.
# #En la prueba realizada se descargaron 7.841.964 datos en 973 segundos (16min 12seg aprox).
# #Se deben ingresar usuario y password validos (no incluidos en el ejemplo).
#
# datos_dem_190 <- descarga_optimum(usuario="usuario valido", password="password valido",
#                                   medidores="DEM15MIN", fecha_inicio = "2019-03-01",
#                                   fecha_fin = "2020-04-30")
#
# #Descarga datos de 1 medidor cada una hora por un mes.
# datos_1 <- descarga_optimum(usuario="usuario valido", password="password valido",
#                             medidores=",CIR0141449301", fecha_inicio = "2019-03-01",
#                             fecha_fin = "2019-03-31")
