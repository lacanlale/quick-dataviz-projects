library(ggforce)
library(ggridges)
library(dplyr)
library(broom)
library(lubridate)
library(patchwork)
library(tidyverse)
library(purrr)
library(readr)

base_url <- "https://raw.githubusercontent.com/adrian3/Boston-Marathon-Data-Project/refs/heads/master/"
gender_colors <- c("M" = "#347DC1", "F" = "#E6A6C7")

years <- 1900:2014
file_urls <- paste0(base_url, "results", years, ".csv")

combined_data <- file_urls |>
  set_names(years) |>
  map_dfr(read_csv, .id = "Year")

combined_data <- combined_data |>
  filter(gender != "U")

combined_data$Year <- as.integer(combined_data$Year)

combined_data <- combined_data |>
  mutate(decade = paste0(floor(Year / 10) * 10, "s"))

total_per_year <- combined_data |> 
  count(decade, gender) |>
  group_by(decade)

historical_participants <- total_per_year |>
  ggplot(aes(x=n, y=decade, fill=gender)) +
  geom_col(position="stack") +
  guides(fill = "none") +
  labs(title="A) Total Participants per Decade") +
  scale_x_continuous(name="Total Participants") +
  scale_y_discrete(name="Race Decade") + 
  scale_fill_manual(values=gender_colors)

overall_winners <- combined_data |>
  filter(gender_result==1)

overall_bests <- overall_winners |>
  ggplot(aes(x=Year, y=official_time, color=gender, group=gender)) + 
  geom_point(alpha=0.5) +
  geom_smooth(method='lm') +
  labs(title="C) Best finish times per Year") +
  guides(
    color = "none",
    group = "none"
  ) +
  scale_y_time(name="Official Finish Time") +
  scale_x_continuous(name="Race Year") + 
  scale_color_manual(values=gender_colors) + 
  scale_fill_manual(values=gender_colors)

gender_finish_densities <- combined_data |>
  ggplot(aes(x=official_time, y=factor(decade), color=gender, fill=gender)) +
  geom_density_ridges(alpha=0.4, rel_min_height = 0.001) +
  labs(title="B) Density ridges of official finish times") +
  guides(
    color = guide_legend(title="Gender", override.aes = list(alpha = 1)),
    fill = guide_legend(title="Gender", override.aes = list(alpha = 1))
  ) +
  scale_x_time(name="Official Finish Time") +
  scale_y_discrete(name="") + 
  scale_color_manual(values=gender_colors) + 
  scale_fill_manual(values=gender_colors)

((historical_participants + gender_finish_densities) / overall_bests) +
  plot_layout(guides = "collect") +
  plot_annotation(
    title = 'Overview of Boston Marathon finish times from 1900-2014',
    subtitle = 'Colors distinguished by gender',
    caption = 'Source: Boston-Marathon-Data-Project available on Github by user adrian3'
  )