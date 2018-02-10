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

gplot(sim1, aes(x, y)) + 
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


# fitting linear models 
lm() 

sim1_mod <- lm(y ~ x, data = sim1) 
coef(sim1_mod)

sim1a <- tibble(
  x = rep(1:10, each = 3),
  y = x * 1.5 + 6 + rt(length(x), df = 2)
)


# mean-absolute distance
measure_distance <- function(mod, data) {
  diff <- data$y - make_prediction(mod, data)
  mean(abs(diff))
}

# understanding models and residuals 

data_grid() # create even grid of values covering region where
            # data lies

grid <- sim1 %>% 
  data_grid(x) 
grid

grid <- grid %>% 
  add_predictions(sim1_mod)
grid

 ggplot(sim1, aes(x)) + 
   geom_point(aes(y = y)) + 
   geom_line(aes(y = pred), data = grid, color = "red", size = 1)

# Residuals
 # tells you what the model has missed, the distance between
 # the predicted and observed value 

add_residuals() 

sim1 <- sim1 %>%
  add_residuals(sim1_mod)
sim1

# understand the spread of the residual 
ggplot(sim1, aes(resid)) +
  geom_freqpoly(binwidth = 0.5)

# average of residual will always be zero 
# often want to recreate plots using the residual

ggplot(sim1, aes(x, resid)) + 
  geom_ref_line(h = 0) + 
  geom_point()

# when the graph looks like random noise the model fits
# the data signal well 

ggplot(sim2) + 
  geom_point(aes(x,y))

mod2 <- lm(y ~ x, data = sim2)

grid <- sim2 %>%
  data_grid(x) %>%
  add_predictions(mod2)
grid

ggplot(sim2, aes(x)) + 
  geom_point(aes(y = y)) + 
  geom_point(data = grid, aes(y = pred), color = "red", size = 4)


## Interactiosn (continous and categorical)

ggplot(sim3, aes(x1, y)) + 
  geom_point(aes(color = x2))

mod1 <- lm(y ~ x1 + x2, data = sim3)
mod2 <- lm(y ~ x1 * x2, data = sim3)

grid <- sim3 %>%
  data_grid(x1, x2) %>%
  gather_predictions(mod1, mod2)
grid

ggplot(sim3, aes(x1, y, color = x2)) + 
  geom_point() + 
  geom_line(data = grid, aes(y = pred)) + 
  facet_wrap(~ model)


# facet models by x2

sim3 <- sim3 %>% 
  gather_residuals(mod1, mod2)

ggplot(sim3, aes(x1, resid, colour = x2)) + 
  geom_point() + 
  facet_grid(model ~ x2)



 
 
 
 
 




