# flights delay map

library('tidyverse')
library('RColorBrewer')
library('nycflights13')

flights2 <- flights %>%
  group_by(dest) %>%
  summarise(avg_delay = mean(arr_delay, na.rm=TRUE))

airports2 <- airports %>%  
  left_join(flights2, c("faa" = "dest")) %>% 
  filter(avg_delay != is.na(TRUE))
airports2 

avg_delay_by_dest <- airports2 %>%
  ggplot(aes(lon, lat)) +
  borders("state") +
  geom_point(aes(
    color=avg_delay
  )
  ) +
  scale_color_distiller(palette="RdYlGn") + 
  coord_quickmap()
avg_delay_by_dest


ggsave('avg_delay_by_dest.png')

