library(shiny)

ui <- fluidPage(
  textInput("username", label = "What is your name?"),
  textOutput("message")
)

server <- function(input, output, session) {
  output$message <- renderText({
    return(paste("Hello", input$username))
  })
}

shinyApp(ui, server)