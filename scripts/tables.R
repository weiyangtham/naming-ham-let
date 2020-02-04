library(tidyverse)
library(rvest)
html = read_html("https://en.wikipedia.org/wiki/2020_National_Hurling_League")


div1a = html_nodes(html, xpath = '//*[@id="mw-content-text"]/div/table[3]') %>%
  html_table() %>%
  purrr::pluck(1)
div1b = html_nodes(html, xpath = '//*[@id="mw-content-text"]/div/table[19]') %>%
  html_table() %>%
  purrr::pluck(1)
div2a = html_nodes(html, xpath = '//*[@id="mw-content-text"]/div/table[43]') %>%
  html_table() %>%
  purrr::pluck(1)

divs = bind_rows(div1a, div1b, div2a) %>% as_tibble() %>% janitor::clean_names()

team_assignments = read_csv(here::here("data/babyname_team_assignments.csv"))

babyname_points = divs %>%
  inner_join(team_assignments, by = "team") %>%
  select(-rownum)

babyname_points = babyname_points %>%
  select(team, baby_name, suggestor, everything())

# write_csv(babyname_points, "data/babyname_points.csv")
