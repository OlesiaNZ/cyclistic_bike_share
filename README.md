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

14. Separate started_at column into 2 columns started_date with date format year-month-day and started_time with time format hour:minutes:seconds
