library(dplyr)
library(tidyr)
library(ggplot2)
library(jpeg)
library(data.table)
library(devtools)
#devtools::install_github("dgrtwo/gganimate")
library("gganimate")
#install.packages("magick")
library(magick)
library(grid)
#setwd("~/INFO 201/FINAL/operaturtle")
data.in <- read.csv("data/f_miramar.csv")

img <- readJPEG("data/miramar.jpg")

##########################################################################
### Filtering Dataset
##########################################################################

#Extracting Invidiual Values into Tables   mutate(X = X / max(X, na.rm=TRUE)) %>% 

data.players <- data.frame("Player" = paste0("Player: ", c(0:99)))

## Storing Victim Position Data.

# The x coordinates are flipped in the data set thus we flip them around.
data.victim.x <- select(data.in, contains("x")) %>% 
  select(contains("victim")) %>% 
  gather(Player, victim_x, deaths_0_victim_position_x:deaths_9_victim_position_x) %>% 
  mutate(victim_x = 100 - victim_x / 800000 * 100)

data.victim.y <- select(data.in, contains("y")) %>% 
  select(contains("victim")) %>% 
  gather(Player, victim_y, deaths_0_victim_position_y:deaths_9_victim_position_y) %>% 
  mutate(victim_y = victim_y / 800000 * 100)

# Storing Killer position Data.
data.killer.x <-  select(data.in, contains("x")) %>% 
  select(contains("killer")) %>% 
  gather(Player, killer_x, deaths_0_killer_position_x:deaths_9_killer_position_x) %>% 
  mutate(killer_x = 100 - killer_x / 800000 * 100)

data.killer.y <- select(data.in, contains("y")) %>% 
  select(contains("killer")) %>% 
  gather(Player, killer_y, deaths_0_killer_position_y:deaths_9_killer_position_y) %>% 
  mutate(killer_y = killer_y / 800000 * 100)

# Storing Time Data in seconds
data.time <- select(data.in, contains("time")) %>% 
  gather(Player, time, deaths_0_time_event:deaths_9_time_event) %>% 
  mutate(time = ceiling(time / 60))

# Storing weapon used.
data.weapon <- select(data.in, contains("description")) %>% 
  gather(Player, weapon, deaths_0_description:deaths_9_description)

# Combine everything into one data frame.
data.map <- data.frame(data.victim.x, data.victim.y, data.killer.x, data.killer.y, data.time, data.weapon)

# Drop rows which contain column names
data.map <- select(data.map,
                   time,
                   victim_x, victim_y,
                   weapon,
                   killer_x, killer_y)

# Finding unique death types.
weapon.types <- unique(data.map$weapon)

##########################################################################
### Sepereating Weapon Table
##########################################################################

data.weapon.sniper <- filter(data.weapon, grepl('AWM|M24|Kar98k|Win94|MK14|SLR|SKS|Mini 14|VSS', Weapon)) %>% 
  mutate(Type = "Sniper & DMR")

data.weapon.rifle <- filter(data.weapon, grepl('Groza|AKM|DP-28|M249|AUG|M16A4|M416|Scar-L', Weapon)) %>% 
  mutate(Type = "AR & LMG")

data.weapon.smg <- filter(data.weapon, grepl('Tommy Gun|UMP|Vector|UZI', Weapon)) %>% 
  mutate(Type = "SMG")

data.weapon.shotgun <- filter(data.weapon, grepl('S686|S1897|S12k', Weapon)) %>% 
  mutate(Type = "Shotgun")

data.weapon.pistol <- filter(data.weapon, grepl('Sawed-off|R1895|R45|P1911|P92|P18C', Weapon)) %>% 
  mutate(Type = "Pistol")

data.weapon.melee <- filter(data.weapon, grepl('Crossbow|Pan|Machete|Crowbar|Sickle|Superman Punch|Punch', Weapon)) %>% 
  mutate(Type = "Melee / Other")

data.weapon.vehicle <- filter(data.weapon, grepl('PickupTruck|Buggy|HitbyCar|Motorbike|Boat|Motorbike(SideCar)|Dacia|death.BP_PickupTruck_B_01_C|death.BP_Van_A_03_C|Uaz', Weapon)) %>% 
  mutate(Type = "Vehicle")

data.weapon.areadamage <- filter(data.weapon, grepl('death.ProjMolotov_DamageField_C|Grenade|death.Buff_FireDOT_C|"death.ProjMolotov_C', Weapon)) %>% 
  mutate(Type = "Area Damage")

data.weapon.environment <- filter(data.weapon, grepl('DownandOut|Drown|RedZone|death.RedZoneBomb_C|Bluezone|Falling', Weapon)) %>% 
  mutate(Type = "environment")

##########################################################################
### Graphing Plots and Maps
##########################################################################

data.map2 <- na.omit(data.map)


# Heat map of victim/killer's death position is indicated by a point, and color indicates time of death.

gganimate(ggplot(data.map2) +
            annotation_custom(rasterGrob(img, 
                                         width = unit(1,"npc"), 
                                         height = unit(1,"npc")), 
                              -Inf, Inf, -Inf, Inf) +
            geom_point(aes(x = victim_x, y = victim_y, frame = time, color = time, cumulative = TRUE)) +
            scale_color_gradientn(colours = rainbow(5)) +
            xlab("X coordinate") +
            ylab("Y coordinate") +
            ggtitle("Victim Deaths Over Time || Elapsed time in minutes: "), "victim_time_heat.gif")

gganimate(ggplot(data.map2) +
                               annotation_custom(rasterGrob(img, 
                                                            width = unit(1,"npc"), 
                                                            height = unit(1,"npc")), 
                                                 -Inf, Inf, -Inf, Inf) +
                               geom_point(aes(x = killer_x, y = killer_y, frame = time, color = time, cumulative = TRUE)) +
                               scale_color_gradientn(colours = rainbow(5)) +
            xlab("X coordinate") +
            ylab("Y coordinate") +
            ggtitle("Killer Deaths Over Time || Elapsed time in minutes: "), "killer_time_heat.gif")

# Heat map indicating killer vs victim position, looking for anomalies.

gganimate(ggplot(data.map2) +
                              geom_point(aes(x = killer_x, y = killer_y, frame = time, color = "blue", alpha = 0.000001, cumulative = TRUE)) +
                              geom_point(aes(x = victim_x, y = victim_y, frame = time, color = "black", alpha = 0.000001, cumulative = TRUE)) +
                              theme_void() +
                              theme(plot.background = element_rect(fill = "black")),
                            "event_diff.mp4")













gganimate(ggplot(data.map2, aes(x = X, y = Y, frame = Time, color = Weapon, cumulative = TRUE)) +
            annotation_custom(rasterGrob(img, 
                                         width = unit(1,"npc"), 
                                         height = unit(1,"npc")), 
                              -Inf, Inf, -Inf, Inf) +
            geom_point(aes(frame = Time)) + 
            theme(legend.position="none"), interval = 0.2, "weapon_heat.gif")
gg_anim
heatmap
library(gapminder)
p <- ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, color = continent, frame = year)) +
  geom_point() +
  scale_x_log10()
gganimate(p, interval = 0.1)


#

annotation_custom(rasterGrob(img, 
                             width = unit(1,"npc"), 
                             height = unit(1,"npc")), 
                  -Inf, Inf, -Inf, Inf)
