###########################
##       Chapter 12      ##
##       Tidy Data       ## 
###########################

# Working through Hadley Wickham's R for Data Science 
# Section 2, Chapter 12
# Fisher Ankney 

# THREE GOLDEN RULES OF A TIDY DATASET
# 1. Each variable must have its own column.
# 2. Each observation must have its own row.
# 3. Each value must have its own cell. 

# you'll satisfy these rules by remembering to...
# Put each dataset in a tibble.
# Put each variable in a column

# the two most important functions in tidyr are - 
# gather() and spread()

## Gather - - - 
table4a %>% 
  gather(`1999`, `2000`, key = "year", value = "cases")

# the first entries are the set of columns that are screwed up, 
# in this case 1999 and 2000 represent values not variables 
# next we enter the key, which is the name of the variable whose 
# values form column names i.e. the key is year (1999, 2000)
# finally we clean up the variable whose values are spread across
# the dataset, so in the problem columns (1999, 2000), there are a 
# number of values that now need a new home. these values are named
# "cases" by the code above. 

#  now trying it for the second dataset
table4b %>% 
  gather(`1999`, `2000`, key = "year", value = "population")

# join the two tables togather!
tidy4a <- table4a %>% 
  gather(`1999`, `2000`, key = "year", value = "cases")
tidy4b <- table4b %>% 
  gather(`1999`, `2000`, key = "year", value = "population")
left_join(tidy4a, tidy4b)


# spread() is the opposite of gather, usable when the observations
# are on multiple roles, see table2
table2

spread(table2, key = type, value = count)
# we only need two parameters, key and value.
# The column that contains variable names, the key column. Here, it’s type.
# The column that contains values forms multiple variables, the value column. Here it’s count.

stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)
stocks %>% 
  spread(year, return) %>% 
  gather("year", "return", `2015`:`2016`)
# They cannot be symmetrical because you're defining the column
# headers to be the years (2015, 2016) and the values to be the 
# return numbers. then youre trying to gather up column headers
# year and return, when they no longer exist. 

# convert runs type.convert() on the key column, 
# useful when the names are numbers or logicals not characters

table4a %>% 
  gather(1999, 2000, key = "year", value = "cases")
# didnt use special `1999`, `2000`

# tidy this tibble!
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12 
) %>%  # here we go..!
  gather("male", "female", key = "sex", value = pregnants) %>% 
  spread(key = "pregnant", value = "pregnants") %>%
  rename("not_pregnant" = "no", "pregnant" = "yes") %>%
  select(sex, pregnant, not_pregnant)
preg

# 12.4 seperating and uniting


# separate() pulls apart one column into multiple columns, 
# by splitting wherever a separator character appears
table3
table3 %>% 
  separate(rate, into = c("cases", "population"))
# by default the spererator is a non-alphanumeric chr. but you can set it: 
table3 %>% 
  separate(rate, into = c("cases", "population"), sep = "/")

# unite() is the inverse of separate(): it combines multiple columns
# into a single column
table5 %>% 
  unite(new, century, year, sep = "")

## exercises
# 1. extra warns when there are too many peices, warn, drop, merge
# 2. fill warns when there are not enough peices, warn, right, left

tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"), extra="drop")
# drops that extra g

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"), fill ="right")
# fills in the missing column with an NA placeholder (right side, column 3)

tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"), extra="drop")

# explicit and implicit missing data
stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)
# return for 4th Q is NA (explicit), entire 2016 Q1 missing (implicit)
stocks %>% 
  spread(year, return)

stocks %>% 
  complete(year, qtr)
# complete() takes a set of columns, and finds all unique combinations.
# It then ensures the original dataset contains all those values, 
# filling in explicit NAs where necessary.

# sometimes you know what should be in those missing values because of 
# the previous entries
treatment <- tribble(
  ~ person,           ~ treatment, ~response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  1,           4
)
treatment %>% 
  fill(person)
# fill() will carry forward the last value for that column



## Tidying WHO data casestudy - - - 
tidy_who <- who %>%   # gather together the columns that are not variables
  gather(new_sp_m014:newrel_f65, key = "key", value = "cases", na.rm=TRUE) %>% # new_sp_m014 to newrel_f65 are some type of value, not variable
  mutate(key = stringr::str_replace(key,"newrel", "new_rel")) %>% # newrel and new_rel are not consistent throughout the dataset
  separate(key, c("new", "type", "sexage"), sep = "_") # seperate the patient code into new, type of sickness, and sex+age using the _ 

tidy_who %>% count(new) # looks like we only have new cases listed in this dataset, therefor this isn't really a variable
tidy_who <- select(tidy_who, -new, -iso2, -iso3) # remove redundant variables

tidy_who %>%
separate(sexage, c("sex", "age"), sep = 1) # seperate sexage into sex, age by carving off the first character (sex) 

# data is tidy!


## Exercises 

# For each country, year, and sex compute the total number of cases of TB. Make an informative visualisation of the data.
tidy_who %>% 
  ggplot() + 
    geom_point(mapping=aes(x=year, y = cases))
    




