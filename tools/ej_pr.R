# library(OESolar)
#
# #importa datos de generacion cinco medidores de sistema Optimum.
# gen_dia <- importar_optimum(usuario = "usuario_valido", password = "password_valido",
#                             medidores = "GEN1HORA", fecha_inicio = "2019-01-01",
#                             fecha_fin = "2019-12-31", int_entrada = "HORA",
#                             int_salida = "DIARIO", na="INTERPOLAR", mult_us = TRUE)
# nombres <- names(gen_dia)
#
# #Convierte el objeto "list" a una unica tabla donde cada medidor queda en una columna distinta.
# xts.gen_dia <- do.call(merge, gen_dia)
# names(xts.gen_dia) <- nombres
#
# #Agrega una columna con el promedio de los cinco usuarios para cada dia
# xts.gen_dia$gen <- rowMeans(xts.gen_dia)
#
# #Descarga datos de radiacion global en el plano horizontal de Nasa
# rad_dia <- rad_nasa(intervalo = "DIARIO", lonlat = c(-61.60,-32.78),
#                     fechas = c("2019-01-01","2019-12-31"))
# #Obtiene los valores de radiacion en el plano inclinado
# rad_dia_inclin <- rad_inclin(rad_dia, lat = -32.78, beta = 30, int_entrada = "DIARIO")
#
# #Combina la tabla con los datos de generacion con la tabla de datos de radiacion.
# pr <- merge(xts.gen_dia, rad_dia_inclin)
#
# #Aplica la funcion pr, que agrega una columna a la tabla con el valor de PR.
# pr <- pr(pr, int_entrada="DIARIO", Pn=1560)
