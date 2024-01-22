install.packages("tidyverse")
library(tidyverse)
install.packages("janitor")
library(janitor)


data_frame_jan <- read.csv("Trip_data_01_2023.csv")
# Test that csv file loaded into var
view(head(data_frame_jan, 5))
data_frame_feb <- read.csv("Trip_data_02_2023.csv")
data_frame_mar <- read.csv("Trip_data_03_2023.csv")
data_frame_apr <- read.csv("Trip_data_04_2023.csv")
data_frame_may <- read.csv("Trip_data_05_2023.csv")
data_frame_june <- read.csv("Trip_data_06_2023.csv")
data_frame_july <- read.csv("Trip_data_07_2023.csv")
data_frame_aug <- read.csv("Trip_data_08_2023.csv")
data_frame_sept <- read.csv("Trip_data_09_2023.csv")
data_frame_oct <- read.csv("Trip_data_10_2023.csv")
data_frame_nov <- read.csv("Trip_data_11_2023.csv")
data_frame_dec <- read.csv("Trip_data_12_2023.csv")

