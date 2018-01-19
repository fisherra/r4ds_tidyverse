############################
##      How to dplyr      ##
##    guide & snippets    ##
############################

# Fisher Ankney
# January 2018

######################################################################
## Install Packages  #################################################
######################################################################

library('nycflights13') # data to work with 
library('tidyverse') # all tidyverse packages
library('dplyr') # dplyr specifically

######################################################################
## Commands  #########################################################
######################################################################

filter()       # select rows based on value 

arrange()      # sort rows based on values 

select()       # zoom in on specified columns

mutate()       # create new variables from existing ones 

summarise()    # collapse dataframe to single summary, ex: summarise(flights, delay = mean(dep_delay)) 

group_by()     # analyze by specified group, useful for summarise 

%>%            # connecting pipe
  
## Second Tier Commands ############################################

transmute()    # create new variables from existing ones, destroy existing ones

ungroup()      # literally the name

rename()       # literally the name 

desc()         # descending order (large to small, z to a)

count()        # simple function counting entries in a variable

n()            # number of entries

lag()          # offset, allows to refer to lagging (-1) value

lead()         # offset, allows to refer to leading (+1) value

cumsum()       # cumulative sum, also prod, mean, min, max 





######################################################################
## Examples  #########################################################
######################################################################


## filter ############################################################
filter(flights, month == 1 | day == 1)

# arrange ############################################################
arrange(flights, desc(dep_time))

# select #############################################################
select(flights, year:day)

# mutate #############################################################
mutate(flights, speed = distance / air_time * 60)

# summarise ############################################################
summarise(flights, delay = mean(dep_delay)) 

# group summarise ######################################################
group_by(flights, dest) %>%                        # group flights by destination
  summarise(count = n(),                           # summarise # of flights have invidual dest as variable "count"
            dist = mean(distance, na.rm = TRUE),   # distance = mean distance to each group_by() destination
            delay = mean(arr_delay, na.rm = TRUE)  # delay = mean arrival delay for each group_by() destination
            ) 

# complex inquiry ####################################################
denver_xmas_delay <- flights %>%                          # create new dataframe, denver_xmas_delay
  select(-tailnum) %>%                                    # leave out tailnum from new dataframe
  filter(month == 12 & day == 25 & dest == "DEN") %>%     # only keep christmas day flights, destination denver
  group_by(carrier) %>%                                   # group further analysis by carrier company
  summarise(num_flights = n(),                            # num_flights that fits analysis, grouped by carrier
            avg_delay = mean(dep_delay)) %>%              # average delay (by carrier) = mean(departure delay)
  arrange(desc(avg_delay))                                # arrange (by carrier) by biggest delay
denver_xmas_delay                                         # print results





  
