############################
##     How to ggplot2     ##
##    guide & snippets    ##
############################

# Fisher Ankney
# January 2018

######################################################################
## Important visualisation packages ##################################
######################################################################

library('ggplot2') # grammer of graphics package
library('RColorBrewer') # beautiful color pallets 

######################################################################
## ggplot basic template #############################################
######################################################################

# ggplot(data=*) +        # the dataframe you're working with 
#  geom_*(               # the type of plot you'd like
#    mapping = aes(*),   # the mapable variables & aestetics
#    stat=*,             # the statistical transformations
#    position=*          # the default positioning (jitters, overlap)
#    ) +   
#  coord_* +             # the coordinate system
#  facet_*               # the type of faceting
  
######################################################################
## RColorBrewer pallets ##############################################
######################################################################

RColorBrwer::display.brewer.all()

######################################################################
## Scatterplots ######################################################
######################################################################

######################################################################
## Line Graphs #######################################################
######################################################################

######################################################################
## Distribution Plots ################################################
######################################################################

######################################################################
## Bar Charts ########################################################
######################################################################

## 1 variable bar chart ##############################################
## (x = continuous number, or discrete catagory, y = count, fill = color)

ggplot(data = mpg                             # input dataframe here
) + 
  geom_bar(
    mapping = aes(x = hwy              # discrete or continuous is ok
                # y = NA               # NA for value-filled count bar chart
                # fill = class         # catagories within the bars
    ),
    width = 0.5,                       # width of the individual bars
    color = "black",                   # color of the outlines
    fill = "tomato2",                  # color of the bar
    alpha = 1                          # transparency within the bars
  # position =                         # useful options: "fill" "dodge" "position_dodge()             
  ) + 
  labs(title="Catagory Bar Chart",                          # labels
       subtitle="Useful for comparing overall counts of catagories", 
       caption="Source: ggplot2, r-cookbook, me", 
       x = "manufacturer",
       y = "count"
  ) 



## 2 variable bar chart #############################################
## (x = catagory, y = count, fill = catagory)

ggplot(data = mpg                             # input dataframe here
       ) + 
  geom_bar(
           mapping = aes(x = manufacturer,    # catagories along the x axis
                       # y = NA               # NA for value-filled count bar chart
                         fill = class         # catagories within the bars
                         ),
           width = 0.5,                       # width of the individual bars
           color = "black",                   # color of the outlines
           alpha = 1                          # transparency within the bars
         # position =                         # useful options: "fill" "dodge" "position_dodge()             
           ) + 
  theme(axis.text.x = element_text(angle=65, vjust=0.6)) +  # tilts & position x-labels
  labs(title="Catagory Bar Chart",                          # labels
       subtitle="Useful for comparing overall counts of catagories", 
       caption="Source: ggplot2, r-cookbook, me", 
       x = "manufacturer",
       y = "count"
      ) 



## 3 variable bar chart #################################################
## (x is a catagory, y is a numerical variable, fill is a catagory)

example_1 <- tibble(               # example data preparation
  sex = factor(c("Female","Female","Male","Male")),
  time = factor(c("Lunch","Dinner","Lunch","Dinner"), levels=c("Lunch","Dinner")),
  total_bill = c(13.53, 16.81, 16.24, 17.42)
)

ggplot(data = example_1             # input dataframe here
       ) + 
  geom_bar(
           mapping = aes(x = time,        # x variable, usually catagorical
                         y = total_bill,  # y variable, usually quantitative, not count
                         fill = sex       # fill variable, catagorical
                         ),
           stat = "identity",             # set to identity to prevent y-variable="count"
           position = position_dodge(),   # useful options: fill, dodge
           width = 0.5,                   # bar width, default 0.9
           color = "black",               # bar outline color
        #  fill =                         # bar fill color, if no variable is mapped
           alpha = 1                      # bar transparency 
           ) + 
  labs(title="Bar Chart",                 # labels
       subtitle="I'm a subtitle", 
       caption="Optional Caption Here",
       x="time",   
       y="total bill"    
       )
  

######################################################################
## Axes ##############################################################
######################################################################

######################################################################
## Legends ###########################################################
######################################################################

######################################################################
## Lines #############################################################
######################################################################

######################################################################
## Facets ############################################################
######################################################################
