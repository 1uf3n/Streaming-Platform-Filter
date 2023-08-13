ui <- navbarPage("Analyzing Various Streaming Platforms",
                 tabPanel("Introduction"),
                 tabPanel("Diversity of Streaming Platforms",
                          h1("Diversity of Streaming Platforms"),
                          p(HTML("This graph was created to answer: <strong>How does the content library of each streaming platform compare in terms of type diversity, and how do the movie release years compare across platforms?</strong>")),
                          p("This is accomplished by creating a bar graph to visualize the number of movies released by various streaming platforms from 1914 to 2021. When we compare the growth trend of the number of movies on various platforms over the years, we can better understand the different diversity of movie libraries and the development of platforms. By observing the number of movies per year, we can also glimpse the preferences and release strategies of various platforms for new and old movies. This trend analysis can reveal the unique orientations of various platforms in selecting movie content, which may reflect their understanding of audience preferences and the relative popularity of different theme films in the market."),
                          
                          sidebarLayout(
                            sidebarPanel(
                              h3("Options for Graph"),
                              sliderInput(inputId = "Year",
                                          label = "Select the year:",
                                          min = min(df$Year, na.rm = TRUE),
                                          max = max(df$Year, na.rm = TRUE),
                                          value = max(df$Year, na.rm = TRUE),
                                          step = 1),
                              numericInput(inputId = "SelectedYear",
                                           label = "Enter a year:",
                                           value = max(df$Year, na.rm = TRUE),
                                           min = min(df$Year, na.rm = TRUE),
                                           max = max(df$Year, na.rm = TRUE))
                            ),
                        
                            mainPanel(
                              plotlyOutput(outputId = "interactive_chart"),
                              textOutput(outputId = "MovieCountOutput")
                            )
                            
                          ),
                          p("This bar chart reveals significant differences in the number of movies across streaming platforms. Prime Video and Netflix have more films released over the years, while Disney+ and Hulu have relatively few. This reflects the differences in content supply among different platforms and may also reflect their positioning and audience groups. The chart also shows that the movie libraries of Prime Video and Netflix mainly focus on recent movies, with fewer containing classic movies from nearly 2000 years. In contrast, Disney+ and Hulu's movie library specifically includes movies from 10 years ago, and they have more classic movies than the other two platforms. This allows users to visually see the differences in time dimensions of each platform, helping them choose the platform that suits their taste. Through this visualization approach, users can better understand the diversity of movies on various streaming platforms and their differences in movie production over the years.")
                          
                 ),
                 tabPanel("Movie Age Rating",
                          h1("Movie Age Rating"),
                          p(HTML("This graph was created to answer: <strong>What age does each platform cater to based on their average age rating?</strong>")),
                          p("This is accomplished by creating a pie chart to visualize the distribution of Rotten Tomatoes ratings for each platform."),
                          
                          sidebarLayout(
                            sidebarPanel(
                              selectInput(
                                inputId = "platform_input",
                                label = "Select streaming platform to analyze:",
                                choices = list(
                                  "Netflix" = "Netflix",
                                  "Disney+" = "Disney",
                                  "Prime Video" = "Prime",
                                  "Hulu" = "Hulu"
                                ),
                                selected = "Netflix",
                                multiple = FALSE
                              )
                            ),
                            mainPanel(
                              plotlyOutput(outputId = "pie_chart")
                            )
                          )
                 ),
                 tabPanel("Distribution of Rating",
                          h1("Movie Age Rating"),
                          p(HTML("This graph was created to answer: <strong>How do the average movie ratings differ across the various platforms?</strong>")),
                          p("This is accomplished by creating a histogram to visualize the distribution of movie age ratings by platform."),
                          
                          sidebarLayout(
                            sidebarPanel(
                              selectInput(inputId = "platform",
                                          label = "Select Platform:",
                                          choices = c("Disney", "Netflix", "Hulu", "Prime.Video"),
                                          selected = "Disney"),
                              sliderInput(inputId = "bins",
                                          label = "Number of bins:",
                                          min = 1,
                                          max = 40,
                                          value = 20)
                            ),
                            mainPanel(
                              plotOutput(outputId = "distPlot"),
                              verbatimTextOutput("graphDescription")
                            )
                          ),
                          p("The histogram plot shows the distribution of Rotten Tomatoes ratings for each platform. It tries to understand whether there is any difference in the rating distribution between platforms. Also, it tries to know whether the distribution is robust to changes in the number of bins.")
                 ),
                 tabPanel("Summary")
)
