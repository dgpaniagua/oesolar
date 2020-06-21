#Listado de packages a importar (solo para escribir NAMESPACE general de todo el package)
#' @import solaR
#' @import xts
#' @import zoo
#' @importFrom stats aggregate
#' @importFrom lubridate force_tz
#' @importFrom dplyr select
#' @importFrom dplyr case_when
#' @importFrom dplyr mutate
#' @importFrom dplyr %>%
#' @importFrom dplyr group_by
#' @importFrom dplyr summarise
#' @importFrom dplyr filter
#' @importFrom dplyr between
#' @import eplusr
#' @import nasapower
#' @import readxl
#' @import reticulate
#' @import tools
#' @importFrom utils read.csv

utils::globalVariables(c("datetime", "global_horizontal_radiation", "dry_bulb_temperature",
                         "dif", "cant", "Pac", "Gef", "YYYYMMDD", "ALLSKY_SFC_SW_DWN",
                         "T2M", "PARAMETER"))
