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

# Use mutate and separate to create 'started_date' and 'started_time' columns
data_frame_2023 <- data_frame_2023 %>%
  mutate(started_at = as.character(started_at)) %>%
  separate(started_at, into = c("started_date", "started_time"), sep = " ")

# Convert 'started_date' to Date type and 'started_time' to POSIXct type
data_frame_2023$started_date <- as.Date(data_frame_2023$started_date)
data_frame_2023$started_time <- as.POSIXct(data_frame_2023$started_time, format = "%H:%M:%S")

# Do the same with ended_at column
data_frame_2023 <- data_frame_2023 %>%
  mutate(ended_at = as.character(ended_at)) %>%
  separate(ended_at, into = c("ended_date", "ended_time"), sep = " ")
data_frame_2023$ended_date <- as.Date(data_frame_2023$ended_date)
data_frame_2023$ended_time <- as.POSIXct(data_frame_2023$ended_time, format = "%H:%M:%S")

# View the resulting data frame
view(head(data_frame_2023, 50))

# Create ride_length
data_frame_2023 <- mutate(data_frame_2023, ride_length = as.numeric(difftime(data_frame_2023$ended_time, data_frame_2023$started_time, units = "mins")))

# Create day_of_week
data_frame_2023 <- mutate(data_frame_2023, day_of_week = weekdays(data_frame_2023$started_date))

# Calculate the mean and max of ride_length
mean_ride_length <- mean(data_frame_2023$ride_length)
max_ride_length <- max(data_frame_2023$ride_length)
# Calculate max in hours as in minutes the number is too big
max_ride_length_in_hour <- max(data_frame_2023$ride_length)/60


# Print the results
cat("Mean ride length:", mean_ride_length,"minutes","\n")
cat("Max ride length:", max_ride_length,"minutes","\n")
cat("Max ride length:", max_ride_length_in_hour,"hours","\n")

# Calculate the mode of day_of_week

table_day_of_week <- table(data_frame_2023$day_of_week) # Use table to count the occurrences of each unique value

mode_index <- which.max(table_day_of_week) # Find the index of the maximum count (mode)

mode_value <- as.character(names(table_day_of_week)[mode_index]) # Get the mode value

# Print the mode
cat("Mode:", mode_value, "\n")
