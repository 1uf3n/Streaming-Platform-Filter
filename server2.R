library(tidyverse)
library(dplyr)
library(shiny)
library(plotly)

# Load dataset
df <- read.csv("MoviesOnStreamingPlatforms.csv")

# Rename column names of service proviers
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

server <- function(input, output) {
  
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
}
