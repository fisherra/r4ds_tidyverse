#####################################
##       R For Data Science        ##
#####################################

# ggplot2 Data Visualization Summary 

# Synthesizing information from chapters
# 3, 7, and 28.


# Useful packages for Visualization with ggplot2

library('tidyverse')   
library('ggplot2')
library('maps')
library('RColorBrewer')

# Hepful links that expand on ggplot2 

http://www.cookbook-r.com/Graphs/
http://r-statistics.co/Top50-Ggplot2-Visualizations-MasterList-R-Code.html

# understanding the seven main components of a ggplot 

ggplot(*) +             # the data your working with
geom_*(                 # the geometric shape 
  mapping = aes(*)      # the variables plotted 
  stat = *              # the statistical transformations
  position = *          # the data's position adjustments
) + 
coord_*() +             # the coordinates system used
facet_*()               # the number and type of faceting 

# quick tips 

RColorBrwer::display.brewer.all()

######################################################################
## Scatterplots ######################################################
######################################################################

ggplot(midwest,               # dataframe evaluated
       aes(x=area,            # x-axis variable
           y=poptotal         # y-axis variable
       )
) +                   
  geom_point(aes(color = state,         # if mapping variable to color
                 size = popdensity),    # if mapping variable to size
             alpha = 1 
             # color = "black",
             # size = 5,
             # shape = 5
             # position ="jitter"         # if overlapping is a problem
  ) + 
  
  # line of best fit # 
  
  geom_smooth(method="lm",     # lm (linear model) or loess (curved)
              se=FALSE) +      # uncertainty bar = TRUE
  xlim(c(0, 0.1)) +            # x limit
  ylim(c(0, 500000)) +         # y limit 
  labs(                        # labels
    title="Scatterplot", 
    subtitle="Area Vs Population",    
    y="Population", 
    x="Area", 
    caption = "Source: midwest"
  )







######################################################################
## Line Graphs #######################################################
######################################################################

dev.off()
dat1 <- data.frame(
  sex = factor(c("Female","Female","Male","Male")),
  time = factor(c("Lunch","Dinner","Lunch","Dinner"), levels=c("Lunch","Dinner")),
  total_bill = c(13.53, 16.81, 16.24, 17.42)
)

# A line graph
ggplot(data=dat1,
       aes(x=time,               # x value
           y=total_bill,         # y value
           group=sex,            # group variable
           shape=sex,            # shape variable
           colour=sex            # color variable
       ) 
) +  
  geom_line( 
    aes(linetype=sex),   # linetype defined by variable
    size=1               # size of line
  ) +                          
  geom_point(size=3,             # size of points
             fill="white"        # fill color of point
  ) +              
  expand_limits(y=0              # set range to include zero
  ) +                          
  scale_colour_hue(name="Sex of payer",      # darken legend colors
                   l=30                      # use darker colors (ligness=30)
  )  +                  
  scale_shape_manual(name="Sex of payer",    # points change according to variable
                     values=c(22,21)         # select point types
  ) +      
  scale_linetype_discrete(name="Sex of payer" # unify legend
  ) +
  labs(                                      # labels
    title="Average bill for two people",
    subtitle="subtitle",
    caption="caption",
    x = "xlab",
    y= "ylab"
  )






######################################################################
## Distribution Plots ################################################
######################################################################


## bar plot histogram of distribution, 1 variable or catagory
dist_example <- data.frame(cond = factor(rep(c("A","B"), each=200)), 
                           rating = c(rnorm(200),rnorm(200, mean=.8)))

ggplot(dist_example,     # dataframe goes here
       aes(x=rating      # x-value goes here 
       )
) +
  geom_histogram(binwidth=.5,     # set width of catagorical bins
                 colour="black",  # outline color
                 fill="white"     # fill of the bars
  ) +
  geom_vline(aes(xintercept = mean(rating, na.rm=T) # ignore na for mean
  ),   
  color="red",         # color of the mean line
  linetype="dashed",   # type of line
  size=1               # line width / size
  )

## Overlapping density plots of several conditions
ggplot(dist_example,              # dataframe
       aes(x=rating,              # x-variable 
           fill=cond              # multiple catagories variable
       )
) +
  geom_density(
    alpha=.3
  )







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

example_2 <- tibble(               # example data preparation
  sex = factor(c("Female","Female","Male","Male")),
  time = factor(c("Lunch","Dinner","Lunch","Dinner"), levels=c("Lunch","Dinner")),
  total_bill = c(13.53, 16.81, 16.24, 17.42)
)

ggplot(data = example_2             # input dataframe here
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

# flip coordinates
coord_flip() 

# polar coordinates
coord_polar()

# naming your discrete tick marks
scale_x_discrete(breaks=c("ctrl", "trt1", "trt2"),   # defined tick marks
                 labels=c("Control", "Treat 1", "Treat 2"))   # new names

scale_y_discrete(breaks=c("b1", "b2", "b3"),
                 labels=c("break", "break 2", "break 3"))

# ensure the axis includes a particular value 
expand_limits(x = c(0,8), y = c(0,8))

#S pecify tick marks directly
scale_x_continuous(breaks=seq(0, 10, 0.25))  # ticks from 0-10, every 0.25 x
scale_y_continuous(breaks=seq(0, 10, 0.25))  # Ticks from 0-10, every 0.25 y

# reverse axis direction
scale_x_reverse()
scale_y_reverse()

# fixing x-y ratio
coord_fixed(ratio=1/1) # x = 1 / y = 1 ratio fixing

# Hiding axis labels 
element_blank()

# Changing axis label font and style
theme(axis.title.x = element_text(face="bold", color="red", size=20),
      axis.text.x = element_text(angle=90, vjust=0.5, size=16))

theme(axis.title.y = element_text(face="bold", color="red", size=20),
      axis.text.y = element_text(angle=90, vjust=0.5, size=16))

# hiding gridlines
theme(panel.grid.major=element_blank(),  # panel.grid.major.x for just x
      panel.grid.minor=element_blank())  # panel.grid.minor.y for just y

# Axis transformations (log, sqrt, etc)

# log2 scaling of the y axis (with visually-equal spacing)
library(scales)      # Need the scales package
scale_y_continuous(trans=log2_trans())

# log2 coordinate transformation (with visually-diminishing spacing)
library(scales)
coord_trans(y="log2")

# log10
scale_y_log10()

# log10 with exponents on tick labels
scale_y_log10(breaks = trans_breaks("log10", function(x) 10^x),
              labels = trans_format("log10", math_format(10^.x)))






######################################################################
## Legends ###########################################################
######################################################################

# remove the legend
theme(legend.position="none")

# change the order of items 
scale_fill_discrete(breaks=c("item_1", "item_2", "item_3"))
# scale fill_manual, scale_shape_discrete, scale_linetype_discrete

# reverse the order of legend items
scale_fill_discrete(guide=guide_legend(reverse=TRUE))

# hide legend title
theme(legend.title=element_blank())

# manual color, title, name, label
scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9"), 
                  name="Experimental\nCondition",
                  breaks=c("ctrl", "trt1", "trt2"),
                  labels=c("Control", "Treatment 1", "Treatment 2"))

# types of scales: 
# scale_xxx_yyy
# xxx: color, fill, linetype, shape, size, alpha
# yyy: hue, manual, gradient, grey, discrete, continuous

# no legend outline
geom_bar(color="black", show.legend=FALSE)    # include this in geom_*






######################################################################
## Lines #############################################################
######################################################################

# basic continous lines 
geom_vline(aes(xintercept=0), color="red", linetype="solid")
geom_hline(aes(yintercept=0))

# mean lines
library(dplyr)
lines <- data %>%
  group_by(condition) %>%
  summarise(
    x = mean(xval),
    ymin = min(yval),
    ymax = max(yval)
  ) %>%
  geom_linerange(aes(x=x, y=NULL, ymin=ymin, ymax=ymax), data = lines)






######################################################################
## Facets ############################################################
######################################################################

# facet grids
facet_grid (vertical_component ~ horizontal_component) # "." placeholder component

# facet wraps
facet_wrap( ~ component, nrow = 2, ncol = 2) # wrap variable, number of rows & columns

# facet appearances
theme(strip.text.x = element_text(size=8, angle = 45),
      strip.text.y = element_text(size=8, face = bold),
      strip.background = element_rect(color="red", fill="#CCCCFF"))

# facet label text
facet_grid(. ~ variable, labeller=labeller(sex = c("male", "female")))





