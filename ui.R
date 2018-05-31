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
                                   a("Download Link - Kaggle", href=""),
                                   
                                   hr(style="border-color: #EEEEEE -moz-use-text-color #FFFFFF; border-style: solid none; border-width: 1px 0; margin: 18px 0;"),
                                   
                                   h4("Questions to Answer:"),
                                   p("<b>Question One:</b> Where do people die most in the game? How many deaths are caused by the limiting of the playing field as opposed to deaths by other players?")
                                   
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
                            p("Analysis", style="margin: 10px")
                            ),
                            tabPanel("Cause of Death", sidebarLayout (
                              sidebarPanel(
                                p(" This plot displays the number of kills per death type (there are more than 20 weapons). 
                                  After grouping them into specific subsets, such as vehicles, or bombs (Area Damage), we can see that in the short range, SMG's, AR weapons and shotguns have the most amount of kills. 
                                  In contrast, Snipers and environment damage is more evenly distributed, which means that they function better on greater distances.")
                              ), mainPanel(
                                plotOutput("plotweapon")
                              )
                            )
                            
                            
                 ),
                 tabPanel("Best Locations",
                           sidebarLayout(
                             sidebarPanel(
                               p("This representation shows which locations have more kills than deaths (blue) 
                                            or vice versa (red). The size of the dot indicates how much the difference in
                                            kills/deaths and that position is. This plot makes sense, because all the hotspots
                                            are around the high population region on the map. We can infer that specific locations,
                                            such as those with shelter, or high altitude are more likely to give the player there are advantage.")
                             ),
                             mainPanel(
                               plotOutput("plotpositive")
                             )
                           )
                 )
)
)



