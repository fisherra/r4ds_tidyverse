############################
##       Chapter 27       ##
##       R Markdown       ## 
############################

# Working through Hadley Wickham's R for Data Science 
# Section 5, Chapter 27
# Fisher Ankney 

# load necissary libraries
library('tidyverse')

# rmarkdown is a plain text file with .Rmd extension

# needs YAML header
--- 
title: "project tite"
date: 2018-01-16
output: html_document
---
  
# needs 'chunks' of R code surrounded by ```
```{r setup, include = FALSE}
library(ggplot2)
library(dplyr)

smaller <- diamonds %>% 
  filter(carat <= 2.5)
```

# and text mixed with simple formatting like # heading and _italics_
yes this is a good rmarkdown document here!
  
# new r notebooks and rmd documents can easily be created in R studio 

  
# text formatting with markdown
# *italic*
# **bold**
# `code`
# sperscript^2^ and subscript~2~
 
# headings 
# 1st level
## second level
### third level

# Bullets 
# * item 1
# * item 2
#   * item 2a
#   * item 2b
# 1. number 1
# 1. item 2 (automatic incrementation in output)

# check out the rmd reference sheet

# code chunk options
eval = FALSE # prevents code from being evaluated, example code
incude = FALSE # runs code, doesnt show code or results in final doc
echo = FALSE # prevents code, but not results from final doc
warning = FALSE # prevents messages from appearing
results = 'hide' # hides the figure 
error = TRUE # causes the render to continue even if it has an error
cache = TRUE # wont re-run every time, be careful with this one though

# inline code
we only have data about `r nrow(diamonds)` diamonds. 
# turns into
we only have data about 53940 diamonds. 
  


