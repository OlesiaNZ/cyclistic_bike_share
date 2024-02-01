# cyclistic_bike_share
Cyclistic bike-share analysis case study

## About the company
In 2016, Cyclistic introduced a successful bike-sharing service, which has since expanded to include a fleet of 5,824 bicycles tracked by geolocation technology. The bikes are securely locked at 692 stations throughout Chicago, allowing users to unlock them at one station and return them to any other station within the network at their convenience. Up until now, Cyclistic's marketing strategy focused on creating general awareness and appealing to a wide range of consumers. A key factor enabling this success has been the adaptable nature of its pricing plans, including options such as single-ride passes, full-day passes, and annual memberships. Casual riders, who opt for single-ride or full-day passes, and Cyclistic members, who choose annual memberships, comprise the customer base.

# Steps
1. Rename 12 datasets from **202301-divvy-tripdata.csv** to **Trip_data_01_2023.csv**

2. Add raw 12 csv files to GitHub using command `git add *.csv`

3. Files were too big for regular GitHub, use [Git LFS](https://git-lfs.com/) for adding:
     - `git lfs install`
     - `git lfs track *.csv`
     - `git add .gitattributes`
     - then as usual: `git add`, `git commit`, `git push`

4. Install tidyverse, which includes ggplot2, tidyr, readr, dplyr, stringr, purrr, and forcats. 

5. For debian-like linux install dependencies using command: `sudo apt-get install libxml2-dev libcurl4-openssl-dev libssl-dev libfontconfig1-dev libharfbuzz-dev libfribidi-dev libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev`

6. Import 12 csv files to 12 data frames in R and do a test to make sure that in works in VS Code

7. Create a list of 12 data frames to check if all data frames have the same column names.

8. Do the checking using `if-else`

9. Clean column names for each data frame in the list
``` {r}
clean_data_frames_list <- map(data_frames_list, ~clean_names(.)) 
```

10. Another option to do the same with `compare_df_cols_same` function. It returns TRUE

11. Combine 12 datasets into 1 dataset using `rbind()`

12. Hunting down and examining duplicate records during data cleaning using `get_dupes()` function

13. Remove rows with missing value

14. Remove these columns: start_station_id, end_station_id, start_lat, start_lng, end_lat, end_lng, start_station_name, end_station_name as they don't impact on analysis 

15. Convert started_at and ended_at from character to date format

16. Create ride_length

17. Find and remove 353 raws with mistakes in data when ended_at are not greater than started_at

18. Getting result after this function:
```{r}
view(summary(data_frame_2023[c('ride_length')]))
```
Result:

Min. : 0.000 min

1st Qu.: 5.417 min

Median : 9.517 min

Mean : 15.159 min

3rd Qu.: 16.883 min 

Max. :12136.300 min 

19. Separate started_at and ended_at to date and time and convert date columns to Date type and time columns to POSIXct type

20. Create column day_of_week which has the day of the week that each ride
started

21. Calculate the mean and max of ride_length:
``` {r}
mean_ride_length <- mean(data_frame_2023$ride_length)
max_ride_length <- max(data_frame_2023$ride_length) 
```
22.  Calculate the mode of day_of_week
``` {r}
# Use table to count the occurrences of each unique value
table_day_of_week <- table(data_frame_2023$day_of_week) 

# Find the index of the maximum count (mode)
mode_index <- which.max(table_day_of_week) 

# Get the mode value
mode_value <- as.character(names(table_day_of_week)[mode_index]) 
```

23. Calculate the average ride_length in minutes for members and casual riders.  
See the result:

| member_casual | ride_length|
| ------------  |  --------  | 
| casual        |    20.7 min|
| member        |    12.1 min| 

24. Calculate the average ride_length for users by day_of_week.
See the result:

 | member_casual |   day_of_week  |  ride_length  |
 | --------      | ---------------|-------------- |
 |  casual       |    Monday      |    20.3 min   |
 |  casual       |    Tuesday     |    18.5 min   |
 |  casual       |    Wednesday   |    17.7 min   |
 |  casual       |    Thursday    |    18.0 min   |
 |  casual       |    Friday      |    20.0 min   |
 |  casual       |    Saturday    |    23.4 min   |
 |  casual       |    Sunday      |    24.0 min   |
 |  member       |    Monday      |    11.5 min   |
 |  member       |    Tuesday     |    11.6 min   |
 |  member       |    Wednesday   |    11.5 min   |
 |  member       |    Thursday    |    11.6 min   |
 |  member       |    Friday      |    12.0 min   |
 |  member       |    Saturday    |    13.4 min   |
 |  member       |    Sunday      |    13.5 min   |
    

25. Calculate the number of rides for users by day_of_week
See the result:

  | member_casual  |  day_of_week      | number of rides   |  
  |--------------- |  ---------------  | ----------------- |
  |    casual      |    Monday         |      234'188      |
  |    casual      |    Tuesday        |      245'591      |
  |    casual      |    Wednesday      |      248'555      |
  |    casual      |    Thursday       |      269'900      |
  |    casual      |    Friday         |      311'063      |
  |    casual      |    Saturday       |      409'393      |
  |    casual      |    Sunday         |      334'428      |
  |    member      |    Monday         |      494'417      |
  |    member      |    Tuesday        |      576'577      |
  |    member      |    Wednesday      |      586'273      |
  |    member      |    Thursday       |      589'402      |
  |    member      |    Friday         |      531'415      |
  |    member      |    Saturday       |      472'682      |
  |    member      |    Sunday         |      408'650      |



