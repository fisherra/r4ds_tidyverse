###############################
##        Chapter 7          ##
## Exploratory Data Analysis ## 
###############################

# Working through Hadley Wickham's R for Data Science 
# Section 1, Chapter 7
# Fisher Ankney 

# Use visualisation and transformation to explore your data in a systematic way - 

# 1. Generate questions about your data.
# 2. Search for answers by visualising, transforming, and modelling your data.
# 3. Use what you learn to refine your questions and/or generate new questions.

# 1. What type of variation occurs within my variables?
# 2. What type of covariation occurs between my variables?



# To examine the distribution of a categorical variable, use a bar chart:
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))
# The height of the bars displays how many observations occurred with 
# each x value. Compute these values manually with dplyr::count():
diamonds %>% 
  count(cut)

# To examine the distribution of a continuous variable, use a histogram:
ggplot(data = diamonds) + 
  geom_histogram(mapping = aes(x = carat), binwidth = 0.1)
# Compute this by hand:
diamonds %>% 
  count(cut_width(carat, 0.1))

# zooming into diamonds of a lesser size:
smaller <- diamonds %>% 
  filter(carat < 3)
ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1)
# when overlaying mutliple plots, use geom_freqpoly, not geom_hist
ggplot(data = smaller, mapping = aes(x = carat, colour = cut)) +
  geom_freqpoly(binwidth = 0.1)

# Yellowstone Old Faithful Eruoptions: 
ggplot(data = faithful, mapping = aes(x = eruptions)) + 
  geom_histogram(binwidth = 0.25)
# by hand:
faithful %>%
  count(eruptions)

## 7.3.1 Unusual Values

# outliers can be hard to see
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5)
# adjust the scope of the graph: 
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0, 50))
# now we can see these three unusual values, lets grab them using dplyr
unusual <- diamonds %>% 
  filter(y < 3 | y > 20) %>% 
  select(price, x, y, z) %>%
  arrange(y)
unusual
# can't have measurements of 0, and 31.8 ad 58.9 are also errors. REMOVE!

# should always have a good reason to remove values, and disclose it



# 7.3.4 Exercises
# 1. Explore the distribution of each of the x, y, and z variables in diamonds.
#    What do you learn? Think about a diamond and how you might decide 
#    which dimension is the length, width, and depth.
ggplot(diamonds) + 
  geom_freqpoly(mapping = aes(x = x), binwidth = 0.5, color = "red") +
  geom_freqpoly(mapping = aes(x = y), binwidth = 0.5, color = "blue") +
  geom_freqpoly(mapping = aes(x = z), binwidth = 0.5, color = "green") +
    coord_cartesian(xlim = c(-10, 65), ylim = c(0, 50))
# there are several other errors, x and y are width and depth, as 
# diamonds are symmetrical. 

# 2. Explore the distribution of price. Do you discover anything unusual 
#    or surprising? (Hint: Carefully think about the binwidth and make sure you try a wide range of values.)
ggplot(diamonds) + 
  geom_histogram(mapping = aes(x = price), binwidth = 100) + 
  geom_vline(xintercept = 1500)
# almost no diamonds cost $1500??

# 3. How many diamonds are 0.99 carat? How many are 1 carat? What do you 
#    think is the cause of the difference?
carat_count <- diamonds %>%
  group_by(carat) %>%
  summarise(count = n()) %>%
  filter(carat == 0.99 | carat == 1)
carat_count
# 23 diamondss are ranked as 0.99 carats, 1558 diamonds are ranked as 1 carat lol


## 7.5 Covariation (relationship between two related variables)
ggplot(data = diamonds, mapping = aes(x = price)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)
# hard to see how the price of diamonds vary with quality,
# because the overall count varies so much

ggplot(data = diamonds, mapping = aes(x = price, y = ..density..)) + 
  geom_freqpoly(mapping = aes(colour = cut), binwidth = 500)
# density, which is the count standardised so that the area under each frequency polygon is one.

# lets take a crack at it with geom_boxplot()
ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot()

# when you have ranked factors, sometimes it's useful to reorder them
ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()
# reordered by median highway mpg
ggplot(data = mpg) +
  geom_boxplot(mapping = aes(x = reorder(class, hwy, FUN = median), y = hwy))


# 7.5.1.1 Exercises
# 1. Use what you’ve learned to improve the visualisation of the departure times of cancelled vs. 
#    non-cancelled flights.

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay)) %>%
  select(sched_dep_time, dep_time)

cancelled <- flights %>% 
  filter(is.na(dep_delay), is.na(arr_delay)) %>%
  select(sched_dep_time, dep_time)

cancel_plot<- ggplot() + 
  geom_freqpoly(mapping = aes(x = not_cancelled$sched_dep_time, y = ..density..)) + 
  geom_freqpoly(mapping = aes(x = cancelled$sched_dep_time, y = ..density.., color = "red"))

cancel_plot

# 2. What variable in the diamonds dataset is most important for predicting the price of a diamond? 
#    How is that variable correlated with cut? Why does the combination of those two relationships 
#    lead to lower quality diamonds being more expensive?

price_predict <- diamonds %>%
  mutate(size_sum = x + y + x) %>%
  arrange(desc(price))
head(price_predict)
tail(price_predict)
# Size is the prize 

# PREDICTIVE MODELS
library(modelr)

mod <- lm(log(price) ~ log(carat), data = diamonds)

diamonds2 <- diamonds %>% 
  add_residuals(mod) %>% 
  mutate(resid = exp(resid))

ggplot(data = diamonds2) + 
  geom_point(mapping = aes(x = carat, y = resid))
# once you take out the effect of carat, cut rules
ggplot(data = diamonds2) + 
  geom_boxplot(mapping = aes(x = cut, y = resid))

# consise code
diamonds %>% 
  count(cut, clarity) %>% 
  ggplot(aes(clarity, cut, fill = n)) + 
  geom_tile()

# learn more with the ggplot2 book on amazon
