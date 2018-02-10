###########################
##       Chapter 18      ##
##         Pipes         ## 
###########################

# Working through Hadley Wickham's R for Data Science 
# Section 2, Chapter 18
# Fisher Ankney 


library('tidyverse')

# Learning about the pipe in detail! oh boy!

foo_foo <- little_bunny()

hop()
scoop()
bop()

# four ways to re-create little bunny foo foo 
 
# 1. Save each intermediate step as a new object

foo_foo_1 <- hop(foo_foo, through = forest)
foo_foo_2 <- scoop(foo_foo_1, up = field_mice)
foo_foo_3 <- bop(foo_foo_2, on = head)

# clutters code, careful increments

# 2. Overwrite the original

foo_foo <- hop(foo_foo, through = forest)
foo_foo <- scoop(foo_foo, up = field_mice)
foo_foo <- bop(foo_foo, on = head)

# painful to debug, obsucres changes


# 3. Function Composition (nesting)

bop(
  scoop(
    hop(foo_foo, through = forest),
    up = field_mice
  ), 
  on = head
)

# you have to read it inside out, right to left

# 4. Use a pipe

foo_foo %>%
  hop(through = forest) %>%
  scoop(up = field_mouse) %>%
  bop(on = head)

# obviously the best

# when shouldn't you use the pipe though?
# longer than 10 or so steps
# multiple inputs or outputs, block your code
# directed graphs with complex relationships

# other useful tools 
# the T-pipe! %T>% returns left-hand side, allowing for...

rnorm(100) %>%
  matrix(ncol = 2) %T>%
  plot() %>%
  str()

# I don't like the other operators, they're meh. 





