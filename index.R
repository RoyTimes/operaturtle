library(dplyr)
library(tidyr)
library(ggplot2)
library(ggmap)
library(jpeg)
library(data.table)

data.in <- read.csv("data/output.csv")

img <- readJPEG("data/erangel.jpg")

##########################################################################
### Filtering Dataset
##########################################################################

#Extracting Invidiual Values into Tables

data.players <- data.frame("Player" = paste0("Player: ", c(0:99)))

data.x <- select(data.in, contains("x")) %>% 
  select(contains("victim")) %>% 
  gather(Player, X, deaths_0_victim_position_x:deaths_9_victim_position_x) %>% 
  mutate(X = (X - min(X, na.rm=TRUE)) / (max(X, na.rm=TRUE) - min(X, na.rm=TRUE)))

data.y <- select(data.in, contains("y")) %>% 
  select(contains("victim")) %>% 
  gather(Player, Y, deaths_0_victim_position_y:deaths_9_victim_position_y) %>% 
  mutate(Y = (Y - min(Y, na.rm=TRUE)) / (max(Y, na.rm=TRUE) - min(Y, na.rm=TRUE)))

data.time <- select(data.in, contains("time")) %>% 
  gather(Player, Time, deaths_0_time_event:deaths_9_time_event) %>% 
  mutate(Time = (Time - min(Time, na.rm=TRUE)) / (max(Time, na.rm=TRUE) - min(Time, na.rm=TRUE)))

data.weapon <- select(data.in, contains("description")) %>% 
  gather(Player, Weapon, deaths_10_description:deaths_9_description) %>% 
  mutate(Attr = contains("SKS"))

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
### Joing Extracted Varaibles To Desired Tables
##########################################################################

#data.classification <- left_join(data.weapon.melee, data.weapon.pistol)

data.map <- data.frame(data.x, data.y, data.time)

#View(data.map)

##########################################################################
### Graphing Plots and Maps
##########################################################################



