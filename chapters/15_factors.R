###########################
##        Chapter 15     ##
##         Factors       ## 
###########################

# Working through Hadley Wickham's R for Data Science 
# Section 2, Chapter 15
# Fisher Ankney 


library('tidyverse')
library('forcats')

# 'for catagorical data'

# creating factors 

# my variable recording months
x1 <- c("Dec", "Apr", "Jan", "Mar")

# creating a months factor
month_levels <- c(
  "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
  "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
)
# factor variable x1, by levels = month_levels
y1 <- factor(x1, levels = month_levels)   
y1                                      
sort(y1)

# if you omit factor( levels = ) they'll sort alphabetical


## rest of the chapter will use 
gss_cat

## how many races are recorded?
gss_cat %>%
  count(race)

ggplot(gss_cat, aes(race)) +
  geom_bar()

## lets explore regular income 
gss_cat %>%
  count(rincome)

gss_cat %>%
  count(relig)

## arranging hours of tv watched by religion
relig_summary <- gss_cat %>%
  group_by(relig) %>%
  summarise(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

ggplot(relig_summary, aes(tvhours, relig)) + geom_point()
# well this is pretty hard to read, lets reorder the religions
# by how many hours of tv they watch then plot again
ggplot(relig_summary, aes(tvhours, fct_reorder(relig, tvhours))) +
  geom_point()
# factor reordering: fct_reorder(group, re-order-by-variable)

fct_reorder() # should only be used for factors that are arbitrarly ordered
fct_relevel() # takes factor, then pulls whatever levels you tell it to the front


