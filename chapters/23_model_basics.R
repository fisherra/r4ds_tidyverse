##############################
##        Chapter 23        ##
##       Model Basics       ## 
##############################

# Working through Hadley Wickham's R for Data Science 
# Section 4, Chapter 23
# Fisher Ankney 

# load necissary libraries
library('tidyverse')
library('modelr')
options(na.action = na.warn)

# goal of a model is to provide a summary of a dataset

# two types of models - 
# prediction model (supervised),  data discovery (unsupervised)

# hypothesis generation vs hypothesis confirmation

# each observation can either be used for exploration or 
# confirmation, not both

# you can only use an observation for confirmation once
# a good approach is to split the data up into three peices
# 1. 60% training (exploration) allowed to do anything
# 2. 20% query set, used to compare models and visualizations
# 3. 20% test set, can be used once to test final model

# all models are wrong, but some are useful

sim1

ggplot(sim1, aes(x,y)) + 
  geom_point()

# use a model to capture the pattern in the data 

# linear model y = m * x + b    

models <- tibble(
  a1 = runif(250, -20, 40),
  a2 = runif(250, -5, 5)
) 

ggplot(sim1, aes(x, y)) + 
  geom_abline(aes(intercept = a1, slope = a2),
             data = models,
             alpha = 1/4) + 
  geom_point()

# turn the model into a function
model1 <- function(a, data) {
  a[1] + data$x * a[2]
}

model1(c(7,1.5), sim1)

# root-mean-squared deviation
# compute the distance between actual and predicted %>%
# square them %>%
# average them %>%
# take the square root

measure_distance <- function(mod, data) {
  diff <- data$y - model1(mod, data)
  sqrt(mean(diff ^ 2))
}

measure_distance(c(7, 1.5), sim1)

# now use purr to compute distance for all models 

sim1_dist <- function(a1,a2) {
  measure_distance(c(a1,a2), sim1)
}


models <- models %>%
  mutate(dist = purrr::map2_dbl(a1,a2, sim1_dist))
models

ggplot(sim1, aes(x, y)) +
  geom_point(size = 2, color = "grey30") + 
  geom_abline(
    aes(intercept = a1, slope = a2, color = -dist),
    data = filter(models, rank(dist) <= 10)
    
  )

# can also visualize model accuracy by scatterplot

ggplot(models, aes(a1, a2)) + 
    geom_point(data = filter(models, rank(dist) <= 10), size = 4, color = "red") + 
    geom_point(aes(color = -dist))

# instead of random models lets try grid searching

grid <- expand.grid(
  a1 = seq(-5, 20, length = 25),
  a2 = seq(1, 3, length = 25)
) %>%
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))

grid %>%
  ggplot(aes(a1, a2)) + 
  geom_point(data = filter(grid, rank(dist) <= 10),
             size = 4, 
             color = "red"
             ) +
  geom_point(aes(color = -dist))

# newton-raphson search using optim()

best <- optim(c(0,0), measure_distance, data = sim1)
best$par

ggplot(sim1, aes(x, y)) + 
  geom_point(size = 2, color = "grey30") + 
  geom_abline(intercept = best$par[1], slope = best$par[2])








