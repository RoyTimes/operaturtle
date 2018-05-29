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

#Extracting Invidiual Values into Tables   mutate(X = X / max(X, na.rm=TRUE)) %>% 

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
  gather(Player, Weapon, deaths_10_description:deaths_9_description)

data.map <- data.frame(data.x, data.y, data.time)

#View(data.map)

##########################################################################
### Graphing Plots and Maps
##########################################################################

#Heatmap

heatmap <- ggplot(data.map, aes(x = X, y = Y, fill = Time)) +
  geom_tile()

heatmap
