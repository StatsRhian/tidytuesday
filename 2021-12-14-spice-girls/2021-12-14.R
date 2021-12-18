library("dplyr")
library("ggplot2")
library("patchwork")
library("gridExtra")

studio_album_tracks = readr::read_csv("https://github.com/jacquietran/spice_girls_data/raw/main/data/studio_album_tracks.csv")

spice =
  studio_album_tracks %>%
  filter(album_name == "Spice") %>%
  select(acousticness, danceability, energy,
         liveness, speechiness, valence, track_number) %>%
  tidyr::pivot_longer(cols = -track_number)

spice_means =
  spice %>%
  group_by(name) %>%
  summarise(mean = mean(value))

hex = "#E1C2C1"

p1 = spice %>%
  ggplot(aes(x = track_number, y = value)) +
  geom_point(size = 3, colour = hex) +
  geom_hline(data = spice_means,
             aes(yintercept = mean),
             lty = "dashed", colour = hex) +
  facet_wrap(~name, scales = "free") +
  labs(x = "Track Number",
       y = "") +
  scale_x_continuous(breaks = 1:10, labels = 1:10) +
  theme_minimal() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        plot.title = element_text(size = 16),
        plot.subtitle = element_text(size = 11,  margin = margin(0, 0, 30, 0)),
        text = element_text(family = "Ubuntu"))


album_cover = png::readPNG("spice.png", native = TRUE)

tracks =
  studio_album_tracks %>%
  filter(album_name == "Spice") %>%
  select(`Track Name` = track_name)

p1 + tableGrob(tracks, theme = ttheme_minimal(base_size = 10, family = "Ubuntu")) +
  inset_element(album_cover, 0.2, 0.8, 0.9, 1, align_to = "full") +
  plot_annotation(
  title = "Audio features of the album: Spice",
  subtitle = "The best-selling album in music history by a girl group\nReleased: 4th November 1996",
  caption = "@statsRhian"
) &
  theme(text = element_text("Ubuntu"))
