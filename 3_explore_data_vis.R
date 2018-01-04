############################
##        EXPLORE         ##
##   Data Visualisation   ## 
############################

# Working through Hadley Wickham's R for Data Science 
# Section 1, Chapter 3 
# Fisher Ankney 

## 3.1. Introduction
## Install and load tidyverse for the ggplot2 package
# install.packages("tidyverse")
# library(tidyverse)

## 3.2. First Steps

## View mpg dataframe
ggplot2::mpg

## Plot Engine Size (displ) vs fuel efficiency (hwy)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

# TEMPLATE
# ggplot(data = <DATA>) + 
#   <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))


## 3.3. Aestetic Mapping
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
# other aestetics include alpha, shape, size

## Altering aestetics by hand
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue", 
             shape = 8, size=5)


## 3.5. Facets ## 

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_wrap(~ class, nrow = 2)

# facet_wrap(~ <DISCRETE VARIABLE>, nrow = <NUMBER OF ROWS>) 
# create several plots defined by the class or variable defined

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid( drv ~ cyl)

# facets defined by drv (4wd, front, rear) and cylender type (4,5,6,8)
# It's a graph within a graph!


## 3.6. Geometric Objects (geoms)

# scatter plot
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

# smooth line plot
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))

# different geoms have different mappable aes, for instance linetype = drv
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

# you can use multiple geoms on a single plot
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))
# this however creates a repetitive command, and is better done as: 
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()
# however if you place mapping in a geom, it's treated as a local var
# and overwrites the global mapping for that later only: 
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()

## 3.7. Statistical Transformations

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))

# where does the 'count' aestetic come from? Bar charts, histograms,
# and frequency polygons bin your data and then plot bin counts, 
# the number of points that fall in each bin.

# You might want to override or change this default stat: 
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, y = ..prop.., group = 1))

# You can color or fill barcharts based on variables too!
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, colour = cut))
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))

# or perhaps more usefully: 
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))

# check out position = "identity" (it places them exactly / overlaps)
# this works much better in plots like scatterplot, where it
# is selected as default
ggplot(data = diamonds, mapping = aes(x = cut, color = clarity)) + 
  geom_bar(alpha = NA, position = "identity")

# position = "fill" is a bit different, allowing you to compare 
# more accurately the proportional makeup of the bars
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "fill")

# poisiton = "dodge" places overlaps next to each other
ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity), position = "dodge")
 

# position = "jitter" adds a small amount of random noise to the plot
# points to combat overplotting, allowing us to view where the 
# majority of the points are. 
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")
# short hand for this one is geom_jitter()
# makes plots less accurate @ small scale, but more revealing overall

## 3.9. Coordinate Systems

# sometimes it's useful to flip coordinates using coord_flop()
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()
# adding coord_flip()
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() +
  coord_flip()

# coord_quickmap() sets the aspect ratio correctly for maps
#install.packages('maps')
#library("maps")

usa <- map_data("usa")

ggplot(usa, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black")

ggplot(usa, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap()

# remember to check out maps library later
# ggmap, sp, raster, tmap package

# another coordinate system is polar, check this revealing plot out: 
bar <- ggplot(data = diamonds) + 
  geom_bar(
    mapping = aes(x = cut, fill = cut), 
    show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

bar + coord_polar()


## 3.10. Summary 

# template # 
ggplot(data = <DATA>) + 
  <GEOM_FUNCTION>(
    mapping = aes(<MAPPINGS>),
    stat = <STAT>, 
    position = <POSITION>
  ) +
  <COORDINATE_FUNCTION> +
  <FACET_FUNCTION>
  
  # seven parameters, not all are necissary but they are - 
  
  # what data set? <DATA>
  # what gemoetric shape? <GEOM FUNCTION>
  # what mapping variables / aestetics <MAPPINGS>
  # what statistical transformations? <STAT>
  # what position, such as overlapping, or jitter? <POSITION>
  # what coordinate system, such as polar? <COORDINATE_FUNCTION>
  # what facets? <FACET_FUNCTION>
  





