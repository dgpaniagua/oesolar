# #Calculo de las distintas combinaciones de intervalos de datos de entrada y salida.
#
# rad_intra <- importar_epw("ARG_MARCOS-JUAREZ-AERO_874670_IW2.EPW")
#
# rad_dia <- rad_nasa(intervalo = "DIARIO", lonlat = c(-62.15,-32.7),
#                     fechas = c("2019-01-01","2019-12-31"))
#
# rad_mes <- rad_nasa(intervalo = "MENSUAL", lonlat = c(-62.15,-32.7), fechas = 2019)
#
# ######1)DATOS DE ENTRADA INTRADIARIO######
#
# prod1_intra_intra_is0 <- prod_energia(G0=rad_intra, int_entrada="INTRADIARIO",
#                                       int_salida="INTRADIARIO",
#                                       lon=-62.15, lat=-32.7, beta=30, alfa=0, Pn=1.56, iS = 0,
#                                       year=as.POSIXlt(Sys.Date())$year+1900-1)
#
# prod2_intra_intra_is2 <- prod_energia(G0=rad_intra, int_entrada="INTRADIARIO",
#                                       int_salida="INTRADIARIO",
#                                       lon=-62.15, lat=-32.7, beta=30, alfa=0, Pn=1.56, iS = 2,
#                                       year=as.POSIXlt(Sys.Date())$year+1900-1)
#
# prod3_intra_dia_is0 <- prod_energia(G0=rad_intra, int_entrada="INTRADIARIO",
#                                     int_salida="DIARIO",
#                                     lon=-62.15, lat=-32.7, beta=30, alfa=0, Pn=1.56, iS = 0,
#                                     year=as.POSIXlt(Sys.Date())$year+1900-1)
#
# prod4_intra_dia_is2 <- prod_energia(G0=rad_intra, int_entrada="INTRADIARIO",
#                                     int_salida="DIARIO",
#                                     lon=-62.15, lat=-32.7, beta=30, alfa=0, Pn=1.56, iS = 2,
#                                     year=as.POSIXlt(Sys.Date())$year+1900-1)
#
# prod5_intra_mes_is0 <- prod_energia(G0=rad_intra, int_entrada="INTRADIARIO",
#                                     int_salida="MENSUAL",
#                                     lon=-62.15, lat=-32.7, beta=30, alfa=0, Pn=1.56, iS = 0,
#                                     year=as.POSIXlt(Sys.Date())$year+1900-1)
#
# prod6_intra_mes_is2 <- prod_energia(G0=rad_intra, int_entrada="INTRADIARIO",
#                                     int_salida="MENSUAL",
#                                     lon=-62.15, lat=-32.7, beta=30, alfa=0, Pn=1.56, iS = 2,
#                                     year=as.POSIXlt(Sys.Date())$year+1900-1)
#
# ######2)DATOS DE ENTRADA DIARIO######
#
# prod7_dia_intra_is0 <- prod_energia(G0=rad_dia, int_entrada="DIARIO", int_salida="INTRADIARIO",
#                                     lon=-62.15, lat=-32.7, beta=30, alfa=0, Pn=1.56, iS = 0,
#                                     year=as.POSIXlt(Sys.Date())$year+1900-1)
#
# prod8_dia_intra_is2 <- prod_energia(G0=rad_dia, int_entrada="DIARIO", int_salida="INTRADIARIO",
#                                     lon=-62.15, lat=-32.7, beta=30, alfa=0, Pn=1.56, iS = 2,
#                                     year=as.POSIXlt(Sys.Date())$year+1900-1)
#
# prod9_dia_dia_is0 <- prod_energia(G0=rad_dia, int_entrada="DIARIO", int_salida="DIARIO",
#                                   lon=-62.15, lat=-32.7, beta=30, alfa=0, Pn=1.56, iS = 0,
#                                   year=as.POSIXlt(Sys.Date())$year+1900-1)
#
# prod10_dia_dia_is2 <- prod_energia(G0=rad_dia, int_entrada="DIARIO", int_salida="DIARIO",
#                                    lon=-62.15, lat=-32.7, beta=30, alfa=0, Pn=1.56, iS = 2,
#                                    year=as.POSIXlt(Sys.Date())$year+1900-1)
#
# prod11_dia_mes_is0 <- prod_energia(G0=rad_dia, int_entrada="DIARIO", int_salida="MENSUAL",
#                                    lon=-62.15, lat=-32.7, beta=30, alfa=0, Pn=1.56, iS = 0,
#                                    year=as.POSIXlt(Sys.Date())$year+1900-1)
#
# prod12_dia_mes_is2 <- prod_energia(G0=rad_dia, int_entrada="DIARIO", int_salida="MENSUAL",
#                                    lon=-62.15, lat=-32.7, beta=30, alfa=0, Pn=1.56, iS = 2,
#                                    year=as.POSIXlt(Sys.Date())$year+1900-1)
#
#
# ######3)DATOS DE ENTRADA MENSUAL######
# prod13_mes_intra_is0 <- prod_energia(G0=rad_mes, int_entrada="MENSUAL",
#                                      int_salida="INTRADIARIO",
#                                      lon=-62.15, lat=-32.7, beta=30, alfa=0, Pn=1.56, iS = 0,
#                                      year=as.POSIXlt(Sys.Date())$year+1900-1)
#
# prod14_mes_intra_is2 <- prod_energia(G0=rad_mes, int_entrada="MENSUAL",
#                                      int_salida="INTRADIARIO",
#                                      lon=-62.15, lat=-32.7, beta=30, alfa=0, Pn=1.56, iS = 2,
#                                      year=as.POSIXlt(Sys.Date())$year+1900-1)
#
# prod15_mes_dia_is0 <- prod_energia(G0=rad_mes, int_entrada="MENSUAL", int_salida="DIARIO",
#                                    lon=-62.15, lat=-32.7, beta=30, alfa=0, Pn=1.56, iS = 0,
#                                    year=as.POSIXlt(Sys.Date())$year+1900-1)
#
# prod16_mes_dia_is2 <- prod_energia(G0=rad_mes, int_entrada="MENSUAL", int_salida="DIARIO",
#                                    lon=-62.15, lat=-32.7, beta=30, alfa=0, Pn=1.56, iS = 2,
#                                    year=as.POSIXlt(Sys.Date())$year+1900-1)
#
# prod17_mes_mes_is0 <- prod_energia(G0=rad_mes, int_entrada="MENSUAL", int_salida="MENSUAL",
#                                    lon=-62.15, lat=-32.7, beta=30, alfa=0, Pn=1.56, iS = 0,
#                                    year=as.POSIXlt(Sys.Date())$year+1900-1)
#
# prod18_mes_mes_is2 <- prod_energia(G0=rad_mes, int_entrada="MENSUAL", int_salida="MENSUAL",
#                                    lon=-62.15, lat=-32.7, beta=30, alfa=0, Pn=1.56, iS = 2,
#                                    year=as.POSIXlt(Sys.Date())$year+1900-1)
