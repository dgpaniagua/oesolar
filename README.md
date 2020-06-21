# OESolar
Package R OESolar

Diseño de sistemas fotovoltaicos conectados a red a partir de datos de radiación solar global y parámetros del sistema, incluyendo funciones para descarga directa de datos de radiación solar de base de datos Nasa. El cálculo de los sistemas fotovoltáicos se realiza utilizando el package 'solaR'. Por otra parte, incluye funciones para descargar, de sistema Optimum, datos de generación y consumo de medidores del proyecto PRIER Armstrong, permitiendo el posterior análisis y cálculo de valores de PR diarios y mensuales.

# Instalación
```{r}
devtools::install_github('dgpaniagua/oesolar', auth_token = "e3b55c2a9b278bda698dd55d718009f028dc8c00")
```