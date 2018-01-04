############################
##        EXPLORE         ##
##   Data Visualisation   ## 
############################

# Working through Hadley Wickham's R for Data Science 
# Section 1, Chapter 3 
# Fisher Ankney 



## Install and load tidyverse for the ggplot2 package
# install.packages("tidyverse")
# library(tidyverse)

## View mpg dataframe
ggplot2::mpg

## Plot Engine Size (displ) vs fuel efficiency (hwy)
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

# TEMPLATE
# ggplot(data = <DATA>) + 
#   <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

## Excercise 3.2.4 
# 1. Run ggplot(data = mpg). What do you see?
ggplot(data=mpg) # A blank grey plot canvas
# 2. How many rows are in mpg? How many columns?
str(mpg) # 234 observations (rows) of 11 variables (columns)
# 3. What does the drv variable describe? Read the help for ?mpg to find out.
?mpg # f = front-wheel drive, r = rear wheel drive, 4 = 4wd
# 4. Make a scatterplot of hwy vs cyl.
ggplot(data=mpg) + 
  geom_point(mapping = aes(x = cyl, y = hwy))
# 5. What happens if you make a scatterplot of class vs drv? 
#    Why is the plot not useful?
ggplot(data=mpg) + 
  geom_point(mapping = aes(x = class, y = drv))
# there are multiple drive types per class of car, no valuable relation


## Adding an aestetic class
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
# other aestetics include alpha, shape, size

## Altering aestetics by hand
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue", 
             shape = 8, size=5)

## Excercise 3.3.1
# 1. What’s gone wrong with this code? Why are the points not blue?
# 2. Which variables in mpg are categorical? Which variables are 
#    continuous? (Hint: type ?mpg to read the documentation for 
#    the dataset). How can you see this information when you run mpg?
# 3. Map a continuous variable to color, size, and shape.
#    How do these aesthetics behave differently for categorical vs.
#    continuous variables?
# 4. What happens if you map the same variable to multiple aesthetics?
# 5. What does the stroke aesthetic do? What shapes does it work with? (Hint: use ?geom_point)
# 6. What happens if you map an aesthetic to something other 
#    than a variable name, like aes(colour = displ < 5)?
