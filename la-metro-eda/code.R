library(dplyr)
library(lubridate)
library(jsonlite)
library(ggforce)
library(ggplot2)
library(tidyverse)
library(scales)
library(patchwork)

flatten_json <- function(json_data, melted_cols) {
  json_table <-
    bind_rows(
      lapply(json_data, function(months) {
        bind_rows(
          lapply(months, function(x) as.data.frame(x)), .id = "month")
      }
      ), 
      .id = "year")
  
  return(
    pivot_longer(
      data = json_table,
      cols = melted_cols,
      names_to = "type",
      values_to = "count"
    ) |>
      mutate(date = 
               if(is.numeric(month)) { make_date(year = year, month = month, day = 1) }
             else {my(paste(month, year))} 
      )
  )
}

base_url <- "https://raw.githubusercontent.com/LACMTA/data-safety/main/processed/"

arrest_data <- fromJSON(paste0(base_url, "arrests.json"))
arrest_data <- flatten_json(arrest_data, c("bus", "rail"))

crimes_data <- fromJSON(paste0(base_url, "crimes.json"))
crimes_data <- flatten_json(crimes_data, 
                            c(
                              "bus.total",
                              "bus.persons",
                              "bus.property",
                              "bus.society",
                              "rail.total",
                              "rail.persons",
                              "rail.property",
                              "rail.society"
                            )
)

fares_data <- fromJSON(paste0(base_url, "fare.json"))
fares_data <- flatten_json(fares_data, c("bus", "rail"))

ridership_data <- fromJSON(paste0(base_url, "ridership.json"))
ridership_data <- flatten_json(ridership_data, c("bus", "rail"))

ridership_plot <- ridership_data |>
  mutate(
    period = case_when(
      year >= 2020 ~ "Post-Covid",
      year < 2020 ~ "Pre-Covid",
    )
  ) |>
  ggplot(aes(x=date, y=count, color=interaction(type, period))) +
  geom_point(alpha=0.25) +
  scale_color_manual(
    name = "",
    values = c(
      "bus.Pre-Covid" = "#1991e3",
      "bus.Post-Covid" = "#0a3b7a",
      "rail.Pre-Covid" = "#f0811f",
      "rail.Post-Covid" = "#703c0d"
    ),
    labels = c(
      "bus.Pre-Covid" = "(Pre-Covid) Bus",
      "bus.Post-Covid" = "(Post-Covid) Bus",
      "rail.Pre-Covid" = "(Pre-Covid) Rail",
      "rail.Post-Covid" = "(Post-Covid) Rail"
    )
  ) +
  scale_x_date(name="") + 
  scale_y_continuous(name="Ridership", labels = label_comma()) +
  geom_smooth(method = "lm") +
  labs(title="Ridership Total")

total_crimes_and_arrests_plot <- 
  crimes_data |>
  filter(str_detect(type, "total")) |>
  ggplot(aes(x=date, y=count, fill=type, color=type)) +
  geom_bar(stat="identity", position=position_stack(reverse = TRUE)) +
  geom_point(data=arrest_data, aes(x=date, y=count, color=type), alpha=0.50) +
  geom_smooth(data=arrest_data, aes(x=date, y=count, color=type), se=FALSE) +
  scale_color_manual(
    name = "",
    values = c(
      "bus" = "#0a3b7a",
      "bus.total" = "#1991e3",
      "rail" = "#703c0d",
      "rail.total" = "#f0811f"
    ),
    labels = c(
      "bus" = "(Bus) Total Arrests",
      "bus.total" = "(Bus) Total Crimes",
      "rail" = "(Rail) Total Arrests",
      "rail.total" = "(Rail) Total Crimes"
    )
  ) +
  scale_fill_manual(
    name = "",
    values = c(
      "bus" = "#0a3b7a",
      "bus.total" = "#1991e3",
      "rail" = "#703c0d",
      "rail.total" = "#f0811f"
    ),
    labels = c(
      "bus" = "(Bus) Total Arrests",
      "bus.total" = "(Bus) Total Crimes",
      "rail" = "(Rail) Total Arrests",
      "rail.total" = "(Rail) Total Crimes"
    )
  ) +
  scale_x_date(name="") +
  scale_y_continuous(name="Total") +
  labs(
    title="Total Crimes and Arrests",
    subtitle="Arrest data begins at 2021"
  )

crimes_broken_out_plot <-
  crimes_data |>
  filter(!str_detect(type, "total")) |>
  ggplot(aes(x=date, y=count, fill=type, color=type)) +
  geom_bar(stat="identity", position="fill") +
  scale_y_continuous(labels=scales::percent) +
  labs(y="Proportion", x="Category") +
  scale_fill_manual(
    name = "",
    values = c(
      "bus.persons" = "#1991e3",
      "bus.property" = "#1068a3",
      "bus.society" = "#093a5c",
      "rail.persons" = "#f0811f",
      "rail.property" = "#9e5515",
      "rail.society" = "#542d0a"
    ),
    labels = c(
      "bus.persons" = "(Bus) Crimes against persons",
      "bus.property" = "(Bus) Crimes against property",
      "bus.society" = "(Bus) Crimes against society",
      "rail.persons" = "(Rail) Crimes against persons",
      "rail.property" = "(Rail) Crimes against property",
      "rail.society" = "(Rail) Crimes against society"
    )
  ) +
  scale_color_manual(
    name = "",
    values = c(
      "bus.persons" = "#1991e3",
      "bus.property" = "#1068a3",
      "bus.society" = "#093a5c",
      "rail.persons" = "#f0811f",
      "rail.property" = "#9e5515",
      "rail.society" = "#542d0a"
    ),
    labels = c(
      "bus.persons" = "(Bus) Crimes against persons",
      "bus.property" = "(Bus) Crimes against property",
      "bus.society" = "(Bus) Crimes against society",
      "rail.persons" = "(Rail) Crimes against persons",
      "rail.property" = "(Rail) Crimes against property",
      "rail.society" = "(Rail) Crimes against society"
    )
  ) +
  scale_x_date(name="") + 
  labs(title="Composition of Crimes by Type")

(total_crimes_and_arrests_plot / crimes_broken_out_plot / ridership_plot) + 
  plot_layout(heights = c(1, 3, 1)) +
  plot_annotation(
    title = 'Overview of LA Metro ridership and issues over time',
    subtitle = 'Colors distinguished by transportation type (bus vs rail)',
    caption = 'Source: LA Metros own aggregated, open-source data'
  )