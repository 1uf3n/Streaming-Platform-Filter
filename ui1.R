ui <- fluidPage(
  titlePanel("Distribution of Rating in Streaming Platforms"),
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
      plotOutput(outputId = "distPlot")
    )
  )
)