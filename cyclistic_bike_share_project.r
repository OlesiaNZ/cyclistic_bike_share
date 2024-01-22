install.packages("tidyverse")
library(tidyverse)
install.packages("janitor")
library(janitor)


data_frame_jan <- read.csv("Trip_data_01_2023.csv")
# Test that csv file loaded into var
view(head(data_frame_jan, 5))
