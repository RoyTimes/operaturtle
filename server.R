library(shiny)
library(ggplot2)

source("index.R")

server <- function(input, output) {
  #Reactive Data For Timeline Radio Buttons
  choice <- reactive({
    choice <- input$choiceInput
    })
  
  #Reactive Data for Cause of Death Dropdown Menu
  weapon <- reactive({
    filter(data.wepdist, type == input$weaponInput)
  })
  
  #Renders The Video For Timeline 
  output$plotLocation <- renderUI({
    if (choice() == "victim") {
      mainPanel(
        tags$video(src="victim_heatmap.mp4", loop=T, autoplay=T, type="video/mp4", width="65%", height="65%", controls = "controls")		
      )
    }
    else if (choice() == "killer") {
      mainPanel(
        tags$video(src="killer_heatmap.mp4", loop=T, autoplay=T, type="video/mp4", width="65%", height="65%", controls = "controls")	
      )
    }
    else if (choice() == "both") {
      mainPanel(
        tags$video(src="event_diff.mp4", loop=T, autoplay=T, type="video/mp4", width="65%", height="65%", controls = "controls")	
      )
    }
  })
  
  #Uses Reactive Data From Dropdown Menu To Produce a Histogram
  output$plotWeapon <- renderPlot({
    ggplot(weapon(), aes(x=distance)) + 
      geom_histogram(binwidth=.5, colour="black", fill="white") +
      geom_density(alpha=.2, fill="#FF6666") + 
      geom_vline(aes(xintercept=mean(distance)), # Ignore NA values for mean 
                 color="red", linetype="dashed", size=1) + # Overlay with transparent density plot
      facet_wrap( ~ type, ncol = 2)
  })
  
  #Produces a Plot to Show Postive or Negative Kills/Death
  output$plotCorrelation<- renderPlot({
    plot.correlation
  })
  
}
