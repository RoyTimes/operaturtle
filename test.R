library(ggplot2)
library(jpeg)
library(ggmap)

img <- readJPEG("data/erangel.jpg")
g <- ggimage(img, fullpage = FALSE, scale_axes = TRUE)

g
