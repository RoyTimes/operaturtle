library(shiny)
library(shinythemes)

server <- function(input, output) {
  
}

ui <- fluidPage( theme = shinytheme("flatly"),
  
  navbarPage("Play Unknown's Battleground",
             tabPanel("Introduction", sidebarLayout (
                 sidebarPanel(
                   h4("Introduction To PUBG"),
                   p(' "PlayerUnkown’s Battlegrounds" (also noted as PUBG), a first and third-person shooter battle royale game. It matches 100 players to be drop onto an island, and those players shall fight until only one person remains. Players are allowed to play as a team of four or two, as well as playing solo. At the beginning of the game, from an airplane, players are airdropped onto the island where they can loot towns and buildings, for weapons, ammo, armor and first-aid. A blue-zone (as shown below) will appear a few minutes later to corral players closer and closer by dealing damage to anyone that stands outside the blue-zone. Additionally, there will be supply drops coming later on in the game, in which there will be legendary items.'),
                   hr(style="border: 1px grey solid"),
                   h4('Dataset Could be Downloaded From'),

                   # TODO: add the link here
                   a("Download Link - Kaggle", href="")
                 ), mainPanel(
                 	br(),
                   img(src='https://i.redd.it/djzln9jnhrez.jpg', height='50%', width='50%')
                 )
               	), 
             	br(),br(),
             	h4("Questions We Proposed"),
              	tags$ol(
				    tags$li(HTML("<b>Question One:</b> Where do people die most in the game? How many deaths are caused by the limiting of the playing field as opposed to deaths by other players?"), tags$ul(tags$li(HTML("An insight we’d like to get is based on your skills as a player, would you die more around these hotspots. ")))),
				    tags$li(HTML("<b>Question Two:</b> Is it wise for people to pick up the supply airdrop? "), tags$ul(tags$li(HTML("One strategy involved in playing the game is camping around valuable drops to lure unsuspecting players into such a zone to gain a positional advantage. ")))),
				    tags$li(HTML("<b>Question Three:</b>  what categories can players be divided into based on statistics such as damage done, kills, distance walked, etc. "), tags$ul(tags$li(HTML("For example, campers might walk less distance and have more damage, etc. Does adopting a particular strategy give a player a higher chance of winning? "))))
				),
				br(), br()
             ),
             tabPanel("Time of Death", sidebarLayout (
	               sidebarPanel(
	               		radioButtons("rb", "Choose one:",
						               choiceNames = list(
						                 "Killers",
						                 "Victims",
						                 "All"
						               ),
						               choiceValues = list(
						                 "killers", "victims", "all"
						               )
						),
						textOutput("choice.kva"),br(),
	                    hr(style="border: 1px grey solid")
	               ), mainPanel(
	                 h3("Place holder"),
	                 tags$video(src="Victim_time_heat.mp4", type="video/mp4", width="480px", height="480px", controls = "controls"),
	                 tags$video(src="Killer_time_heat.mp4", type="video/mp4", width="480px", height="480px", controls = "controls")
	                 
	               )
	             ), 
            	 p ("Analysis")
             ),
             tabPanel("Weapons", sidebarLayout (
               radioButtons("rb", "Choose one:",
                            choiceNames = list(
                              "Killers",
                              "Victims",
                              "All"
                            ),
                            choiceValues = list(
                              "killers", "victims", "all"
                            )
               ),, mainPanel(
                 h3("aaa")
               )
             ))
  )
)

shinyApp(ui, server)


