
#packages
library(shiny)
library(shinythemes)

#UI
  ui <- fluidPage(theme = shinytheme("united"),
    navbarPage(
      "Shiny Web application",
      tabPanel("Login",
               sidebarPanel(
                 tags$h3("Sign Up:"),
                 textInput("f1", "First Name:", ""),
                 textInput("l1", "Last Name:", ""),
                 textInput("m1", "Mobile No:", ""),
                 textInput("g1", "Gender:", ""),
                 
               ), 
               mainPanel(
                            h1(" Details are:"),
                            h4("Name"),
                            verbatimTextOutput("txtout"),
                            h4("Mobile Number"),
                            verbatimTextOutput("txtout1"),
                            h4("Gender"),
                            verbatimTextOutput("txtout2"),

                            
               ) 
      ),
      tabPanel("My Profile", "Content yet to be updated") ,
    ) 
  ) 

#server  
  server <- function(input, output) {
    
    output$txtout <- renderText({
      paste( input$f1, input$l1, sep = " ")
    })
    output$txtout1 <- renderText({
      paste( input$m1 )
    })
    output$txtout2 <- renderText({
      paste( input$g1 )
    })
  } 

#Shiny object for connection 
  shinyApp(ui = ui, server = server)
