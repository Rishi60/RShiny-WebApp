library(shiny)
library(shinythemes)

ui <- fluidPage(theme = shinytheme("cerulean"),
                navbarPage("BMI Calculator:",
                           tabPanel("Calculate",
                                    sidebarPanel(
                                      HTML("<h3>Input parameters</h3>"),
                                      sliderInput("height", 
                                                  label = "Height", value = 125, min = 40, max = 240),
                                      sliderInput("weight", 
                                                  label = "Weight", value = 50, min = 20, max = 120),
                            
                                      actionButton("submitbutton", 
                                                   "Submit", 
                                                   class = "btn btn-primary")
                                    ),
                                    
                                    mainPanel(
                                      tags$label(h3('Results')), 
                                      verbatimTextOutput('contents'),
                                      tableOutput('tabledata') # Results table
                                    ) 
                           ), 
                           
                           tabPanel("About", 
                                    titlePanel("About"), 
                                    div(includeMarkdown("about.md"), align="justify")
                           ) 
                ) 
) 


server <- function(input, output, session) {
  
  # Input Data
  datasetInput <- reactive({  
    
    bmi <- input$weight/( (input$height/100) * (input$height/100) )
    bmi <- data.frame(bmi)
    names(bmi) <- "BMI"
    print(bmi)
    
  })
  
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Calculation completed.") 
    } else {
      return("Enter the data and click on submit for results.")
    }
  })
  
  output$tabledata <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput()) 
    } 
  })
  
}

shinyApp(ui = ui, server = server)
