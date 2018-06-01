library(shiny)
library(shinythemes)

my_ui <- fluidPage(style="padding: 0px;",  theme = shinytheme("flatly"),
                   navbarPage("PUBG: Data Analysis",
                              tabPanel("Introduction", 
                                       sidebarLayout(
                                         sidebarPanel(
                                           h1("What is PUBG?"),
                                           p('"PlayerUnkown’s Battlegrounds" (also noted as PUBG), is a first and third-person shooter battle royale game. It matches 100 players to be drop onto an island, and those players shall fight until only one person remains. Players are allowed to play as a team of four or two, as well as playing solo. At the beginning of the game, from an airplane, players are airdropped onto the island where they can loot towns and buildings, for weapons, ammo, armor and first-aid. A blue-zone (as shown below) will appear a few minutes later to corral players closer and closer by dealing damage to anyone that stands outside the blue-zone. Additionally, there will be supply drops coming later on in the game, in which there will be legendary items.'),
                                   
                                           h2("Questions"),
                                  
                                           h4("Question One:"),
                                           p("Where do people die most in the game? How does this vary over time? An insight we’d like to get is based on your skills as a player, would you die more around these hotspots. "),
                                  
                                           h4("Question Two"),
                                           p("whats the best range to use specific weapons?, One strategy involved in playing the game is camping around valuable drops to lure unsuspecting players into such a zone to gain a positional advantage. "),

                                           h4("Question Three"),
                                           p("Which positions are statistically more likely to help you avoid dying, For example, campers might walk less distance and have more damage, etc. Does adopting a particular strategy give a player a higher chance of winning? "),
                                  
                                           hr(style="border-color: #EEEEEE -moz-use-text-color #FFFFFF; border-style: solid none; border-width: 1px 0; margin: 18px 0;"),
            
                                           h4('Dataset Source:'),
                                           a("Dataset Link (Kaggle)", href="https://www.kaggle.com/skihikingkevin/pubg-match-deaths"),
                                   
                                           hr(style="border-color: #EEEEEE -moz-use-text-color #FFFFFF; border-style: solid none; border-width: 1px 0; margin: 18px 0;")
                                 
                                           ), 
                                         mainPanel(
                                           img(src='https://d1wfiv6sf8d64f.cloudfront.net/static/pc/img/visual_main.jpg', height='56.25%', width='100%')
                                           )
                                         )
                                       ),
                              tabPanel("Timeline of Action", 
                                       sidebarLayout(
                                         sidebarPanel(
                                           h2("Where Do People Go to The Most?"),
                                           p("A heat map of deaths occurring where the color indicates the time at which the event occurred, What we can infer from this is that people prefer to spawn at locations with weapon drops, as indicated by the red spots in the video to the right."),
                                           
                                           radioButtons("choiceInput", "Position:",
                                                        choiceNames = list(
                                                          "Killer's Location",
                                                          "Victim's Death",
                                                          "Both"
                                                          ),
                                                        choiceValues = list(
                                                          "killer", 
                                                          "victim", 
                                                          "both"
                                                          )
                                                        )
                                           ), 
                                         uiOutput("plotLocation")
                                         )
                                       ),
                            tabPanel("Weapon Performance", 
                                     sidebarLayout (
                                       sidebarPanel(
                                         h2("What is The Most Affective Weapon?"),
                                         p("This plot displays the number of kills per death type (there are more than 20 weapons). After grouping them into specific subsets, such as vehicles, or bombs (Area Damage), we can see that in the short range, SMG's, AR weapons and shotguns have the most amount of kills. In contrast, Snipers and environmental damage are more evenly distributed, which means that they function better on greater distances."),
                                         
                                         selectInput("weaponInput", "Weapon Class:",
                                                     c("Assualt Rifles & Light Machine Guns" = "AR & LMG",
                                                       "Area Damage" = "Area Damage",
                                                       "Environment" = "Environmnent",
                                                       "Melee & Other Types" = "Melee / Other",
                                                       "Pistol" = "Pistol",
                                                       "Shotgun" = "Shotgun",
                                                       "SMG" = "SMG",
                                                       "Snipers & DMR" = "Sniper & DMR",
                                                       "Vehicles" = "Vehicle"
                                                       )
                                                     )
                                         ), 
                                       mainPanel(
                                         plotOutput("plotWeapon")
                                         )
                                       )
                                     ),
                            tabPanel("Optimal Locations",
                                     sidebarLayout(
                                       sidebarPanel(
                                         h2("What's The Best/Worst Place To Be?"),
                                         p("This representation shows which locations have more kills than deaths (blue) or vice versa (red). The size of the dot indicates how much the difference in kills/deaths and that position is. This plot makes sense because all the hotspots are around the high population region on the map. We can infer that specific locations, such as those with shelter, or high altitude are more likely to give the player's there an advantage.")
                                         ),
                                       mainPanel(
                                         plotOutput("plotCorrelation")
                                         )
                                       )
                                     )
                            )
                   )



