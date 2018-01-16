###########################
##       Chapter 21      ##
##       Iteration       ## 
###########################

# Working through Hadley Wickham's R for Data Science 
# Section 3, Chapter 21
# Fisher Ankney 

# load necissary libraries
library('tidyverse')

# reducing code via duplication has three main benefits: 
# 1. its easier to see the intent of the code
# 2. its easier to respond to changes in requirements
# 3. you'll have fewer bugs 

# imperative programming and functional programming 

# imperative programming - for loops, while loops 

# functional programing - common loops get their own functions

## for loopz 

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

output <- vector("double", ncol(df))  # 1. output
for (i in seq_along(df)) {            # 2. sequence
  output[[i]] <- median(df[[i]])      # 3. body
}
output

# output - you must always allocate sufficient space for the output
# before even starting. Don't grow it using c() 
# - vector() creates an empty vector of given length 

# sequence - for (i in seq_along(df)) { 
# - determines what to loop over, each run of the loop will assign
# i to a different value from seq_along(df). i = "it"

# body - output[[i]] <- median(df[[i]])
# - does the work. runs repeatedly, each time with a diff. value of i
# first output[[1]] <- median(df[[1]]), second output[[2]] <- med...

# loop practice! 
# compute the mean of every column in mtcars: 
output <- vector("double", ncol(mtcars))
for (i in seq_along(mtcars)) {
  output[[i]] <- mean(mtcars[[i]])
  }
output

#determine the type of column in nycflights13::flights
types <- vector("list", length = ncol(flights))
names(types) <- names(flights)
for (i in seq_along(flights)) {
  types[[i]] <- class(flights[[i]])
}
types

iris_unique <- vector("list", length = ncol(iris))
for (i in seq_along(iris)) {
  iris_unique[[i]] <- unique(iris[[i]])
}
iris_unique


# write a for loop that prints() the lyrics to alice the camel

humps <- c("five", "four", "three", "two", "one", "no")

for (i in humps) {
  cat(str_c("Alice the camel has ", rep(i, 3), " humps.",
            collapse = "\n"), "\n")
    if (i == "no") {
    cat("Now Alice is a horse.\n")
  } else {
    cat("So go, Alice, go.\n")
  }
  cat("\n")
}


# Convert the nursery rhyme “ten in the bed” to a function.
# Generalise it to any number of people in any sleeping structure.


x_in_the_y <- function(x,y) {
  for (x > 0) {
    cat(str("There were " x, " in the" y, "\n"))
    cat("and the little one said\n")
    if (x == 1) {
      cat("im lonely...")
      else {
        cat("Roll over, roll over\n")
        cat("So they all rolled over and one fell out\n")
      }
      cat("\n")
      }
    }
  }
}


numbers <- c("ten", "nine", "eight", "seven", "six", "five",
             "four", "three", "two", "one")
for (i in numbers) {
  cat(str_c("There were ", i, " in the bed\n"))
  cat("and the little one said\n")
  if (i == "one") {
    cat("I'm lonely...")
  } else {
    cat("Roll over, roll over\n")
    cat("So they all rolled over and one fell out.\n")
  }
  cat("\n")
}


# i need to come back to this later.. 
# perhaps i program in python instead of R. 












