tuesdata <-  tidytuesdayR::tt_load("2024-03-12")
fiscal_sponsor_directory <- tuesdata$fiscal_sponsor_directory

fiscal_sponsor_directory = 
  fiscal_sponsor_directory |> 
  dplyr::mutate(
    dplyr::across(
      c(eligibility_criteria, project_types, services, fiscal_sponsorship_model),
      \(col) {
        stringr::str_split(col, "\\|")
      }
    )
  )

library("tidyverse")
lookup = read_csv("2024-03-12-fiscal-sponsors/recode-projects.csv")

project_types = 
unlist(fiscal_sponsor_directory$project_types) |> 
  table() |> 
  as.data.frame() |>
  as_tibble() |>
  rename(type = Var1) |>
  separate_wider_delim(cols = type, delim = ":", names = c("type", "subtype"), too_many = "merge", too_few = "align_start") |>
  select(-subtype) |>
  mutate(type = str_trim(str_to_lower(type))) |>
  left_join(lookup, by = c("type" = "old")) |>
  mutate(type = case_when(!is.na(new) ~ new, .default = type)) |>
  group_by(type) |>
  summarise(freq = sum(Freq)) |>
  filter(freq >= 9)

my_types = c("youth", "people or communities of color/minorities", "women", "veterans", "lgbtq", "mental health")

project_types |>
  dplyr::filter(type %in% my_types) |>
  ggplot(aes(x = type, y = freq)) + 
  geom_col()

