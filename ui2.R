library(shiny)
library(plotly)

ui <- fluidPage(
  
  # static 
  h1("Movie Age Rating"),
  p("This is the chart reflecting the distribution of movie age ratings by platform."),
  
  selectInput(
            inputId = "platform_input",
            label = "Select streaming platform to analyze",
            choices = list(
              "Netflix" = "Netflix",
              "Disney+" = "Disney",
              "Prime Video" = "Prime",
              "Hulu" = "Hulu"
            ),
            selected = "Netflix",
            multiple = FALSE
  ),
  plotlyOutput(outputId = "pie_chart")
  
)