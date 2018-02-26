This is the fourth installment of a six-part series summarizing concepts
from Hadley Wickham's textbook, [R for Data
Science](http://r4ds.had.co.nz/). In the previous [blog post](link) I
abridged the book’s chapter that covers data wrangling with dplyr.

In this installment, I'll be summarizing the tidyr package and tidy data
practices, as taught in R for Data Science [Chapter
12](http://r4ds.had.co.nz/tidy-data.html). There are four components to
the chapter and this summary blog post, the first being "what
constitutes tidy data"?. The second and third component deal with
correcting the two typical formatting issues of untidy data, and the
fourth component dives into how to properly represent missing values in
a dataset.

For more resources on tidyr, reference these links:

-   [CRAN tidyr
    Documentation](https://cran.r-project.org/web/packages/tidyr/tidyr.pdf)
-   [STHDA tidyr
    Tutorial](http://www.sthda.com/english/wiki/tidyr-crucial-step-reshaping-data-with-r-for-easier-analyses)
-   [Journal Of Statistical Software: Tidy Data by Hadley
    Wickham](http://vita.had.co.nz/papers/tidy-data.pdf)

<br  />

### Libraries

    library('tidyverse')      # includes tidyr
    library('tidyr')          # tidyr specifically

<br  />

### Primary Functions

    spread()        # spreads a key-value pair across multiple columns
    gather()        # takes multiple columns and collapses into key-value pairs
    separate()      # single column into multiple columns, defined separator
    unite()         # multiple columns into single column, defined separator

<br  />

### Tidy Data

There are three rules to tidy data -

1.  Each column is a variable <br  />
2.  Each row is an observation <br  />
3.  Each value has it's own cell <br  />

<insert tidy data image here>

Tidy data is an easy and consistent way of storing data that makes
further analytical steps more simple. Datasets that follow the three
tidy data rules allow for R's vectorized nature to work its magic. Other
packages in the tidyverse, such as dplyr and ggplot2, expect datasets to
be tidy when applying functions such as *mutate( )* and *ggplot( )*.
Datasets may grow in size during the tidying process, but breaking down
rows and columns into single observations and variables drastically
simplifies the dataset for future analytics.

Here's an example of a tidy dataset -

    table1

    ## # A tibble: 6 x 4
    ##   country      year  cases population
    ##   <chr>       <int>  <int>      <int>
    ## 1 Afghanistan  1999    745   19987071
    ## 2 Afghanistan  2000   2666   20595360
    ## 3 Brazil       1999  37737  172006362
    ## 4 Brazil       2000  80488  174504898
    ## 5 China        1999 212258 1272915272
    ## 6 China        2000 213766 1280428583

<br  />

Here's an example of an untidy dataset -

    table2

    ## # A tibble: 12 x 4
    ##    country      year type            count
    ##    <chr>       <int> <chr>           <int>
    ##  1 Afghanistan  1999 cases             745
    ##  2 Afghanistan  1999 population   19987071
    ##  3 Afghanistan  2000 cases            2666
    ##  4 Afghanistan  2000 population   20595360
    ##  5 Brazil       1999 cases           37737
    ##  6 Brazil       1999 population  172006362
    ##  7 Brazil       2000 cases           80488
    ##  8 Brazil       2000 population  174504898
    ##  9 China        1999 cases          212258
    ## 10 China        1999 population 1272915272
    ## 11 China        2000 cases          213766
    ## 12 China        2000 population 1280428583

<br  />

Notice the differences between the two tables above; in table 1 the
variables (columns) are country, year, cases, and population. In table 2
the variables are country, year, type and count. In table 2 the data is
untidy; the observation, a specified country in a specified year, is
spread among multiple rows. This is because population and cases are
variables that should be column names, not values!

<br  />

### Spread and Gather

Spread and gather are two functions in the tidyr package that address
these issues. While these functions are easy to use and understand, it's
often quiet hard to determine what constitutes a discrete observation,
and what constitutes a discrete variable. It takes time and practice to
properly make these choices, but in general, I aim to break down
observations and variables into the smallest and most easily retrievable
chunks possible.

<br  />

#### One Observation Across Multiple Rows

    table2

    ## # A tibble: 12 x 4
    ##    country      year type            count
    ##    <chr>       <int> <chr>           <int>
    ##  1 Afghanistan  1999 cases             745
    ##  2 Afghanistan  1999 population   19987071
    ##  3 Afghanistan  2000 cases            2666
    ##  4 Afghanistan  2000 population   20595360
    ##  5 Brazil       1999 cases           37737
    ##  6 Brazil       1999 population  172006362
    ##  7 Brazil       2000 cases           80488
    ##  8 Brazil       2000 population  174504898
    ##  9 China        1999 cases          212258
    ## 10 China        1999 population 1272915272
    ## 11 China        2000 cases          213766
    ## 12 China        2000 population 1280428583

<br  />

`spread()` is one of the most commonly used tidyr functions; it is used
when one coherent observation is *spread* across multiple rows of the
dataset. The function takes two arguments, a key, and a value. the key
argument names the column that currently contains variable names. In the
case of table 2, the key is "type" because it contains the variables
cases and population. The second argument of `spread()` is value; value
defines the column with *values* associated with the key. In table 2 the
values are found in the column "count".

    table2 %>%
    spread(key = type, value = count)

    ## # A tibble: 6 x 4
    ##   country      year  cases population
    ## * <chr>       <int>  <int>      <int>
    ## 1 Afghanistan  1999    745   19987071
    ## 2 Afghanistan  2000   2666   20595360
    ## 3 Brazil       1999  37737  172006362
    ## 4 Brazil       2000  80488  174504898
    ## 5 China        1999 212258 1272915272
    ## 6 China        2000 213766 1280428583

<br  />

#### One Variable Across Multiple Columns

    table4a

    ## # A tibble: 3 x 3
    ##   country     `1999` `2000`
    ## * <chr>        <int>  <int>
    ## 1 Afghanistan    745   2666
    ## 2 Brazil       37737  80488
    ## 3 China       212258 213766

<br  />

Table 4a presents a new challenge for tidying data. Perhaps even more
common than the previous function, `gather()` deals with one variable
across multiple columns. In table 4a there are three observations of
three variables: country, 1999, and 2000. But 1999 and 2000 are not
variables, they are values of the missing variable "year". To "gather"
these values under one new variable, implement the `gather()` function.
The first argument defines the values mascaraing as variables that must
be gathered, in this case it's 1999 and 2000. The next argument defines
the key, or name of the new variable that holds these values. In the
case of table4a the key is year. Finally, the values associated with the
old variables need to be gathered into a new variable since they no
longer have a home. In this case "value" which defines the new variable
associated with year is "cases".

    table4a %>% 
      gather(`1999`, `2000`, key = "year", value = "cases")

    ## # A tibble: 6 x 3
    ##   country     year   cases
    ##   <chr>       <chr>  <int>
    ## 1 Afghanistan 1999     745
    ## 2 Brazil      1999   37737
    ## 3 China       1999  212258
    ## 4 Afghanistan 2000    2666
    ## 5 Brazil      2000   80488
    ## 6 China       2000  213766

<br  />

### Separate and Unite

Separate and unite tackle a different, and less common challenge in data
tidying. When one column contains multiple variables, or a variable is
spread across multiple columns, it's time to pull out these tools and
get to work.

#### One Column With Multiple Variables

    table3

    ## # A tibble: 6 x 3
    ##   country      year rate             
    ## * <chr>       <int> <chr>            
    ## 1 Afghanistan  1999 745/19987071     
    ## 2 Afghanistan  2000 2666/20595360    
    ## 3 Brazil       1999 37737/172006362  
    ## 4 Brazil       2000 80488/174504898  
    ## 5 China        1999 212258/1272915272
    ## 6 China        2000 213766/1280428583

<br  />

In table 3 the variable "rate" contains a fraction. Now it's possible
that rate may be a useful variable in the future, but more likely we'll
want it in decimal form. To split rate into two *separate* variables, we
employ the `separate()` function. The first argument of separate defines
the variable to be separated. The next argument is formatted as into =
c(...). You can use `separate()` to break a column apart into as many
variables as you see fit. In this case `separate()` is used to create
two new variables, "cases" and "population", as defined by the separator
"/".

    table3 %>%
      separate(rate, into = c("cases", "population", sep = "/"))

    ## # A tibble: 6 x 5
    ##   country      year cases  population `/`  
    ## * <chr>       <int> <chr>  <chr>      <chr>
    ## 1 Afghanistan  1999 745    19987071   <NA> 
    ## 2 Afghanistan  2000 2666   20595360   <NA> 
    ## 3 Brazil       1999 37737  172006362  <NA> 
    ## 4 Brazil       2000 80488  174504898  <NA> 
    ## 5 China        1999 212258 1272915272 <NA> 
    ## 6 China        2000 213766 1280428583 <NA>

<br  />

#### Single Variable Among Multiple Columns

    table5

    ## # A tibble: 6 x 4
    ##   country     century year  rate             
    ## * <chr>       <chr>   <chr> <chr>            
    ## 1 Afghanistan 19      99    745/19987071     
    ## 2 Afghanistan 20      00    2666/20595360    
    ## 3 Brazil      19      99    37737/172006362  
    ## 4 Brazil      20      00    80488/174504898  
    ## 5 China       19      99    212258/1272915272
    ## 6 China       20      00    213766/1280428583

<br  />

Table 5 presents a challenge best handled the inverse function of
`seperate()`, `combines()`. Century and year are two halves of a single
variable that must be "combined". The first argument of `combines()`
names the new composite variable, in this case it's "full\_year". The
next argument defines the columns in which the variables will be
combined from. Finally, a character to separate the two halves of the
new variable is created, in this case we don't want to separate the
first two digits from the last two digits of the year, so no character
is entered. As the inverse of separate, `combines()`

    table5 %>%
      unite(full_year, century, year, sep = "")

    ## # A tibble: 6 x 3
    ##   country     full_year rate             
    ## * <chr>       <chr>     <chr>            
    ## 1 Afghanistan 1999      745/19987071     
    ## 2 Afghanistan 2000      2666/20595360    
    ## 3 Brazil      1999      37737/172006362  
    ## 4 Brazil      2000      80488/174504898  
    ## 5 China       1999      212258/1272915272
    ## 6 China       2000      213766/1280428583

<br  />

Proper use of these four functions will make data tidying a breeze! The
intuitive functions of tidyr allow you to spend less time on preparing
your data, and more time on analyzing it. Stick around for the next
installment of the R4DS series, tibble!

Until next time, <br  /> - Fisher
