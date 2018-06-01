library(dplyr)
library(tidyr)
library(ggplot2)
library(jpeg)
library(data.table)
library(devtools)
library(gganimate)
library(magick)
library(grid)
library(plotly)

#devtools::install_github("dgrtwo/gganimate")
#install.packages("magick")

data.in <- read.csv("data/f_miramar.csv")
data.in <- filter(data.in, map_id == "MIRAMAR")

img <- readJPEG("media/JPEG/miramar.jpg")

##########################################################################
### Filtering Dataset
##########################################################################

#Extracting Invidiual Values into Tables
## Storing Victim Position Data.

#The x coordinates are flipped in the data set thus we flip them around.
data.victim.x <- select(data.in, contains("x")) %>% 
  select(contains("victim")) %>% 
  gather(Player, victim_x, deaths_0_victim_position_x:deaths_9_victim_position_x) %>% 
  mutate(victim_x = round(1000 - victim_x / 800000 * 1000))

data.victim.y <- select(data.in, contains("y")) %>% 
  select(contains("victim")) %>% 
  gather(Player, victim_y, deaths_0_victim_position_y:deaths_9_victim_position_y) %>% 
  mutate(victim_y = round(victim_y / 800000 * 1000))

#Storing Killer's Position Data.
data.killer.x <-  select(data.in, contains("x")) %>% 
  select(contains("killer")) %>% 
  gather(Player, killer_x, deaths_0_killer_position_x:deaths_9_killer_position_x) %>% 
  mutate(killer_x = round(1000 - killer_x / 800000 * 1000))

data.killer.y <- select(data.in, contains("y")) %>% 
  select(contains("killer")) %>% 
  gather(Player, killer_y, deaths_0_killer_position_y:deaths_9_killer_position_y) %>% 
  mutate(killer_y = round(killer_y / 800000 * 1000))

#Storing Time Data in Seconds
data.time <- select(data.in, contains("time")) %>% 
  gather(Player, time, deaths_0_time_event:deaths_9_time_event) %>% 
  mutate(time = ceiling(time / 60))

#Storing Weapon Used.
data.weapon <- select(data.in, contains("description")) %>% 
  gather(Player, weapon, deaths_0_description:deaths_9_description)

#Adding Attributes to Each Weapon
data.weapon$type[data.weapon$weapon %in% c('AWM','M24','Kar98k','Win94','Mk14','SLR','SKS','Mini14','VSS')] <- "Sniper & DMR"
data.weapon$type[data.weapon$weapon %in% c('Groza','AKM','DP-28','M249','AUG','M16A4','M416','SCAR-L')] <- "AR & LMG"
data.weapon$type[data.weapon$weapon %in% c('TommyGun','UMP9','Vector','UZI', 'MicroUZI')] <- "SMG"
data.weapon$type[data.weapon$weapon %in% c('S686','S1897','S12K')] <- "Shotgun"
data.weapon$type[data.weapon$weapon %in% c('Sawed-off','R1895','R45','P1911','P92','P18C')] <- "Pistol"
data.weapon$type[data.weapon$weapon %in% c('Crossbow','Pan','Machete','Crowbar','Sickle','Superman Punch','Punch')] <- "Melee / Other"
data.weapon$type[data.weapon$weapon %in% c('PickupTruck','Buggy','HitbyCar','Motorbike','Boat','Motorbike(SideCar)','Dacia','death.BP_PickupTruck_B_01_C','death.BP_Van_A_03_C','Uaz')] <- "Vehicle"
data.weapon$type[data.weapon$weapon %in% c('death.ProjMolotov_DamageField_C','Grenade','death.Buff_FireDOT_C','death.ProjMolotov_C')] <- "Area Damage"
data.weapon$type[data.weapon$weapon %in% c('DownandOut','Drown','RedZone','death.RedZoneBomb_C','Bluezone','Falling')] <- "Environmnent"


#Combine Everything into One Data Drame.
data.map <- data.frame(data.victim.x, data.victim.y, data.killer.x, data.killer.y, data.time, data.weapon)

#Drop Rows Which Contain Column Names
data.map <- select(data.map, time,
        victim_x, victim_y,
                   weapon, type,
                   killer_x, killer_y)

data.map <- mutate(data.map, distance = sqrt(abs((killer_x - victim_x)*(killer_x - victim_x)) +
                                               abs((killer_y - victim_y))*(killer_y - victim_y)))

##########################################################################
### Graphing Plots and Maps
##########################################################################

#data.map2 reduces values by:
##1.Removing NA Values 2.Filtering For Coordinates of Killer/Victim Which Are at The Edge of The Map.
data.map2 <- na.omit(data.map)
data.map2 <- filter(data.map2, !(victim_x == 1000 & victim_y == 0)) %>% 
  filter(!(killer_x == 1000 & killer_y == 0))

#Binning The Data Into a Smaller Grid Size. 
data.bins <- data.map2
data.bins$victim_x = ceiling(data.bins$victim_x/10)
data.bins$victim_y = ceiling(data.bins$victim_y/10)
data.bins$killer_x = ceiling(data.bins$killer_x/10)
data.bins$killer_y = ceiling(data.bins$killer_y/10)

#Weapon/Distance Relation
data.wepdist <- select(data.map2, type, distance)

#Counting Death/Kill Location at Each Bin.
data.bins.v <- select(data.bins, x = victim_x, y = victim_y) %>% 
  group_by(x, y) %>% 
  summarize(count_v = n())

data.bins.k <- select(data.bins, x = killer_x, y = killer_y) %>% 
  group_by(x, y) %>% 
  summarize(count_k = n())

data.bins.diff <- merge(data.bins.k, data.bins.v, by = c("x", "y"), all = TRUE)
data.bins.diff$count_k[is.na(data.bins.diff$count_k)] <- 0
data.bins.diff$count_v[is.na(data.bins.diff$count_v)] <- 0

# Calculating Points of Interest/Not.
data.bins.diff <- mutate(data.bins.diff, kill_pos = count_k - count_v)
data.bins.diff %>% group_by(kill_pos) %>% summarize(count = n())

#Create Table Where Good and Bad Points Shown.
data.bins.good <- filter(data.bins.diff, kill_pos > 2)
data.bins.bad <- filter(data.bins.diff, kill_pos < -2)

#Plot Showing Good and Bad Positions:
plot.correlation <- ggplot() +
  annotation_custom(rasterGrob(img, width = unit(1,"npc"), height = unit(1,"npc")), -Inf, Inf, -Inf, Inf) +
  geom_point(data = data.bins.good, aes(x = x, y = y, color = "blue", size = kill_pos)) +
  xlab("X coordinate") +
  ylab("Y coordinate") +
  geom_point(data = data.bins.bad, aes(x = x, y = y, color = "red", size = -kill_pos)) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, 100)) + 
  scale_x_continuous(expand = c(0, 0), limits = c(0, 100))+ coord_fixed(ratio = 1)

#Heatmap of Victim/killer's Death/Kill Position is Indicated By a Point, And Color Indicates Time of Death.
##Commented Out, Don't Execute These Since it Will Take Time to Process
#plotVictim <- gganimate(ggplot(data.map2) +
#                          annotation_custom(rasterGrob(img, width = unit(1,"npc"), height = unit(1,"npc")), -Inf, Inf, -Inf, Inf) +
#                          geom_point(aes(x = victim_x, y = victim_y, frame = time, color = time, cumulative = TRUE)) +
#                          scale_color_gradientn(colours = rainbow(5)) +
#                          xlab("X coordinate") +
#                          ylab("Y coordinate") +
#                          ggtitle("Victim Deaths Over Time || Elapsed time in minutes: ") +
#                          scale_y_continuous(expand = c(0, 0), limits = c(0, 1000)) +
#                          scale_x_continuous(expand = c(0, 0), limits = c(0, 1000)), "victim_time_heat.gif")

#plotKiller <- gganimate(ggplot(data.map2) +
#                          annotation_custom(rasterGrob(img, width = unit(1,"npc"), height = unit(1,"npc")), -Inf, Inf, -Inf, Inf) +
#                          geom_point(aes(x = killer_x, y = killer_y, frame = time, color = time, cumulative = TRUE)) +
#                          scale_color_gradientn(colours = rainbow(5)) +
#                          xlab("X coordinate") +
#                          ylab("Y coordinate") +
#                          ggtitle("Killer Deaths Over Time || Elapsed time in minutes: ") +
#                          scale_y_continuous(expand = c(0, 0), limits = c(0, 1000)) +
#                          scale_x_continuous(expand = c(0, 0), limits = c(0, 1000)), "killer_time_heat.gif")

#Heatmap Indicating Killer vs Victim Position, Looking For Anomalies.
#plotBoth <- gganimate(ggplot(data.map2) +
#                        geom_point(aes(x = killer_x, y = killer_y, frame = time, color = "orange", alpha = 0.01, cumulative = TRUE)) +
#                        geom_point(aes(x = victim_x, y = victim_y, frame = time, color = "blue", alpha = 0.01, cumulative = TRUE)) +
#                        theme_void() +
#                        theme(plot.background = element_rect(fill = "black")) +
#                        scale_y_continuous(expand = c(0, 0), limits = c(0, 1000)) +
#                        scale_x_continuous(expand = c(0, 0), limits = c(0, 1000)), "event_diff.gif")

#Renders Image on GIF
#plotImage <- annotation_custom(rasterGrob(img, width = unit(1,"npc"), height = unit(1,"npc")), -Inf, Inf, -Inf, Inf)