---
title: "Práctica Programada #1 Shiny"
author: "Johanna Salazar Ramírez"
date: "2023-11-04"
---

# Bibliotecas disponibles:
library(shiny)
library(datasets)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(readr)
library(readxl)
library(tidyr)
library(janitor) 
library(lubridate) 
library(gt)
library(leaflet)
library(writexl)


#Agregar Base de Datos
datos_empleo_genero <- read_csv("Datos_empleo/datos_empleo_genero.csv")

#Visualizr Base de Datos cargada
View(datos_empleo_genero)