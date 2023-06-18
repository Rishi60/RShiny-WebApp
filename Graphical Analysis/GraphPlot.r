library(shiny)
data(airquality)

ui <- fluidPage(
  
  titlePanel("Temp level!"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "bins",
                  label = "Number of bins:",min = 0,max = 20,value = 10,step = 2)
    ),
    
    mainPanel(
      plotOutput(outputId = "distPlot")
    )
  )
)

server <- function(input, output) {
  output$distPlot <- renderPlot({
    
    x    <- airquality$Temp
    x    <- na.omit(x)
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    hist(x, breaks = bins, col = "#75AADB", border = "black",
         xlab = "Temp level",
         main = "Histogram of Temp level")
    
  })
  
}

shinyApp(ui = ui, server = server)
