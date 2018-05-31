library(shiny)

server <- function(input, output) {

}

ui <- fluidPage(

	navbarPage("Play Unknown's Battleground",
		tabPanel("Introduction"

		),
		tabPanel("Time of Death", sidebarLayout (
			sidebarPanel(
				h4("Random Random")
			), mainPanel(
				h3("aaa")
			)
		)),
		tabPanel("Weapons", sidebarLayout (
			sidebarPanel(
				h4("Random Random")
			), mainPanel(
				h3("aaa")
			)
		))
	)
)

shinyApp(ui, server)