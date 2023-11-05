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
library(DT)


#Agregar Base de Datos

datos_empleo <- read_csv("Datos_empleo/datos_empleo_genero.csv")

#Visualizr Base de Datos cargada

View(datos_empleo)

# Desarrollar unstrucciones

ui <- dashboardPage(
  dashboardHeader(title = "Información Laboral por Género en América Latina y el Caribe", titleWidth = 810),
  dashboardSidebar(
    selectInput("pais", "Seleccione País", choices = unique(datos_empleo$pais_region)),
    selectInput("genero", "Seleccione Género", choices = c("Hombres", "Mujeres")),
    selectInput("ano_inicio", "Seleccione el Período (Múltiple)", choices = unique(datos_empleo$anyo)[!(unique(datos_empleo$anyo) %in% 1970:1999)], multiple = TRUE),
    actionButton("actualizar", "Iniciar")
  ),
  dashboardBody(
    fluidRow(
      box(
        title = "Gráfico de Baras Empleadores según género",
        plotOutput("plot_empleadoras", height = "400px")
      ),
      box(
        title = "Gráfico de Barras Trabajadores Informales Según Género",
        plotOutput("plot_informal", height = "400px")
      ),
      box(
        title = "Gráfico de Barras Sobre Desempleo Según Género",
        plotOutput("plot_desempleo", height = "400px")
      )
    ),
    box(
      title = "Datos Empleo y Género",
      DTOutput("tabla"),
      width = 30,  
      height = "810px", 
      DT::dataTableOutput("table")
    )
  )
)

server <- function(input, output) {
  datos_filtrados <- eventReactive(input$actualizar, {
    datos_empleo |>
      filter(pais_region == input$pais, anyo %in% input$ano_inicio)
  })
  
  output$plot_empleadoras <- renderPlot({
    genero_variable <- ifelse(input$genero == "Hombres", "empleadores_hombres", "empleadoras_mujeres")
    ggplot(datos_filtrados(), aes(x = anyo, y = !!sym(genero_variable))) +
      geom_bar(stat = "identity") +
      labs(title = paste("Porcentaje de", input$genero, "empleadores en", input$pais),
           y = "Porcentaje",
           x = "Año")
  })
  
  output$plot_informal <- renderPlot({
    genero_variable <- ifelse(input$genero == "Hombres", "empleo_informal_hombres", "empleo_informal_mujeres")
    ggplot(datos_filtrados(), aes(x = anyo, y = !!sym(genero_variable))) +
      geom_bar(stat = "identity") +
      labs(title = paste("Porcentaje de", input$genero, "trabajadores informales en", input$pais),
           y = "Porcentaje",
           x = "Año")
  })
  
  output$plot_desempleo <- renderPlot({
    genero_variable <- ifelse(input$genero == "Hombres", "desempleo_hombres", "desempleo_mujeres")
    ggplot(datos_filtrados(), aes(x = anyo, y = !!sym(genero_variable))) +
      geom_bar(stat = "identity") +
      labs(title = paste("Porcentaje de", input$genero, "desempleo en", input$pais),
           y = "Porcentaje",
           x = "Año")
  })
  
  output$tabla <- renderDT({
    datatable(datos_filtrados(), options = list(pageLength = 100, scrollX = TRUE))
  })
}

shinyApp(ui, server)


