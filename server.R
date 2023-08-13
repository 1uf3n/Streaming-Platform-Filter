library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)

data <- read.csv("MoviesOnStreamingPlatforms.csv")


server <- function(input, output) {
  output$interactive_chart <- renderPlotly({
    filtered_data <- data %>%
      filter(Year == input$Year)
    
    total_netflix <- sum(filtered_data$Netflix, na.rm = TRUE)
    total_hulu <- sum(filtered_data$Hulu, na.rm = TRUE)
    total_prime <- sum(filtered_data$Prime.Video, na.rm = TRUE)
    total_disney <- sum(filtered_data$Disney., na.rm = TRUE)
    
    aggregate_info <- data.frame(
      Streaming_Platforms = c("Netflix", "Hulu", "Prime Video", "Disney+"),
      Total_Movies = c(total_netflix, total_hulu, total_prime, total_disney)
    )
    
    plot_ly(aggregate_info, x = ~Streaming_Platforms, y = ~Total_Movies, type = "bar", marker = list(color = "random")) %>%
      layout(title = "Total Number of Movies by Streaming Platforms",
             xaxis = list(title = "Streaming Platforms"),
             yaxis = list(title = "Total Movies"))
  })
  output$MovieCountOutput <- renderText({
    selected_year <- input$SelectedYear
    filtered_data <- data %>%
      filter(Year == selected_year)
    
    total_movies <- nrow(filtered_data)
    
    paste("Total movies in", selected_year, ":", total_movies)
  })
}

