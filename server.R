library(shiny)
source("index.R")

server <- function(input, output) {
  type <- reactive({
    type <- input$type
    type
  })
  
  weapon <- reactive({
    weapon <- input$weapon
    weapon
  })
  
  
  output$plot1 <- renderUI({
    
    if (type() == "victims") {
      mainPanel(
        tags$video(src="victim_heatmap.mp4", loop=T, autoplay=T, 
                   type="video/mp4", width="480px", height="480px", controls = "controls")		
      )
    }
    else if (type() == "killers") {
      mainPanel(
        tags$video(src="killer_heatmap.mp4", loop=T, autoplay=T, 
                   type="video/mp4", width="480px", height="480px", controls = "controls")	
      )
    }
    else if (type() == "all") {
      mainPanel(
        tags$video(src="victim_heatmap.mp4", loop=T, autoplay=T, 
                   type="video/mp4", width="480px", height="480px", controls = "controls")	,
        tags$video(src="killer_heatmap.mp4", loop=T, autoplay=T, 
                   type="video/mp4", width="480px", height="480px", controls = "controls")		
      )
    }
  })
  
  output$plot2 <- renderUI({
    
    if (weapon() == "victims") {
      mainPanel(
        tags$video(src="victim_heatmap.mp4", loop=T, autoplay=T, 
                   type="video/mp4", width="480px", height="480px", controls = "controls")		
      )
    }
    else if (weapon() == "killers") {
      mainPanel(
        tags$video(src="killer_heatmap.mp4", loop=T, autoplay=T, 
                   type="video/mp4", width="480px", height="480px", controls = "controls")	
      )
    }
    else if (weapon() == "all") {
      mainPanel(
        tags$video(src="victim_heatmap.mp4", loop=T, autoplay=T, 
                   type="video/mp4", width="480px", height="480px", controls = "controls")	,
        tags$video(src="killer_heatmap.mp4", loop=T, autoplay=T, 
                   type="video/mp4", width="480px", height="480px", controls = "controls")		
      )
    }
  })
  
  output$plotpositive <- renderPlot({
    plot.positive
  })
  
  output$plotweapon <- renderPlot({
    plot.weapon_dist
  })
}
