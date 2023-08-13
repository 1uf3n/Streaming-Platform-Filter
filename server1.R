
library(ggplot2)
library(dplyr)
library(shiny)
library(readr)
library(tidyverse)
mosp<-read.csv("C:/Users/admin/Documents/Info201Code/exploratory-analysis-p02-Doryi/MoviesOnStreamingPlatforms.csv")
server <- function(input, output) {
  
  mosp <- mosp %>% separate(Rotten.Tomatoes,c("Rating","Total"),sep = "/")
  mosp$Rating <- as.numeric(mosp$Rating)
  mosp <- mosp %>% 
    pivot_longer(Netflix:Disney.,names_to = "Platform", values_to="value") %>%
    filter(value == 1) %>%
    select(-value,-Type,-Total)
  mosp$Platform <- sub("\\.$", "", mosp$Platform)
  mosp_rating_dis <- mosp %>%
    select(Platform,Rating)
  
  output$distPlot <- renderPlot({
    platform_data <- switch(input$platform,
                            "Disney" = subset(mosp_rating_dis, Platform == "Disney"),
                            "Netflix" = subset(mosp_rating_dis, Platform == "Netflix"),
                            "Hulu" = subset(mosp_rating_dis, Platform == "Hulu"),
                            "Prime.Video" = subset(mosp_rating_dis, Platform == "Prime.Video")
    )
    
    x <- platform_data$Rating
    x <- na.omit(x)
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(x, breaks = bins, col = "#75AADB", border = "black",
         xlab = "Rotten Tomatoes Rating",
         main = paste("Histogram of Rotten Tomatoes Rating in", input$platform))
  })
}
