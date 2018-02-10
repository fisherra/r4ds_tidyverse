###########################
##        Chapter 14     ##
##         Strings       ## 
###########################

# Working through Hadley Wickham's R for Data Science 
# Section 2, Chapter 14
# Fisher Ankney 


library('tidyverse')
library('stringr')


double_quote <- "\"" # or '"'
single_quote <- '\'' # or "'"
new_line <- "\n"
tab <- "\t"

# all stringr functions start with str_ so you can easily browse them
str_length("Hello, world!")                # counts number of characters
str_c("x", "y", "z", sep = " and then ")   # combines strings with seperator

# replacing NA
x <- c("abc", NA)
str_c("|-", x, "-|")                     # > "|-abc-|" NA
str_c("|-", str_replace_na(x), "-|")     # > "|-abc-|" "|-NA-|"
 
# strings are vectorized
str_c("prefix-", c("a", "b", "c"), "-suffix")



# strings of length 0 are silently dropped
name <- "Fisher"
time_of_day <- "evening"
birthday <- FALSE
# often useful with the if
str_c(
  "Good ", time_of_day, " ", name,
  if (birthday) " and HAPPY BIRTHDAY",
  "."
)

# collapsing strings
str_c(c("x", "y", "z"), collapse = ", ")

# string subsetting 
x <- c("Apple", "Banana", "Pear")
str_sub(x, 1, 3)         # show characters 1,2,3 in x vector
str_sub(x, -3, -1)       # show characters 3rd from last, 2nd, last


# matching expressions
x <- c("apple", "banana", "pear")
str_view(x,"an")

# . is a wildcard
str_view(x, ".a.")
# \\. to actually search for .

# anchors
# ^ to match the start of the string.
# $ to match the end of the string.
str_view(x, "a$")

# other special tools
# \d: matches any digit.
# \s: matches any whitespace (e.g. space, tab, newline).
# [abc]: matches a, b, or c.
# [^abc]: matches anything except a, b, or c.

# & and | work here
str_view(c("grey", "gray"), "gr(e|a)y")

# detecting matches
x <- c("apple", "banana", "pear")
str_detect(x, "e")


## math with words

# How many common words start with t?
sum(str_detect(words, "^t"))
# What proportion of common words end with a vowel?
mean(str_detect(words, "[aeiou]$"))

# how many matches are in a string?
x <- c("apple", "banana", "pear")
str_count(x, "a")

# really just use this chapter as reference if you run into strings. 




