# Import libraries
library(shiny)
library(data.table)
library(randomForest)

# Read in the RF model
model <- readRDS("model.rds")

# User interface                   

ui <- pageWithSidebar(
  headerPanel('Iris Predictor: '),
  
  # Input values
  sidebarPanel(
    tags$label(h3('Input Parameter:')),
    numericInput("Sepal.Length", 
                 label = "Sepal Length", 
                 value = 4.1),
    numericInput("Sepal.Width", 
                 label = "Sepal Width", 
                 value = 3.6),
    numericInput("Petal.Length", 
                 label = "Petal Length", 
                 value = 2.4),
    numericInput("Petal.Width", 
                 label = "Petal Width", 
                 value = 0.3),
    
    actionButton("submitbutton", "Submit", 
                 class = "btn btn-primary")
  ),
  
  mainPanel(
    tags$label(h3('Results - ')), 
    verbatimTextOutput('contents'),
    tableOutput('tabledata') 
  )
)

# Server                        

server<- function(input, output, session) {
  
  # Input Data
  datasetInput <- reactive({  
    
    df <- data.frame(
      Name = c("Sepal Length",
               "Sepal Width",
               "Petal Length",
               "Petal Width"),
      Value = as.character(c(input$Sepal.Length,
                             input$Sepal.Width,
                             input$Petal.Length,
                             input$Petal.Width)),
      stringsAsFactors = FALSE)
    
    Species <- 0
    df <- rbind(df, Species)
    input <- transpose(df)
    write.table(input,"input.csv", sep=",", quote = FALSE, row.names = FALSE, col.names = FALSE)
    
    test <- read.csv(paste("input", ".csv", sep=""), header = TRUE)
    
    Output <- data.frame(Prediction=predict(model,test), round(predict(model,test,type="prob"), 3))
    print(Output)
  })
  
  # Status/Output Text Box
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Calculation completed.") 
    } else {
      return("Server is ready for calculation.")
    }
  })
  
  # Prediction results table
  output$tabledata <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput()) 
    } 
  })
  
}


# Create the shiny app             
shinyApp(ui = ui, server = server)
