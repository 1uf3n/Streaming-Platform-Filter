library(shiny)
library(ggplot2)
library(dplyr)
library(plotly)
library(tidyverse)

# Calculate the data and filter the dataframe
df <- read.csv("MoviesOnStreamingPlatforms.csv")

# For age rating
ages_rating_df <- df %>%
  rename("Disney" = Disney.) %>%
  rename("Prime" = Prime.Video) %>%
  select(Age, Netflix, Hulu, Prime, Disney)

ages_rating_data_long <- gather(
  ages_rating_df,
  key = Platform,
  value = has_movie,
  -Age
)

ages_rating_data_long$Age[ages_rating_data_long$Age == ""] <- "Not rated"
ages_rating_data_long <- ages_rating_data_long[ages_rating_data_long$Age != "all", ]

aggregate_Age_rating <- ages_rating_data_long %>%
  filter(has_movie == 1) %>%
  group_by(Platform, Age) %>%
  summarise(Count = n())

age_legend_colors <- c(
  "7+" = "lightgreen",
  "13+" = "deepskyblue",
  "16+" = "orange",
  "18+" = "pink",
  "Not rated" = "grey"
)

# For Rotten tomatoes rating
mosp <- df %>% separate(Rotten.Tomatoes,c("Rating","Total"),sep = "/")
mosp$Rating <- as.numeric(mosp$Rating)
mosp <- mosp %>% 
  pivot_longer(Netflix:Disney.,names_to = "Platform", values_to="value") %>%
  filter(value == 1) %>%
  select(-value,-Type,-Total)
mosp$Platform <- sub("\\.$", "", mosp$Platform)
mosp_rating_dis <- mosp %>%
  select(Platform,Rating)
    

server <- function(input, output) {
  output$interactive_chart <- renderPlotly({
    filtered_data <- df %>%
      filter(Year == input$Year)
    
    total_netflix <- sum(filtered_data$Netflix, na.rm = TRUE)
    total_hulu <- sum(filtered_data$Hulu, na.rm = TRUE)
    total_prime <- sum(filtered_data$Prime, na.rm = TRUE)
    total_disney <- sum(filtered_data$Disney, na.rm = TRUE)
    
    aggregate_info <- data.frame(
      Streaming_Platforms = c("Netflix", "Hulu", "Prime Video", "Disney+"),
      Total_Movies = c(total_netflix, total_hulu, total_prime, total_disney)
    )
    
    platform_legend_colors <- c(
      "Netflix" = "pink",
      "Hulu" = "lightgreen",
      "Prime Video" = "plum",
      "Disney+" = "lightblue"
    )
    
    plot_ly(aggregate_info, x = ~Streaming_Platforms, y = ~Total_Movies, type = "bar", 
            marker = list(color = platform_legend_colors[aggregate_info$Streaming_Platforms])) %>%
      layout(title = "Total Number of Movies by Streaming Platforms",
             xaxis = list(title = "Streaming Platforms"),
             yaxis = list(title = "Total Movies"))
  })
  
  output$MovieCountOutput <- renderText({
    selected_year <- input$SelectedYear
    filtered_data <- df %>%
      filter(Year == selected_year)
    
    total_movies <- nrow(filtered_data)
    
    paste("Total movies in", selected_year, ":", total_movies)
  })
  
  output$pie_chart <- renderPlotly({
    filtered_df <- aggregate_Age_rating[aggregate_Age_rating$Platform == input$platform_input, ] %>%
      arrange(Age)
    
    plot_ly(data = filtered_df, 
            labels = ~Age, 
            values = ~Count, 
            type = 'pie',
            hole = 0.6,
            marker = list(colors = age_legend_colors[filtered_df$Age])) %>%
      layout(title = paste(input$platform_input, "Movie Age Distribution"))
  })
  
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

