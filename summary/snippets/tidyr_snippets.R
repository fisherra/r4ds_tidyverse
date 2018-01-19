############################
##      How to tidyr      ##
##    guide & snippets    ##
############################

# Fisher Ankney
# January 2018

######################################################################
## Install Packages  #################################################
######################################################################

library('tidyverse') # all tidyverse packages
library('tidyr') # tidyr specifically

######################################################################
## Tidy Data #########################################################
######################################################################


# dataframe     variable_1       variable_2      variable_3     
# observe_1     value            value           value   
# observe_2     value            value           value   
# observe_3     value            value           value   
# observe_4     value            value           value   
# observe_5     value            value           value   

######################################################################
## Functions #########################################################
######################################################################

gather()        # takes multiple clumns and collapsesinto key-value pairs

spread()        # spreads a key-value pair across multiple columns

separate()      # single column into multiple columns, defined seperator

unite()         # multiple columns into single column, defined seperator

left_join()     # combine a table 

fill()          # fills missing values using the previous entry


######################################################################
## Examples ##########################################################
######################################################################

## Gather ############################################################
table4a
table4a %>% 
  gather(`1999`, `2000`, key = "year", value = "cases")

# 'gather' columns titled `1999`, and `2000`, as these are values, 
# not variables. 

# 'key' a new column called 'year' to put 1999 and 2000 into. 

# values associated with the new column 'year' need a new home
# we now call them 'cases'. they still match with the intended years 




## Spread ############################################################

table2 
table2 %>%
spread(key = type, value = count)

# table 2's type column contains two different variables, cases and pop
# we need to spread these into two new column heads, so spread(key = type, 
# and the associated data is column count, or value = count). thats it!




## Seperate ############################################################

table3
table3 %>%
  seperate(rate, into = c("cases", "population", sep = "/"))

# pulls one column apart into multiple columns, default is by a 
# non alphanumeric chr, but put in the sep variable if you want 

## dealing with missing values 

tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"), extra="drop")
# drops that extra value completely 

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"), fill ="right")
# fills the row by putting an NA on the right 




## Unite ##############################################################

table5
table5 %>%
  unite(full_year, century, year, sep = "")

# declare a new column name, and unite two defined old variables by 
# the indicated seperator. 



## Join ############################################################

tidy4a <- table4a %>% 
  gather(`1999`, `2000`, key = "year", value = "cases")
tidy4b <- table4b %>% 
  gather(`1999`, `2000`, key = "year", value = "population")
left_join(tidy4a, tidy4b)

# after gathering the datasets into similiar, tidy dataframes, left_join()
# combines them into a signle frame.



## Fill ########################################################

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
