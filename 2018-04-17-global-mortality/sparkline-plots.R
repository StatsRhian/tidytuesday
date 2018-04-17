# Create sparkline plots

# Load libraries
library(tidyverse)
library(readxl)
library(magrittr)
library(ggthemes)
library(scales)
'%!in%' <- function(x,y)!('%in%'(x,y))

# Clean column names
df <- read_xlsx("global_mortality.xlsx") %>%
  rename_all(funs(str_remove_all(., "[(%)]"))) %>%
  rename_all(funs(str_trim)) %>%
  rename(`HIV-AIDS` = `HIV/AIDS`) %>%
  filter(country %!in% c("World", "Wales", "England", "Scotland", "Northern Ireland"))

# Function to create a sparkplot given the cause of death as a string
create_sparkplot <- function(cause){
  
  #Identify top5 and bottom5 countries to plot
  causes_df = 
    df %>%
    filter(year %in% c(1990, 2016)) %>%
    select(!!enquo(cause), year, country) %>%
    spread(year, !!enquo(cause)) %>%
    mutate(difference = `2016` - `1990`)
  
  top_5 <- top_n(causes_df, 5, difference) %>% arrange(desc(difference))
  bottom_5 <- top_n(causes_df, -5, difference) %>% arrange(desc(difference))
  country_list = c(top_5$country, bottom_5$country)
  
  mini_df <- 
    df %>%
    select(!!enquo(cause), year, country) %>%
    rename(cause = !!cause) %>%
    filter(country %in% country_list)
  
  mini_df <- inner_join(mini_df, select(causes_df, difference, country))
  
  # Convert countries to factors, and order by difference
  # This enables the facetted plot to be ordered by country
  factor_order <- 
    mini_df %>%
    select(country, difference) %>%
    unique() %>% 
    arrange(desc(difference)) %>%
    pull(country)
  
  mini_df$country <- factor(mini_df$country, levels = factor_order)
  
  #Identify the max and min points
  mins <- group_by(mini_df, country) %>% slice(which.min(cause)) %>% mutate(cause = round(cause, 1))
  maxs <- group_by(mini_df, country) %>% slice(which.max(cause)) %>% mutate(cause = round(cause, 1))
  ends <- group_by(mini_df, country) %>% filter(year == max(year)) %>% mutate(cause = round(cause, 1))
  
  # Create the spark plot
  spark <- 
    mini_df %>%
    ggplot(aes(x = year, y = cause)) + 
    facet_grid(country~ ., scales = "free_y") + 
    geom_line(size=0.3) +
    geom_point(data = mins, col = 'blue') +
    geom_text(data = mins, aes(label = percent(cause/100)), vjust = -2) +
    geom_point(data = maxs, col = 'red') +
    geom_text(data = maxs, aes(label = percent(cause/100)), vjust = 2) +
    scale_x_continuous(breaks = c(1990, 2016), labels = c(1990, 2016)) +
    theme_minimal(base_size = 15) + 
    theme(axis.title = element_blank(), 
          axis.text.y = element_blank(),
          axis.ticks = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()) +
    theme(strip.text.y = element_text(angle = 0, vjust=0.2, hjust=0)) +
    ggtitle(sprintf("Change in percentage deaths by %s", cause))
  
  ggsave(sprintf("figures/sparkline-%s.png", cause), spark)
}

# Loop to create sparkplots for all causes of death available in the data
for (s in names(df)[-c(1:3)]){
  create_sparkplot(s)
}