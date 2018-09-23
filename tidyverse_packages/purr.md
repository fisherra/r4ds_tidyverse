This is the final installments in my *Unpacking the Tidyverse* series.
Each of the eight posts focus on one of the core packages in Hadley
Wickham's tidyverse. Instructions given in each post are mainly derived
from Hadley's textbook, [R for Data Science](http://r4ds.had.co.nz/) and
CRAN package documentation. This installment of *Unpacking the
Tidyverse* focuses on iteration. We'll learn what for loops and while
loops are, and how they work. Then we'll learn to perform these same
operations with purrr functions. The previous installment focuses on the
categorical data manipulation package,
[forcats](%7B%7B%20site.baseurl%20%7D%7D/r4ds-forcats).

To use purrr, we must first download the tidyverse.

### Library

    library('tidyverse')

<br>

Itration allows you to conduct the same operation on multiple inputs
without tediously copying-and-pasting code. Here's a simple example of a
for-loop.

First we'll create a dataframe with 4 variables: a, b, c, and d. Each of
these variables will contian 10 randomly generated numbers from the
normal distribution using the function `rnorm`.

    df <- tibble(
    a = rnorm(10),
    b = rnorm(10), 
    c = rnorm(10),
    d = rnorm(10)
    )

    df

    ## # A tibble: 10 x 4
    ##          a      b       c       d
    ##      <dbl>  <dbl>   <dbl>   <dbl>
    ##  1 -1.09    1.61   0.700  -0.0200
    ##  2 -0.0706 -1.09  -1.38    0.591 
    ##  3  0.818  -1.11   1.24   -0.0520
    ##  4  0.838   0.643  0.327  -0.472 
    ##  5  0.858  -0.221  1.10    0.851 
    ##  6 -0.305  -1.08   0.822   0.518 
    ##  7  1.54    0.645 -0.956   0.204 
    ##  8  0.653   0.843 -0.509  -1.13  
    ##  9 -0.471   2.27  -0.0127  0.646 
    ## 10  0.0923  0.335  1.06    2.31

<br>

Now let's try to compute the mean of each variable

    mean(df)

    ## Warning in mean.default(df): argument is not numeric or logical: returning
    ## NA

    ## [1] NA

<br> well that doesn't work. I guess we'll have to specify each
variable.

    mean(df$a)

    ## [1] 0.2865871

    mean(df$b)

    ## [1] 0.2846406

    mean(df$c)

    ## [1] 0.2395993

    mean(df$d)

    ## [1] 0.3445163
