# Packages included:

install.packages("tidyverse")
install.packages("readr")
install.packages("ggplot2")
install.packages("lubridate")
install.packages("hms")
install.packages("dplyr")
install.packages("scales")
library("readr")
library("tidyverse")
library("ggplot2")
library("lubridate")
library("dplyr")
library("hms")
library("scales")

# 1- Load dataset into RStudio:

tripdata <- read.csv("tripdata_cleaned.csv")

# 2- Create two sub-datasets as references for visualization

# 2.1- Average ride length and Total rides by Day of week

day_of_week <- tripdata %>% 
  group_by(day_of_week) %>% 
  count(day_of_week)
day_of_week <- rename(day_of_week, num_rides = n)

day_of_week_2 <- tripdata %>% 
  group_by(day_of_week) %>% 
  summarise(avg_ride_length = round(seconds_to_period(mean(as_hms(ride_length))), digits = 0))
day_of_week_2 <- subset(day_of_week_2, select = -c(day_of_week))

day_of_week <- cbind(day_of_week, day_of_week_2)

remove(day_of_week_2)

order <- c(6, 2, 7, 1, 5, 3, 4)
day_of_week <- cbind(day_of_week, order)

day_of_week <- rename(day_of_week, day_order = ...4)
day_of_week <- arrange(day_of_week, day_order)

# 2.1- Average ride length and Total rides by User type

user_type <- tripdata %>% 
  group_by(member_casual) %>% 
  summarise(avg_ride_length = round(seconds_to_period(mean(as_hms(ride_length))), digits = 0))

user_type_2 <- tripdata %>% 
  group_by(member_casual) %>% 
  count(member_casual)
user_type_2 <- subset(user_type_2, select = -(member_casual))

user_type <- cbind(user_type, user_type_2)
user_type <- rename(user_type, num_rides = n)

remove(user_type_2)

# 3- Create charts from these two sub-datasets

# 3.1- Chart 1: Number of rides by Day of week

ggplot(day_of_week, aes(x = reorder(day_of_week, day_order), 
                        y = num_rides,
                        fill = num_rides,
                        width = 0.6)) + 
  geom_bar(stat = 'identity',
           fill = "white",
           color = "black") +
  geom_label(aes(label = scales::comma(num_rides)),
             fill = NA,
             size = 3,
             vjust = -0.2,
             label.size = NA,
             family = "serif") +
  theme_minimal() +
  theme(text = element_text(size = 12),
        title = element_text(size = 11)) +
  theme(axis.text.x = element_text(vjust = 2.5),
        axis.title.y = element_text(vjust = 2.5)) +
  theme(plot.title = element_text(vjust = 2.5)) +
  theme(text = element_text(family = "serif")) +
  labs(x = "Day of Week", 
       y = "Number of rides") +
  ggtitle("Number of rides by day of week") +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_continuous(labels = scales::comma)

# 3.2- Chart 2: Average ride length by Day of week

ggplot(day_of_week, aes(x = reorder(day_of_week, day_order), 
                                  y = round(as.duration(avg_ride_length)/60, digits = 2),
                                  group = 1)) +
  geom_point() +
  geom_line() +
  geom_label(aes(label = scales::comma(avg_ride_length)),
             fill = NA,
             size = 3,
             vjust = -0.5,
             label.size = NA,
             family = "serif") +
  scale_y_continuous(limits = c(10,25)) +
  theme_minimal() +
  theme(axis.text.x = element_text(vjust = 2.5),
        axis.title.y = element_text(vjust = 2.5)) +
  theme(plot.title = element_text(vjust = 2.5)) +
  theme(text = element_text(family = "serif")) +
  labs(x = "Day of Week", 
       y = "Average ride length") +
  ggtitle("Average ride length by day of week")

# 3.3- Chart 3: Number of rides by User type

gp_3 <- ggplot(user_type, aes(x = member_casual, 
                                y = num_rides,
                                fill = num_rides,
                                width = 0.6)) + 
  geom_bar(stat = 'identity',
           fill = "white",
           color = "black") +
  geom_label(aes(label = scales::comma(num_rides)),
             fill = NA,
             size = 3,
             vjust = -0.2,
             label.size = NA,
             family = "serif") +
  theme_minimal() +
  theme(text = element_text(size = 12),
        title = element_text(size = 11)) +
  theme(axis.text.x = element_text(vjust = 2.5),
        axis.title.y = element_text(vjust = 2.5)) +
  theme(plot.title = element_text(vjust = 2.5)) +
  theme(text = element_text(family = "serif")) +
  labs(x = "User type", 
       y = "Number of rides") +
  ggtitle("Number of rides by user type") +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_continuous(labels = scales::comma)
  
# 3.4- Chart 4: Average ride length by User type

gp_4 <- ggplot(user_type, aes(x = member_casual, 
                                y = round(as.duration(avg_ride_length)/60, digits = 2),
                                group = 1)) +
  geom_bar(stat = 'identity',
           fill = "white",
           color = "black",
           width = 0.5) +
  geom_label(aes(label = scales::comma(avg_ride_length)),
             fill = NA,
             size = 3,
             vjust = -0.5,
             label.size = NA,
             family = "serif") +
  theme_minimal() +
  theme(axis.text.x = element_text(vjust = 2.5),
        axis.title.y = element_text(vjust = 2.5)) +
  theme(plot.title = element_text(vjust = 2.5)) +
  theme(text = element_text(family = "serif")) +
  labs(x = "User type", 
       y = "Average ride length") +
  ggtitle("Average ride length by user type")
