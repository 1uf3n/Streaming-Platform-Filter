ui <- navbarPage("CO₂ Emissions Analysis",
                 tabPanel("Introduction"),
                 tabPanel("Bar Chart",
                          h1("Diversity of Streaming Platforms"),
                          
                          sidebarLayout(
                            sidebarPanel(
                              h3("Options for Graph"),
                              sliderInput(inputId = "Year",
                                          label = "Select the year:",
                                          min = min(data$Year, na.rm = TRUE),
                                          max = max(data$Year, na.rm = TRUE),
                                          value = max(data$Year, na.rm = TRUE),
                                          step = 1)
                            ),
                            mainPanel(
                              plotlyOutput(outputId = "interactive_chart")
                            )
                          )
                          
                 )
)