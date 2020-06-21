# ##########DATOS CON HUECOS##########
# #Descarga datos de 1 medidor con datos cada 15 minutos de un mes, sin rellenar huecos (na=NULL)
# datos_con_huecos <- importar_optimum(usuario="usuario_valido", password="password_valido",
#                                      medidores=",CIR0141449301", fecha_inicio = "2019-03-01",
#                                      fecha_fin = "2019-03-31", int_entrada = "15MIN",
#                                      consumo = TRUE, na=NULL)
#
# #Ejecuta info_huecos
# huecos <- info_huecos(datos_con_huecos)
#
# #Viendo el data.frame "huecos", puede verse que los datos descargados tienen 62 huecos de
# #135 minutos. Esto es, dos huecos de 135 minutos por dia.
#
# ##########DATOS SIN HUECOS#########
# #Descarga datos de 1 medidor con datos cada una hora de un mes, sin rellenar huecos (na=NULL)
# datos_sin_huecos <- importar_optimum(usuario="usuario_valido", password="password_valido",
#                                      medidores=",CIR0141437453", fecha_inicio = "2019-03-01",
#                                      fecha_fin = "2019-03-31", int_entrada = "HORA", na=NULL)
#
# #Ejecuta info_huecos
# huecos <- info_huecos(datos_sin_huecos)
#
# #Viendo el data.frame "huecos", puede verse que los datos descargados no tienen huecos, ya que el
# #data.frame solo tiene una fila, correspondiente al intervalo de tiempo estandar entre datos.
