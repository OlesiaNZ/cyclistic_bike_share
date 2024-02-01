install.packages("tidyverse")
library(tidyverse)
install.packages("janitor")
library(janitor)
install.packages("lubridate")
library(lubridate)


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

# Create a list of data frames
data_frames_list <- list(data_frame_jan, data_frame_feb, data_frame_mar, data_frame_apr,
                data_frame_may, data_frame_june, data_frame_july, data_frame_aug,
                data_frame_sept, data_frame_oct, data_frame_nov, data_frame_dec)

# Check if all data frames have the same column names
all_same_columns <- all(sapply(data_frames_list[-1], function(df) identical(colnames(data_frame_jan), colnames(df))))

if (all_same_columns) {
  print("All data frames have the same column names.")
} else {
  print("Some data frames have different column names.")
}

#Another option to do the same with compare_df_cols_same function. It returns TRUE
compare_df_cols_same(data_frames_list)

# Clean column names for each data frame in the list
clean_data_frames_list <- map(data_frames_list, ~clean_names(.))
# Now clean_data_frames_list contains data frames with cleaned column names
names(clean_data_frames_list[[1]])

# Row-wise merge for a list of data frames
data_frame_2023 <- do.call(rbind, clean_data_frames_list )

# Check the merged dataset
view(head(data_frame_2023, 10))


# Check for duplicates
 get_dupes(data_frame_2023, ride_id, rideable_type, 
         started_at, ended_at, start_station_name, 
         start_station_id, end_station_name, end_station_id, start_lat, 
         start_lng, end_lat, end_lng)

# Print the number of rows
print(nrow(data_frame_2023))

# Remove rows with NA
data_frame_2023 <- na.omit(data_frame_2023)
print(colSums(is.na(data_frame_2023)))

# Remove some columns
data_frame_2023 <- data_frame_2023  %>% 
    select(-c(start_station_id, end_station_id, start_lat, start_lng, end_lat, end_lng, start_station_name, end_station_name))
colnames(data_frame_2023)
view(head(data_frame_2023, 32))

# Convert started_at and ended_at from character to date format
data_frame_2023$started_at <- as.POSIXct(data_frame_2023$started_at, format = "%Y-%m-%d %H:%M:%S")
data_frame_2023$ended_at <- as.POSIXct(data_frame_2023$ended_at, format = "%Y-%m-%d %H:%M:%S")

str(data_frame_2023)

# Create ride_length
data_frame_2023 <- mutate(data_frame_2023, ride_length = as.numeric(difftime(data_frame_2023$ended_at, data_frame_2023$started_at, units = "mins")))
view(head(data_frame_2023, 52))

view(summary(data_frame_2023[c('ride_length')]))
min(data_frame_2023$ride_length)

view(head(arrange(data_frame_2023, ride_length),100))

data_frame_2023$started_at < data_frame_2023$ended_at

# Validate that ended_at is greater than started_at for all rows
if (all(data_frame_2023$ended_at > data_frame_2023$started_at)) {
  print("All values in ended_at are greater than started_at.")
} else {
  print("There are values in ended_at that are not greater than started_at.")
}

view(head(arrange(data_frame_2023, -ride_length),100))

# Count the number of raws with incorrect data
print(sum(data_frame_2023$ended_at < data_frame_2023$started_at))

# View raws with mistakes
wrong_raws <- data_frame_2023[data_frame_2023$ended_at < data_frame_2023$started_at, ]
view(arrange(wrong_raws, ride_length))
