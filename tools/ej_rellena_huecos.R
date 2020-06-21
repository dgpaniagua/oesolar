# ##########DATOS CON HUECOS##########
# #Descarga datos de 1 medidor con datos cada 15 minutos de un mes, sin rellenar huecos (na=NULL)
# datos_con_huecos <- importar_optimum(usuario="usuario_valido",
#                                      password="password_valido",
#                                      medidores=",CIR0141449301", fecha_inicio = "2019-03-01",
#                                      fecha_fin = "2019-03-31", int_entrada = "15MIN",
#                                      consumo = TRUE, na=NULL)
#
# datos_rellenados <- rellena_huecos(xts=datos_con_huecos, int_entrada="15MIN", na="INTERPOLAR",
#                                    consumo=TRUE, indicar_na=TRUE)
#
# info_huecos(datos_con_huecos)
# #62 huecos de 135 minutos (8 datos faltantes de 15 minutos por hueco)
#
# length(datos_rellenados$energia)-length(datos_con_huecos$energia)
# #[1] 496
# #Puede verse que se rellenaron 496 datos (8x62)
