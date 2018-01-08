############################
##       Chapter 10       ##
##         Tibbles        ## 
############################

# Working through Hadley Wickham's R for Data Science 
# Section 2, Chapter 10
# Fisher Ankney 

# Coerse a dataframe to become a special tidyverse dataframe 'tibble'
as_tibble(iris)


# tibles are smart and match the vector lengths so you dont have to 
tibble(
  x = 1:5, 
  y = 1, 
  z = x ^ 2 + y
)

# possible for tibbles to have non-syntatic names that don't start with letters
tb <- tibble(
  `:)` = "smile", 
  ` ` = "space",
  `2000` = "number"
)
tb

# view 10 tibble rows
options(tibble.print_max = 10, tibble.print_min = 10)
# but view all the tibble columns
options(tibble.width = Inf)

# subsetting
df <- tibble(
  x = runif(5),
  y = rnorm(5)
)
# Extract by name
df$x
df[["x"]]

# Extract by position
df[[1]]

# however to use these extractions in a pipe, you need the special 
# placeholder '.'
df %>% .$x

# if your older function doesnt work with a tibble, turn it back into df
as.data.frame(df) 




