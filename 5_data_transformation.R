############################
##        Chapter 5       ##
##   Data Transformation  ## 
############################

# Working through Hadley Wickham's R for Data Science 
# Section 1, Chapter 5
# Fisher Ankney 


## 5.1. Introduction
# install.packages('nycflights13')
# library('nycflights13')
# library('tidyverse')

# Common Variable Types - 
# int: integer, dbl: double, chr: character, dttm: date-time
# lgl: logical, fctr: factor, date: date

## Learning the 5 key dplyr basics 

# filter() pick observations by their values
# arrange() reorder rows
# select() pick variables by their values
# mutate() create new variables from existing ones
# summarise() collapse many values to a summary

# use all of these dplyr commands with the group_by() and you can 
# organize anything!

## 5.2. Filter

#filter(<DATAFRAME>, condition 1, condition 2)
jan_1 <- filter(flights, day == 1, month == 1)
(dec_25 <- filter(flights, day == 25, month == 12))

# also just for fun, check this out: 
(1/49*49)==1
near(1/ 49 * 49, 1)

# Logical Operators & (and) | (or) and ! (not)

# find all of the flights in november OR december
filter(flights, month == 11 | month == 12)
# note you cannot have: 
filter(flights, month == 11 | 12)
# this is because it finds months equal to 11 or 12, which is true, 
# which is interpreted as '1', so It'll find all of the flights in january. 

# a shorthand for the above problem:
nov_dec <- filter(flights, month %in% c(11, 12))


# De Morgan’s law: !(x & y) is the same as !x | !y, 
# and !(x | y) is the same as !x & !y

# an example of De Morgan's law - flights that weren't delayed 2+ hours:
filter(flights, !(arr_delay > 120 | dep_delay > 120))
filter(flights, arr_delay <= 120, dep_delay <= 120)

# to determine if there are missing variables use is.na()
x <- NA
is.na(x)


# Practice time!
# 1. Find all flights that...
#    Had an arrival delay of two or more hours
filter(flights, arr_delay >= 120)
#    Flew to Houston (IAH or HOU)
filter(flights, dest == "IAH" | dest == "HOU")
#    Were operated by United, American, or Delta
filter(flights, carrier == "UA" | carrier == "AA" | carrier == "DL")
#    Departed in summer (July, August, and September)
filter(flights, month == 7 | month == 8 | month == 9)
#    Arrived more than two hours late, but didn’t leave late
filter(flights, arr_delay > 120 & dep_delay <= 0)
#    Were delayed by at least an hour, but made up over 30 minutes in flight
filter(flights, dep_delay >= 60 & arr_delay <= 30)
#    Departed between midnight and 6am (inclusive)
filter(flights, dep_time >= 0 & dep_time <= 600)
# 2. Another useful dplyr filtering helper is between(). What does it do? Can you use it to simplify 
#    he code needed to answer the previous challenges?
filter(flights, between(dep_time, 0, 600))
# 3. How many flights have a missing dep_time? 
#    What other variables are missing? What might these rows represent?
filter(flights, is.na(dep_time))
#    These appear to be cancelled flights. 
# 4. Why is NA ^ 0 not missing? Why is NA | TRUE not missing? Why is FALSE & NA not missing? 
#    Can you figure out the general rule? (NA * 0 is a tricky counterexample!)



## 5.3. Arrange

# arrange organizes the rows (default ascending) by the parameters you give it
arrange(flights, desc(arr_delay))
# note that missing values are always sorted at the end

# Practice!
# 1.  How could you use arrange() to sort all missing values to the start? (Hint: use is.na()).
arrange(flights, desc(is.na(dep_time)))

# 2.  Sort flights to find the most delayed flights. Find the flights that left earliest.
arrange(flights, desc(dep_delay))
arrange(flights, dep_delay)
# 3.  Sort flights to find the fastest flights.
arrange(flights, air_time)
# 4.  Which flights travelled the longest? Which travelled the shortest?
arrange(flights, distance)
arrange(flights, desc(distance))



## 5.4. Select
# often datasets have many variables, select allows you to quickly create a subset of these variables

# select(flights dataset, variables: year, month, day)
select(flights, year, month, day)
# select(flights dataset, variables: year through day inclusively)
select(flights, year:day)
#select(flights dataset, leave out varaibles year through day inclusively)
select(flights, -(year:day))

# Select helper functions - 
#   starts_with("abc"): matches names that begin with “abc”.
#   ends_with("xyz"): matches names that end with “xyz”.
#   contains("ijk"): matches names that contain “ijk”.
#   matches("(.)\\1"): selects variables that match a regular expression. 
#   num_range("x", 1:3) matches x1, x2 and x3.

# rename function 
rename(flights, tail_num = tailnum)
# everything function useful for moving certain variables to the first columns and keeping the rest
select(flights, time_hour, air_time, everything())



## 5.5. Mutate

# mutate() creates new columns that are the function of existing columns
flights_sml <- select(flights, year:day, ends_with("delay"), distance, air_time)
# create flights_sml dataframe using specified parameters
mutate(flights_sml, gain = arr_delay - dep_delay, speed = distance / air_time * 60)
# create 'gain' variable and 'speed' variable with mutate
View(flights_sml) # dont forget the capital V 
# you can refer to the columns you just created in the same command:
mutate(flights_sml,
       gain = arr_delay - dep_delay,
       hours = air_time / 60,
       gain_per_hour = gain / hours
)
# if you want to destroy the old data and only keep the newly created data use transmute()
transmute(flights,
          gain = arr_delay - dep_delay,
          hours = air_time / 60,
          gain_per_hour = gain / hours
)

# Modular arithmatic %/% (integer division) %% remainder can be useful: 
transmute(flights, 
          dep_time,
          hour = dep_time %/% 100,
          minute = dep_time %% 100
)

# Other useful functions
(x <- 1:10)
# offset x by -1
lag(x)
# offset x by +1
lead(x)

# running sum
cumsum(x)
# running product
cumprod(x)
#running minimum
cummin(x)
# running maximum
cummax(x)
# running mean
cummean(x)


## 5.6. Grouped Summaries

# The last key verb is summarise(). It collapses a data frame to a single row:
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

# summarise() is often best used with group_by():
by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))
# now you can see the average delay per day, instead of per year

# Grouped summaries one of the most powerful features of dplyr, but first we must learn the pipe:

# BEHOLD! THE DPLYR PIPE! THEN!
#           %>%

delays <- flights %>%  # put flights datatable into delays subset *then*
  group_by(dest) %>%   # changes the unit of analysis from whole dataset to individual dest, *then*
  summarise(         
    count = n(),       # create "count" variable, adding up # of flights to each group(dest)
    dist = mean(distance, na.rm = TRUE),     # mean distance to each destination
    delay = mean(arr_delay, na.rm = TRUE)    # mean delay to each destination
  ) %>%                # *THEN*
  filter(count > 20, dest != "HNL")          # only destinations that have been flown to 20+ times, and not honalulu

# Note na.rm = TRUE very important to remove those cancelled flights
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

# doing counts on any data aggregate is a good idea: 
#(n())

delays <- not_cancelled %>%    # put all not_cancelled data into delays variable
  group_by(tailnum) %>%        # analyze by tailnumber (or unique airplane) 
  summarise(   
    delay = mean(arr_delay)    # average arrival delay (by unique airplane)
  )

ggplot(data = delays, mapping = aes(x = delay)) +    # plot frequency of delays
  geom_freqpoly(binwidth = 10)                 
# Dang! some planes have average delays of -50 minutes, some of more than 300 minutes

delays <- not_cancelled %>%        # not_cancelled dataset re-writes delays
  group_by(tailnum) %>%            # analyze by individual airplane again
  summarise(
    delay = mean(arr_delay, na.rm = TRUE),      # delay = average delay per airplane
    number_of_flights = n()                        # number_of_flights that plane has done
    )
ggplot(data = delays, mapping = aes(x = number_of_flights, y = delay)) + 
  geom_point(alpha = 1/10)
# so now we can see that the 300 minute delay is the average of 1 flight

# lets filter out planes that have flown less that 25 times in the year 
delays %>% 
  filter(number_of_flights > 25) %>% 
  ggplot(mapping = aes(x = number_of_flights, y = delay)) + 
  geom_point(alpha = 1/10)

# subsetting can be very useful, average positive delay 
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0]) # the average positive delay
  )

# Measurements of spread include:
# sd(x) mean squared deviation aka standard deviation
# IQR(x) Inter Quartile Range
# mad(x) Median absolute deviation

# Destinations with the most variability
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))

# Which destinations have the most carriers?
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(carriers = n_distinct(carrier)) %>% 
  arrange(desc(carriers))

# Counts are super useful!
not_cancelled %>% 
  count(dest)
# weight variable (wt) will count (sum) the specified parameter
not_cancelled %>% 
  count(tailnum, wt = distance)
# thus providing how far each plane on record flew

# How many flights left before 5am? (these usually indicate delayed
# flights from the previous day)
not_cancelled %>% 
  group_by(year, month, day) %>%    # analyze by year, month, day 
  summarise(n_early = sum(dep_time < 500)) # number early 

# what proportion of flights are delayed by more than an hour?
not_cancelled %>% 
  group_by(year, month, day) %>%   # group by day
  summarise(hour_perc = mean(arr_delay > 60))  # summarize 



## 5.7. Group Summary
















