library(shiny)
library(shinythemes)

my_ui <- fluidPage( style="padding: 0px;",  theme = shinytheme("flatly"),
	navbarPage("PUBG: Data Analysis",
			tabPanel("Introduction", sidebarLayout (
				sidebarPanel(
					h1("What is PUBG?"),
					p('"PlayerUnkown’s Battlegrounds" (also noted as PUBG), is a first and third-person shooter battle royale game. It matches 100 players to be drop onto an island, and those players shall fight until only one person remains. Players are allowed to play as a team of four or two, as well as playing solo. At the beginning of the game, from an airplane, players are airdropped onto the island where they can loot towns and buildings, for weapons, ammo, armor and first-aid. A blue-zone (as shown below) will appear a few minutes later to corral players closer and closer by dealing damage to anyone that stands outside the blue-zone. Additionally, there will be supply drops coming later on in the game, in which there will be legendary items.'),
					
					hr(style="border-color: #EEEEEE -moz-use-text-color #FFFFFF; border-style: solid none; border-width: 1px 0; margin: 18px 0;"),

					h4('Dataset Source:'),
					a("Download Link - Kaggle", href="")					
				), mainPanel(
					br(),
					img(src='https://i.redd.it/djzln9jnhrez.jpg', height='50%', width='50%')
				)
			), 
			br(),br(),
			h4("Navigation Guide"),
			tags$ol(
				tags$li(HTML("<b>Tab: Time Of Death</b> In this section, you will be able to see the heatmap of death on the map. There will be three options avaliable: killers' heatmap, victims' heatmap and a heatmap for all.")),
				tags$li(HTML("<b>Tab: Cause of Death</b> In this section, you will be able to see the heatmap of death filtered by all kinds of causes"))
			),
			br(), br()
		),
		tabPanel("Time of Death", sidebarLayout (
				sidebarPanel(
					radioButtons("type", "Choose one:",
						choiceNames = list(
							"Killers",
							"Victims",
							"All"
						),
						choiceValues = list(
							"killers", "victims", "all"
						)
					)
				), uiOutput("plot1")
			), br(),
			h3("Analysis", style="margin: 10px"),
			p("As you can see from the graph above, in the first few minuts, people's death spot is approximately the airdrop spot they picked. Later on, the death spots spread the the rest of the territory because people were moving according to the changing blue circle.", style="margin: 10px")
		),
		tabPanel("Cause of Death", sidebarLayout (
				sidebarPanel(
				radioButtons("weapon", "Choose one:",
					choiceNames = list(
						"Sniper & DMR",
						"AR & LMG",
						"SMG",
						"Shotgun",
						"Pistol",
						"Melee / Other",
						"Vehicle",
						"Area Damage",
						"Environment"
					),
					choiceValues = list(
						"Sniper & DMR",
						"AR & LMG",
						"SMG",
						"Shotgun",
						"Pistol",
						"Melee / Other",
						"Vehicle",
						"Area Damage",
						"Environment"
					)
				)
				), mainPanel(
					uiOutput("plot2")
				)
			)
		)
	)
)



