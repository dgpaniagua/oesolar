# #Calcula valores de radiacion en el plano inclinado para datos diarios de
# #de radiacion solar de Rosario del anio 2019.
#
# rad <- rad_nasa(intervalo = "DIARIO", fechas=c("2019-01-01","2019-12-31"))
# rad_incl <- rad_inclin(rad, beta=28, alfa=11, int_entrada = "DIARIO")
#
# #Calcula valores de radiacion en el plano inclinado para datos mensuales
# #(promediados de los ultimos 30 anios) de radiacion de la ciudad de Rosario, Argentina.
#
# rad <- rad_nasa(intervalo = "MENSUAL", fechas = 2018)
# rad_incl <- rad_inclin(rad, beta=28, alfa=11)
