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

gp_1 <- ggplot(day_of_week, aes(x = reorder(day_of_week, day_order), 
                        y = num_rides,
                        fill = num_rides,
                        width = 0.6)) + 
  geom_bar(stat = 'identity',
           fill = c("#00BFC4"),
           color = "black") +
  geom_label(aes(label = scales::comma(num_rides)),
             fill = NA,
             size = 3,
             vjust = -0.1,
             position = position_stack(vjust = 1),
             label.size = NA,
             family = "serif") +
  theme_minimal() +
  theme(text = element_text(size = 12),
        title = element_text(size = 11)) +
  theme(axis.text.x = element_text(vjust = 1.5),
        axis.title.y = element_text(vjust = 1.5)) +
  theme(plot.title = element_text(vjust = 1.5)) +
  theme(text = element_text(family = "serif")) +
  labs(x = "Day of Week", 
       y = "Number of rides") +
  ggtitle("Number of rides by day of week") +
  scale_y_continuous(labels = scales::comma) +
  scale_fill_continuous(labels = scales::comma)

# 3.2- Chart 2: Average ride length by Day of week

gp_2 <- ggplot(day_of_week, aes(x = reorder(day_of_week, day_order), 
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
  theme(axis.text.x = element_text(vjust = 1.5),
        axis.title.y = element_text(vjust = 1.5)) +
  theme(plot.title = element_text(vjust = 1.5)) +
  theme(text = element_text(family = "serif")) +
  labs(x = "Day of Week", 
       y = "Average ride length") +
  ggtitle("Average ride length by day of week")

# 3.3- Chart 3: Number of rides by User type

user_type_v4 <- mutate(user_type, perc_num_rides = round(num_rides/ sum(num_rides), digits = 2))

gp_3 <- ggplot(user_type_v4, aes(x = "", 
                                 y = perc_num_rides, 
                                 fill = member_casual,
                                 levels = c("casual", "member"))) +
  theme_minimal() +
  geom_col(color = "black",
           fill = c("#F8766D", "#00BFC4")) +
  geom_label(aes(label = paste0(scales::comma(num_rides), 
                                "\n",
                                "(",
                                scales::percent(perc_num_rides), 
                                ")")),
             position = position_stack(vjust = 0.5),
             vjust = -0.2,
             hjust = 0.8,
             family = "serif",
             label.size = NA,
             size = 3) +
  theme(legend.text = element_text(size = 10),
        legend.key = element_rect(color = "black")) +
  guides(fill = guide_legend(override.aes = aes(label = ""), 
                             byrow = TRUE)) +
  coord_polar(theta = "y") +
  theme(text = element_text(family = "serif")) +
  labs(y = "Percentage of rides",
       x = "",
       title = "Percentage of rides by user type",
       fill = "")

# 3.4- Chart 4: Number of rides by User type during the week

user_type_v5 <- tripdata %>% 
  group_by(day_of_week, member_casual) %>% 
  summarise(num_rides = n_distinct(trip_id))

gp_4 <- ggplot(user_type_v5, aes(x = factor(day_of_week, c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")),
                         y = num_rides,
                         fill = member_casual)) +
  theme_minimal() +
  geom_col(color = "black", 
           position = "dodge2") +
  theme(legend.position = "top",
        legend.justification = "center",
        legend.box.margin = margin(-10,-10,-10,-10),
        legend.text = element_text(size = 10),
        axis.text.x = element_text(vjust = 1.5),
        axis.title.y = element_text(vjust = 1.5)) +
  theme(plot.title = element_text(vjust = 1.5)) +
  theme(text = element_text(family = "serif")) +
  labs(x = "Day of week", 
       y = "Number of rides",
       title = "Number of rides by user type during the week",
       fill = "") +
  geom_text(aes(y = num_rides,
                label = scales::comma(num_rides)),
            size = 3,
            vjust = -0.6,
            position = position_dodge2(width = 0.9),
            family = "serif") +
  scale_y_continuous(labels = scales::comma)
  
# 3.5- Chart 5: Average ride length by User type

gp_5 <- ggplot(user_type, aes(x = member_casual, 
                                y = round(as.duration(avg_ride_length)/60, digits = 2),
                                group = 1)) +
  geom_bar(stat = 'identity',
           fill = c("#F8766D", "#00BFC4"),
           color = "black",
           width = 0.5) +
  geom_label(aes(label = scales::comma(avg_ride_length)),
             fill = NA,
             size = 3,
             vjust = -0.1,
             label.size = NA,
             family = "serif") +
  theme_minimal() +
  theme(axis.text.x = element_text(vjust = 1.5),
        axis.title.y = element_text(vjust = 1.5)) +
  theme(plot.title = element_text(vjust = 1.5)) +
  theme(text = element_text(family = "serif")) +
  labs(x = "User type", 
       y = "Average ride length") +
  ggtitle("Average ride length by user type")

# 3.6- Chart 6: Average ride length by User type during the week

user_type_v2 <- tripdata %>% 
  group_by(day_of_week, member_casual) %>% 
  summarise(avg_ride_length = round(seconds_to_period(mean(as_hms(ride_length))), digits = 0))

user_type_v3 <- pivot_wider(user_type_v2,
                            names_from = member_casual,
                            values_from = avg_ride_length,
                            names_prefix = "avg_ride_length_")

gp_6 <- ggplot(user_type_v3, aes(x = factor(day_of_week, c("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")))) +
  geom_line(mapping = aes(y = as.duration(avg_ride_length_member)/60,
                          color = "member",
                          group = 1)) +
  geom_line(mapping = aes(y = as.duration(avg_ride_length_casual)/60,
                          color = "casual",
                          group = 1)) +
  geom_point(mapping = aes(y = as.duration(avg_ride_length_member)/60,
                           color = "member",
                           group = 1)) +
  geom_point(mapping = aes(y = as.duration(avg_ride_length_casual)/60,
                           color = "casual",
                           group = 1)) +
  theme_minimal() +
  scale_y_continuous(limits = c(0,45)) + 
  theme(legend.position = "top",
        legend.justification = "center",
        legend.box.margin = margin(-10,-10,-10,-10),
        legend.text = element_text(size = 10),
        axis.text.x = element_text(vjust = 1.5),
        axis.title.y = element_text(vjust = 1.5)) +
  theme(plot.title = element_text(vjust = 1.5)) +
  theme(text = element_text(family = "serif")) +
    labs(x = "Day of week", 
       y = "Average ride length",
       title = "Average ride length by user type during the week",
       color = "") +
  geom_text(aes(y = round(as.duration(avg_ride_length_casual)/60, digits = 2),
                label = scales::comma(avg_ride_length_casual)),
            size = 3,
            vjust = -1,
            family = "serif") +
  geom_text(aes(y = round(as.duration(avg_ride_length_member)/60, digits = 2),
                label = scales::comma(avg_ride_length_member)),
            size = 3,
            vjust = -1,
            family = "serif")
