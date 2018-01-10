###############################
##        Chapter 13         ##
##      Relational Data      ## 
###############################

# Working through Hadley Wickham's R for Data Science 
# Section 2, Chapter 13
# Fisher Ankney 


library('tidyverse')
library('nycflights13')


## four relational datasets
airlines
airports
planes
weather
## Combined to create 
flights


# exercise 1

# 1. Imagine you wanted to draw (approximately) the route each plane flies from 
#    its origin to its destination. What variables would you need? What tables 
#    would you need to combine?
# Airports > name, lat, long, alt, Planes > tailnum

# 2. I forgot to draw the relationship between weather and airports. What is the 
#    relationship and how should it appear in the diagram?
# weather only relates to the nyc airports, that should be signified on the diagram

# 3. weather only contains information for the origin (NYC) airports.
#    If it contained weather records for all airports in the USA, what additional
#    relation would it define with flights?
# it would be relational to arrival delay, airtime, dest, distance. 

# 4. We know that some days of the year are “special”, and fewer people than 
#    usual fly on them. How might you represent that data as a data frame? What 
#    would be the primary keys of that table? How would it connect to the
#    existing tables?
# use filter() to pick out the special days, n() < threshold passenger number

## 13.3 Keys

# the variables used to connect each pair of tables

# primary key 
planes$tailnum
# uniquely identifies an observation in it's own table

# foreign key
flights$tailnum
#uniquely identifies an observation in another table

# its good practice to very primary keys do indeed uniquely 
# identify each observations

planes %>% 
  count(tailnum) %>%
  filter(n > 1)
# no variables are double counted, good!

weather %>% 
  count(year, month, day, hour, origin) %>%
  filter(n > 1)
# no variables are double counted, good!

# sometimes a table has no primary keys: 
flights %>% 
  count(year, month, day, tailnum) %>% 
  filter(n > 1) 
# planes are used multiple times a day!


## 13.4 Mutating Joins

flights2 <- flights %>% 
  select(year:day, hour, origin, dest, tailnum, carrier)
View(flights2)

# adding the full names of the airlines to flights2
flights2 %>% 
  select(-origin, -dest) %>% 
  left_join(airlines, by="carrier")
# called a mutating join because you could have done it with
# dplyr mutate: 
flights2 %>%
  select(-origin, -dest) %>% 
  mutate(name = airlines$name[match(carrier, airlines$carrier)])

# inner join: 
# the simplest type of join, matching pairs of observations
# whenever the keys are equal
# UNMATCHED ROWS ARE NOT INCLUDED IN THE RESULT

# looks to me like inner and right join are stupid, 
# you should be using left_join or full_join()

# left_join() preserves original dataset, only suplimenting with new 
# "right-side" dataset

# full_join() is if youre combining two equally important datsets
# and you need to key track of missing observations from both

left_join(dataset, by=NULL) 
# natural join, uses all variables that appear in both tables




# Excercises 
#Compute the average delay by destination, then join on the airports data 
# frame so you can show the spatial distribution of delays.

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

# Add the location of the origin and destination (i.e. the lat and lon) to flights.






