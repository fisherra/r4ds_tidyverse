This is the third installment of a six-part series summarizing the
concepts of Hadley Wickham's textbook, [R for Data
Science](http://r4ds.had.co.nz/). In the previous blog [post](link) I
abridged the book’s chapters that cover importing, parsing, and
exporting data with readr.

In this post, I’ll be focusing on chapter five which covers data
transformation primarily with the dplyr package. dplyr shares tidyverse
center stage with ggplot2; unfortunately, dplyr has a steeper learning
curve than its co-star, ggplot2. I've written a post on data
visualization with ggplot2 [here](post). When it comes to dplyr and data
wrangling, it is a topic best learned through hours of practice and
experience rather than careful explanation. As such, I hope to offer an
easily understood reference guide in this post, rather than a detailed
tutorial.

For more in-depth resources on dplyr, reference these links:

-   [RStudio’s Data Wrangling
    Cheatsheet](https://www.rstudio.com/wp-content/uploads/2015/02/data-wrangling-cheatsheet.pdf)
-   [Data School’s dplyr Tutorial
    Video](https://www.youtube.com/watch?v=jWjqLW-u3hc)
-   [CRAN Introduction to
    dplyr](https://cran.r-project.org/web/packages/dplyr/vignettes/dplyr.html)
-   [CRAN dplyr Documentation
    (long)](https://cran.r-project.org/web/packages/dplyr/dplyr.pdf)

<br  />

#### Libraries

    library('nycflights13')   # example dataset 
    library('tidyverse')      # includes dplyr
    library('dplyr')          # dplyr specifically

<br  />

Some data scientists assert that over 80% of their time is used
wrangling data; see this as an opportunity and important reason to
master the art of dplyr. If you're looking to make the most of your data
analysis routine, it makes sense to streamline the largest portion of
your work-load before seeking efficiency elsewhere.

I've compiled this list of seven primary commands that form the core of
dplyr's functionality. These are the most influential and called upon
functions in the dplyr package. Seven second-tier functions follow;
these commands are commonly useful but not as influential as the primary
functions listed before them.

<br  />

#### Primary Functions

    filter()       # select rows based on value 
    arrange()      # sort rows based on values 
    select()       # zoom in on specified columns
    mutate()       # create new variables from existing ones 
    summarize()    # collapse dataframe to single summary
    group_by()     # analyze by specified group, useful for summarize 
    %>%            # connecting pipe, read as "then"

<br  />

#### Secondary Functions

    transmute()    # create new variables from existing ones, remove existing variables
    ungroup()      # literally the name
    desc()         # descending order (large to small, z to a)
    count()        # simple function counting entries in a variable
    n()            # number of entries
    lag()          # offset, allows to refer to lagging (-1) value
    lead()         # offset, allows to refer to leading (+1) value

<br  />

I'll give specific examples for the first seven of these functions, and
attempt to include the second seven throughout these examples. Again,
the goal of this post is to be a quick-reference as to the functionality
of dplyr, not an in-depth tutorial. The best way to learn data wrangling
is experience, [R for Data Science Chapter
5](http://r4ds.had.co.nz/transform.html) has many examples and
challenges you can work through to solidify your dplyr skills.

<br  />

#### Example Dataset

    flights

    ## # A tibble: 336,776 x 19
    ##     year month   day dep_t… sched_… dep_d… arr_… sched… arr_d… carr… flig…
    ##    <int> <int> <int>  <int>   <int>  <dbl> <int>  <int>  <dbl> <chr> <int>
    ##  1  2013     1     1    517     515   2.00   830    819  11.0  UA     1545
    ##  2  2013     1     1    533     529   4.00   850    830  20.0  UA     1714
    ##  3  2013     1     1    542     540   2.00   923    850  33.0  AA     1141
    ##  4  2013     1     1    544     545  -1.00  1004   1022 -18.0  B6      725
    ##  5  2013     1     1    554     600  -6.00   812    837 -25.0  DL      461
    ##  6  2013     1     1    554     558  -4.00   740    728  12.0  UA     1696
    ##  7  2013     1     1    555     600  -5.00   913    854  19.0  B6      507
    ##  8  2013     1     1    557     600  -3.00   709    723 -14.0  EV     5708
    ##  9  2013     1     1    557     600  -3.00   838    846 - 8.00 B6       79
    ## 10  2013     1     1    558     600  -2.00   753    745   8.00 AA      301
    ## # ... with 336,766 more rows, and 8 more variables: tailnum <chr>, origin
    ## #   <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>, minute
    ## #   <dbl>, time_hour <dttm>

<br  />

Flights is a classic dataset that is large and diverse, perfect for
testing out the primary functions of dpylr. This dataset gives on-time
data for all flights that departed from New York City in 2013. There are
19 columns or variables, and 336,776 rows or observations.

<br  />

#### Filter

    filter(flights, month == 12 & day == 25)

    ## # A tibble: 719 x 19
    ##     year month   day dep_t… sched_… dep_d… arr_… sched… arr_d… carr… flig…
    ##    <int> <int> <int>  <int>   <int>  <dbl> <int>  <int>  <dbl> <chr> <int>
    ##  1  2013    12    25    456     500  -4.00   649    651 - 2.00 US     1895
    ##  2  2013    12    25    524     515   9.00   805    814 - 9.00 UA     1016
    ##  3  2013    12    25    542     540   2.00   832    850 -18.0  AA     2243
    ##  4  2013    12    25    546     550  -4.00  1022   1027 - 5.00 B6      939
    ##  5  2013    12    25    556     600  -4.00   730    745 -15.0  AA      301
    ##  6  2013    12    25    557     600  -3.00   743    752 - 9.00 DL      731
    ##  7  2013    12    25    557     600  -3.00   818    831 -13.0  DL      904
    ##  8  2013    12    25    559     600  -1.00   855    856 - 1.00 B6      371
    ##  9  2013    12    25    559     600  -1.00   849    855 - 6.00 B6      605
    ## 10  2013    12    25    600     600   0      850    846   4.00 B6      583
    ## # ... with 709 more rows, and 8 more variables: tailnum <chr>, origin
    ## #   <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>, minute
    ## #   <dbl>, time_hour <dttm>

<br  />

*Filter* is a simple function that finds, or 'filters' observations that
match true to a declared condition. In this example *filter* first's
argument is the flights dataset, the following arguments declare the
conditions to be met. Retain observations (rows) with the months
variable equal to 12, and the day variable equal to 25. The result is a
dataframe with 719 flights that departed New York City on Christmas Day,
2013.

<br  />

#### Arrange

    arrange(flights, desc(dep_time))

    ## # A tibble: 336,776 x 19
    ##     year month   day dep_t… sched… dep_de… arr_… sche… arr_de… carr… flig…
    ##    <int> <int> <int>  <int>  <int>   <dbl> <int> <int>   <dbl> <chr> <int>
    ##  1  2013    10    30   2400   2359    1.00   327   337 - 10.0  B6      839
    ##  2  2013    11    27   2400   2359    1.00   515   445   30.0  B6      745
    ##  3  2013    12     5   2400   2359    1.00   427   440 - 13.0  B6     1503
    ##  4  2013    12     9   2400   2359    1.00   432   440 -  8.00 B6     1503
    ##  5  2013    12     9   2400   2250   70.0     59  2356   63.0  B6     1816
    ##  6  2013    12    13   2400   2359    1.00   432   440 -  8.00 B6     1503
    ##  7  2013    12    19   2400   2359    1.00   434   440 -  6.00 B6     1503
    ##  8  2013    12    29   2400   1700  420      302  2025  397    AA     2379
    ##  9  2013     2     7   2400   2359    1.00   432   436 -  4.00 B6      727
    ## 10  2013     2     7   2400   2359    1.00   443   444 -  1.00 B6      739
    ## # ... with 336,766 more rows, and 8 more variables: tailnum <chr>, origin
    ## #   <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>, minute
    ## #   <dbl>, time_hour <dttm>

<br  />

Often observations within a dataframe are ordered arbitrarily, or
unproductively. *Arrange* reorders observations according to its user
specified arguments. In this example, the flights dataframe is called
upon as the first argument once again; this is common syntax within
dplyr functions and I won't be referencing it henceforth. The second
argument is *desc(dep\_time)*. *desc* is one of the secondary functions
listed previously; it simply transforms a vector into a format that will
be sorted in descending order. *dep\_time* is the flights variable
departure time, a number from 0000 to 2400, indicating the actual
departure time of an individual aircraft. The resulting dataframe has
all 336,776 observations sorted from latest (highest) to earliest
(lowest) departure time.

<br  />

#### Select

    select(flights, year:day)

    ## # A tibble: 336,776 x 3
    ##     year month   day
    ##    <int> <int> <int>
    ##  1  2013     1     1
    ##  2  2013     1     1
    ##  3  2013     1     1
    ##  4  2013     1     1
    ##  5  2013     1     1
    ##  6  2013     1     1
    ##  7  2013     1     1
    ##  8  2013     1     1
    ##  9  2013     1     1
    ## 10  2013     1     1
    ## # ... with 336,766 more rows

<br  />

In a dataframe with numerous variables it's easy become overwhelmed and
broad with analysis. *Select* reduces the number of variables in a
dataframe, only keeping variables that the user inputs as arguments. In
this example, flights are reduced from 19 variables to the variables
year, month and day.

<br  />

#### Mutate

    mutate(flights, speed = distance / air_time * 60) %>%
      select(tailnum, distance, air_time, speed)

    ## # A tibble: 336,776 x 4
    ##    tailnum distance air_time speed
    ##    <chr>      <dbl>    <dbl> <dbl>
    ##  1 N14228      1400    227     370
    ##  2 N24211      1416    227     374
    ##  3 N619AA      1089    160     408
    ##  4 N804JB      1576    183     517
    ##  5 N668DN       762    116     394
    ##  6 N39463       719    150     288
    ##  7 N516JB      1065    158     404
    ##  8 N829AS       229     53.0   259
    ##  9 N593JB       944    140     405
    ## 10 N3ALAA       733    138     319
    ## # ... with 336,766 more rows

<br  />

*Mutate* allows users to alter current variables and create new ones
through various vectorized functions. In the above example the variable
speed is created and is equal to distance divided by air time multiplied
by 60. The pipe function %&gt;%, is used to move the *mutate* output to
*select*. The new variable, speed, is output by the *select* function,
along with each flight's tail number, air time, and travel distance.

<br  />

#### Summarize

    summarize(flights, delay = mean(dep_delay, na.rm = TRUE))

    ## # A tibble: 1 x 1
    ##   delay
    ##   <dbl>
    ## 1  12.6

<br  />

*Summarize* is perhaps the most complicated function in dplyr. Often
used in conjunction with *group\_by*, *summarize* collapses many values
into a single summary. In the above example. *summarize* finds the mean
departure delay of all 336,776 observations in the flights dataset. As a
result, the single value 12.64 (minutes) summarizes the mean departure
delay.

<br  />

#### Group By

    group_by(flights, dest) %>%                       
      summarize(count = n(),                          
                dist = mean(distance, na.rm = TRUE),  
                delay = mean(arr_delay, na.rm = TRUE) 
                ) 

    ## # A tibble: 105 x 4
    ##    dest  count  dist  delay
    ##    <chr> <int> <dbl>  <dbl>
    ##  1 ABQ     254  1826   4.38
    ##  2 ACK     265   199   4.85
    ##  3 ALB     439   143  14.4 
    ##  4 ANC       8  3370 - 2.50
    ##  5 ATL   17215   757  11.3 
    ##  6 AUS    2439  1514   6.02
    ##  7 AVL     275   584   8.00
    ##  8 BDL     443   116   7.05
    ##  9 BGR     375   378   8.03
    ## 10 BHM     297   866  16.9 
    ## # ... with 95 more rows

<br  />

*Summarize* becomes extremely useful when paired with the final primary
dplyr function, *group\_by*. *group\_by* changes the unit of analysis
from the complete dataset to an individual group, thus changing the
scope of summarize. In the above example, the flights dataset is grouped
by the dest variable, destination. Grouping by destination by itself
does nothing to the dataframe, so the then pipe, %&gt;%, is used to push
the output to the *summarize* function. Summarize first creates a count
variable that is equivalent to the function *n( )*. *n( )* is another
one of those secondary dplyr functions that often comes in handy; *n( )*
is a function that finds the number of observations in the current
group. Next, *summarize* creates a variable named distance based off the
mean distance travelled by each observation, as grouped by destination.
Finally, *summarize* creates a variable named delay, based off the mean
arrival delay each observation experienced, as grouped by destination.
The resulting dataframe gives excellent insight into each of the 105
destinations present in the flights dataset.

<br  />

#### Complex Inquiries

    denver_xmas_delay <- flights %>%                          # create new dataframe, denver_xmas_delay, then
      select(-tailnum) %>%                                    # select all variables except for tailnum 
      filter(month == 12 & day == 25 & dest == "DEN") %>%     # filter only flights with destination Denver on Christmas
      group_by(carrier) %>%                                   # now group fights by carrier company for summary analysis
      summarize(num_flights = n(),                            # create num_flights variable, equal to the count sorted by carrier
                avg_delay = mean(dep_delay)) %>%              # create avg_delay variable, equal to mean departure delay by carrier
      arrange(desc(avg_delay))                                # arrange these carriers by the new avg_delay variable
    denver_xmas_delay                                         # print results

    ## # A tibble: 5 x 3
    ##   carrier num_flights avg_delay
    ##   <chr>         <int>     <dbl>
    ## 1 UA                6     14.0 
    ## 2 WN                4     10.8 
    ## 3 DL                3    - 1.00
    ## 4 F9                2    - 4.00
    ## 5 B6                1    - 5.00

<br  />

These primary dplyr functions are effortlessly strung together with the
pipe, %&gt;%, to create a complex and extremely specific inquiry into
the dataframe. Dplyr's advantage over base R resides in its readability
(largely due to the pipe), as well as it's intuitive use functions. I
find it's far easier to build a complex inquiry like the example above,
one step at a time. It's far easier after each step instead of saving it
for the end.

Dplyr can often be a frustrating package to work with, but once you've
become proficient at data wrangling, Hadley Wickham's package becomes
near indispensable. Hopefully this reference guide can help you on your
journey to mastering dplyr and data wrangling with R. Stay tuned for
part four of the six part R4DS summary series, tidy data with tidyr.

Until next time, <br  /> - Fisher
