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

# Check that all values in user_type are member or casual
if (all(data_frame_2023$user_type %in% c("member", "casual"))) {
   print("All values in user_type are member or casual")
} else {
   print("Not all values in user_type are member or casual")
}

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

# Rename member_casual column to user_type
data_frame_2023 <- rename(data_frame_2023, user_type = member_casual)
view(head(data_frame_2023, 50))

# Convert started_at and ended_at from character to date format
data_frame_2023$started_at <- as.POSIXct(data_frame_2023$started_at, format = "%Y-%m-%d %H:%M:%S")
data_frame_2023$ended_at <- as.POSIXct(data_frame_2023$ended_at, format = "%Y-%m-%d %H:%M:%S")

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

# Subset the data frame to keep only rows where ended_at >= started_at
data_frame_2023 <- data_frame_2023[data_frame_2023$ended_at >= data_frame_2023$started_at, ]
print(nrow(data_frame_2023))

# Run these functions again with correct data
view(summary(data_frame_2023[c('ride_length')]))
min(data_frame_2023$ride_length)

# Separate started_at and ended_at to date and time
data_frame_2023 <- data_frame_2023 %>%
  separate(col = started_at, into = c("started_date", "started_time"), sep = " ") %>%
  separate(col = ended_at, into = c("ended_date", "ended_time"), sep = " ")

# Convert date columns to Date type and time columns to POSIXct type
data_frame_2023$started_date <- as.Date(data_frame_2023$started_date, format = "%Y-%m-%d")
data_frame_2023$started_time <- as.POSIXct(data_frame_2023$started_time, format = "%H:%M:%S")
data_frame_2023$ended_date <- as.Date(data_frame_2023$ended_date, format = "%Y-%m-%d")
data_frame_2023$ended_time <- as.POSIXct(data_frame_2023$ended_time, format = "%H:%M:%S")
view(head(data_frame_2023, 50))

# Create day_of_week
data_frame_2023 <- mutate(data_frame_2023, day_of_week = weekdays(data_frame_2023$started_date))
view(head(data_frame_2023, 1000))

# Descriptive analysis on ride_length
mean_ride_length <- mean(data_frame_2023$ride_length)
max_ride_length <- max(data_frame_2023$ride_length)
min_ride_length <- min(data_frame_2023$ride_length)
# Calculate max in hours as in minutes the number is too big
max_ride_length_in_hour <- max(data_frame_2023$ride_length)/60

# Print the results
cat("Mean ride length:", mean_ride_length,"minutes","\n")
cat("Max ride length:", max_ride_length,"minutes","\n")
cat("Max ride length:", max_ride_length_in_hour,"hours","\n")
cat("Min ride length:", min_ride_length,"minutes","\n")

# Calculate the mode of day_of_week
table_day_of_week <- table(data_frame_2023$day_of_week) # Use table to count the occurrences of each unique value
mode_index <- which.max(table_day_of_week) # Find the index of the maximum count (mode)
mode_value <- as.character(names(table_day_of_week)[mode_index]) # Get the mode value

cat("Mode:", mode_value, "\n")

# Calculate the average ride_length in minutes for members and casual riders.
average_ride_length <- data_frame_2023 %>%
  group_by(user_type) %>%
  summarize(average_ride_length = mean(ride_length))
print(average_ride_length)  

# Calculate the average ride_length for users by day_of_week.
# Sort by user_type and day_of_week from Monday to Sunday
average_ride_by_weekday <- data_frame_2023 %>%
  group_by(user_type, day_of_week) %>%
  summarize(average_ride_by_weekday = mean(ride_length))%>%
  mutate(day_of_week = factor(day_of_week, levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"), ordered = TRUE)) %>%
  arrange(user_type, day_of_week)
print(average_ride_by_weekday) 

# Calculate the number of rides for users by day_of_week
number_of_rides <- data_frame_2023 %>%
  group_by(user_type, day_of_week) %>%
  mutate(day_of_week = factor(day_of_week, levels = c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"), ordered = TRUE)) %>%
  summarize(number_of_rides = n())
print(number_of_rides)

colnames(data_frame_2023)

# Compare members and casual users
aggregate(data_frame_2023$ride_length ~ data_frame_2023$user_type, FUN = mean)
aggregate(data_frame_2023$ride_length ~ data_frame_2023$user_type, FUN = median)
aggregate(data_frame_2023$ride_length ~ data_frame_2023$user_type, FUN = max)
aggregate(data_frame_2023$ride_length ~ data_frame_2023$user_type, FUN = min)

# Calculate mean, median, max ride lengths for each day of week
aggregate(data_frame_2023$ride_length ~ data_frame_2023$day_of_week, FUN = mean)
aggregate(data_frame_2023$ride_length ~ data_frame_2023$day_of_week, FUN = median)
aggregate(data_frame_2023$ride_length ~ data_frame_2023$day_of_week, FUN = max)

# Make the days of the week are in order
data_frame_2023$day_of_week <- ordered(data_frame_2023$day_of_week, levels=c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))

# See the average ride time by each day for members vs casual users
view(aggregate(data_frame_2023$ride_length ~ data_frame_2023$user_type + data_frame_2023$day_of_week, FUN = mean))

# Visualization the number of rides by rider type
data_frame_2023 %>% 
  group_by(user_type, day_of_week) %>% 
  summarise(number_of_rides = n()) %>% 
  arrange(user_type, day_of_week)  %>% 
  ggplot(aes(x = day_of_week, y = number_of_rides, fill = user_type)) + geom_col(position = "dodge")

# Visualization for average duration
data_frame_2023 %>% 
  group_by(user_type, day_of_week) %>% 
  summarise(number_of_rides = n(),
            average_duration = mean(ride_length)) %>% 
  arrange(user_type, day_of_week)  %>% 
  ggplot(aes(x = day_of_week, y = average_duration , fill = user_type)) + geom_col(position = "dodge")

write.csv(data_frame_2023, file = 'data_frame_2023.csv')

data_frame_2023$ride_length <- round(data_frame_2023$ride_length, digits = 2)
view(head(data_frame_2023, 50))

# Check if the months in the 'started_date' and 'ended_date' columns are the same
data_frame_2023 <- data_frame_2023 %>%
  mutate(start_month = format(started_date, "%m"),
         end_month = format(ended_date, "%m"),
         months_match = ifelse(start_month == end_month, "Yes", "No"))

view(filter(data_frame_2023, months_match == "No"))

data_frame_2023$started_time <- format(data_frame_2023$started_time, "%H:%M:%S")
data_frame_2023$ended_time <- format(data_frame_2023$ended_time, "%H:%M:%S")
