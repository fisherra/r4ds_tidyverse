###########################
##       Chapter 19      ##
##       Functions       ## 
###########################

# Working through Hadley Wickham's R for Data Science 
# Section 2, Chapter 19
# Fisher Ankney 

# load necissary libraries
library('tidyverse')


# functions allow you to automate common tasks in a powerful way
# - you can give a function a name and execute it 
# - as requirements change you only have to update code once
# - you can't copy and paste mistakes 

# always consider writing a function when you have three blocks of 
# the same code. 

# 3 steps in creating a new function: 

# 1. name the function 
# 2. list the arguements 
# 3. create the {body}

rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

# after creating the function its a good idea to test it with inputs

rescale01(c(-10,0,10))
rescale01(c(1,2,3,NA,5))

# remember its easier to turn a block of working code into a function
# than it is to create a function from scratch 

# functions make it easier to fix things

x <- c(1:10, Inf)
rescale01(x)

# oh no! rescale failed because it saw an infinite value, lets fix it

rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  (x - rng[1]) / (rng[2] - rng[1])
}

rescale01(x)

# DRY Principle - do not repeat yourself 

# Exercises: 

# create a function out of the following code snippets 
# mean(is.na(x))
mean_funct <- function(x) {
  mean(x, is.na=TRUE)
}


# x  / sum(x, na.rm = TRUE) 
sum_funct <- function(x) {
  x / sum(x, na.rm = TRUE)
}

# sd(x, na.rm=TRUE) / mean(x, na.rm = TRUE)
sd_over_mean <- function(x) {
  sd(x, na.rm=TRUE) / mean(x, na.rm=TRUE)
}

# Conditional Statements 

if (condition) {
  # code executed when condition = TRUE 
} else {
  # code executed when condition = FALSE
}

# Here’s a simple function that uses an if statement. 
# The goal of this function is to return a logical vector 
# describing whether or not each element of a vector is named.

has_name <- function(x) {
  nms <- names(x)
  if (is.null(nms)) {
    rep(FALSE, length(x))
  } else {
    !is.na(nms) & nms != ""
  }
}

# condition must be T/F, vector = warning message, NA = error

# you can use || or %% in condition statement for multiple
# logical statements, they'll short circuit 


# multiple conditions
 
if (this) {
  # do that 
} else if (that) {
  # do something else 
} else {
  # do a third thing
}

# also remember switches exist 

#> function(x, y, op) {
#>   switch(op,
#>     plus = x + y,
#>     minus = x - y,
#>     times = x * y,
#>     divide = x / y,
#>     stop("Unknown op!")
#>   )
#> }

# the fizzbuzz function

fizzbuzz <- function(x) {
  stopifnot( length(x)==1 && is.numeric(x) )
  if ( x %% 3 == 0 && x %% 5 == 0) {
    print("FizzBuzz")
  } else if (x %% 3 == 0) {
    print("Fizz") 
  } else if (x %% 5 == 0) {
    print("Buzz")
  } else 
  print(x)
}

# important to toss in error messages
wt_mean <- function(x, w) {
  if (length(x) != length(w)) {
    stop("`x` and `w` must be the same length", call. = FALSE)
  }
  sum(w * x) / sum(w)
}

#stopifnot() useful check for TRUE

# The DOT DOT DOT 

commas <- function(...) stringr::str_c(..., collapse = ", ")
commas(letters[1:10])

rule <- function(..., pad = "-") {
  title <- paste0(...)
  width <- getOption("width") - nchar(title) - 5
  cat(title, " ", stringr::str_dup(pad, width), "\n", sep = "")
}
rule("Important output")

# ... lets you forward any arguement you dont want tp specifically
# deal with. if you just want to capture the values of ... use 
list(...)

# a last note that r basically gives you unbridled power... 
# use it wisely 

`+` <- function(x, y) {
  if (runif(1) < 0.1) {
    sum(x, y)
  } else {
    sum(x, y) * 1.1
  }
}
table(replicate(1000, 1 + 2))
#> 
#>   3 3.3 
#> 100 900
rm(`+`)













