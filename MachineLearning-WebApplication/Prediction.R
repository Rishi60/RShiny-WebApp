
# Import libraries
library(shiny)
library(shinythemes)
library(data.table)
library(randomForest)

# Read data
weather <- read.csv("weather-weka.csv")

weather$play = factor(weather$play)
weather$outlook = factor(weather$outlook)

# Build model
model <- randomForest(play ~ ., data = weather, ntree = 500, mtry = 4, importance = TRUE)

# User interface                   
ui <- fluidPage(theme = shinytheme("darkly"),
  headerPanel('Check whether you can play golf: '),
  
  # Input values
  sidebarPanel(
    HTML("<h3>Input Parameters</h3>"),
    
    selectInput("outlook", label = "Outlook:", 
                choices = list("Sunny" = "sunny", "Overcast" = "overcast", "Rainy" = "rainy"), 
                selected = "Rainy"),
    sliderInput("temperature", "Temperature:", min = 64, max = 86, value = 70),
    sliderInput("humidity", "Humidity:", min = 65, max = 96, value = 90),
    
    selectInput("windy", label = "Windy:", 
                choices = list("Yes" = "TRUE", "No" = "FALSE"), 
                selected = "TRUE"),
    
    actionButton("submitbutton", "Submit", class = "btn btn-primary")
  ),
  
  mainPanel(
    tags$label(h3('Result -')), 
    verbatimTextOutput('contents'),
    tableOutput('tabledata') 
    
  )
)


# Server                        
server <- function(input, output, session) {

  # Input Data
  datasetInput <- reactive({  
    
  # outlook,temperature,humidity,windy,play
  df <- data.frame(
    Name = c("outlook",
             "temperature",
             "humidity",
             "windy"),
    Value = as.character(c(input$outlook,
                           input$temperature,
                           input$humidity,
                           input$windy)),
    stringsAsFactors = FALSE)
  
  play <- "play"
  df <- rbind(df, play)
  input <- transpose(df)
  write.table(input,"input.csv", sep=",", quote = FALSE, row.names = FALSE, col.names = FALSE)
  
  test <- read.csv(paste("input", ".csv", sep=""), header = TRUE)
  
  test$outlook <- factor(test$outlook, levels = c("overcast", "rainy", "sunny"))
  
  
  Output <- data.frame(Prediction=predict(model,test), round(predict(model,test,type="prob"), 3))
  print(Output)
  
  })
  
  # result Text Box
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Calculation completed.") 
    } else {
      return("Enter the input parameters and click on submit for results.")
    }
  })
  
  # Prediction results table
  output$tabledata <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput()) 
    } 
  })
  
}

shinyApp(ui = ui, server = server)
