This is the third of a six-part series summarizing the core concepts of
Hadley Wickham's textbook, R for Data Science <http://r4ds.had.co.nz/>.
In the previous [post](link) I've abridged the book’s chapters that
cover data handling with readr.

In this post, I’ll be focusing on the dplyr package. I consider dplyr to
be the centr peice and of the tidyverse, unfortunately it also has the
steepest learning curve. I'm not going to attempt to teach dplyr to you,
the only way to learn it is through hours of practice, instead I hope to
offer a quick refresher on functions, what they do, and examples of
their use.

For more useful resources on dplyr, reference these links:

-   -   -   

<br  />

#### Libraries

    library('nycflights13')   # example dataset 
    library('tidyverse')      # includes dplyr
    library('dplyr')          # dplyr specifically

<br  />

Many assert that over 80% of an analytical project is data wrangling,
that makes for ample opportunity to become a masterful dplyr user. Seven
core functions make up the core component of dplyr. They can be easy to
mix up at first, so I've created this list with a short comment to help
you keep them straight. Below this list of seven primary dplyr commands
is a longer list of secondary commands. Although used less commonly,
these cmmands can also be helpful in a variety of circumstances.

<br  />

#### Primary Commands

    filter()       # select rows based on value 
    arrange()      # sort rows based on values 
    select()       # zoom in on specified columns
    mutate()       # create new variables from existing ones 
    summarise()    # collapse dataframe to single summary
    group_by()     # analyze by specified group, useful for summarise 
    %>%            # connecting pipe, read as "then"

<br  />

#### Secondary Commands

    transmute()    # create new variables from existing ones, destroy existing ones
    ungroup()      # literally the name
    rename()       # literally the name 
    desc()         # descending order (large to small, z to a)
    count()        # simple function counting entries in a variable
    n()            # number of entries
    lag()          # offset, allows to refer to lagging (-1) value
    lead()         # offset, allows to refer to leading (+1) value
    cumsum()       # cumulative sum, also prod, mean, min, max 

<br  />

There's a lot to go through, I'll just explore primary commands in
straight foward examples. Again the best way to learn dplyr is to use
it. Hadley Wickham's R for Data Science book offers hours worth of
challenges using the flights dataset, these are just the most straight
forward usages.

<br  />

#### Dataset

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

The flights dataset gives on-time data for all flights that departed
from New York City in 2013. There are 19 columns or variables, and
336,776 rows or observations. A large and diverse dataset such as
flights is perfect for learning how to use dplyr.

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

Filter finds rows in which a condition is true. In the above example the
filter function is used on the flights dataset, as declared in the first
arguement. A set of condition follows - the months variable must equal
12 (December), and the day variable must also equal 25. These conditions
return a flights dataset with only 719 observations, these are the 719
flights that departed New York City on Christmas Day, 2013.

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

Arrange is a simple function, it reorders observations in a described
fashion. The above example reorders the flights dataset by descending
departure time. In other words, flights with the greatest (latest)
departure time are moved to the top of the dataset. Flights with the
least (earliest) departure time are moved to the bottom of the dataset.

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

Select keeps only the variables you mention as arguements behind the
initial dataframe arguement. In the above example, select returns all
observations between the year and day variable, in this case that just
means the month variable.

<br  />

#### Mutate

    mutate(flights, speed = distance / air_time * 60)

    ## # A tibble: 336,776 x 20
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
    ## # ... with 336,766 more rows, and 9 more variables: tailnum <chr>, origin
    ## #   <chr>, dest <chr>, air_time <dbl>, distance <dbl>, hour <dbl>, minute
    ## #   <dbl>, time_hour <dttm>, speed <dbl>

<br  />

Mutate adds a new variable based on the existing variables, while
retaining these existing variables. In the above example, mutate creates
a variable flight, which takes each observations distance value, divides
it by each observations air\_time value, then multiplies the product? by
60. Mutatedoes vectorized math.

<br  />

#### Summarise

    summarise(flights, delay = mean(dep_delay)) 

    ## # A tibble: 1 x 1
    ##   delay
    ##   <dbl>
    ## 1    NA

<br  />

Summarise doesnt seem to be working right now. The output has one row
for each group. In the above example summarise creates a new variable,
yeah I dont really know how to use summarise correctly. look this up.

<br  />

#### Group By

    group_by(flights, dest) %>%                        # group flights by destination
      summarise(count = n(),                           # summarise # of flights have invidual dest as variable "count"
                dist = mean(distance, na.rm = TRUE),   # distance = mean distance to each group_by() destination
                delay = mean(arr_delay, na.rm = TRUE)  # delay = mean arrival delay for each group_by() destination
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

A function that compliments summarise nicely, group by does groups by.
in the above example...

<br  />

#### Complex Inqueries

    denver_xmas_delay <- flights %>%                          # create new dataframe, denver_xmas_delay
      select(-tailnum) %>%                                    # leave out tailnum from new dataframe
      filter(month == 12 & day == 25 & dest == "DEN") %>%     # only keep christmas day flights, destination denver
      group_by(carrier) %>%                                   # group further analysis by carrier company
      summarise(num_flights = n(),                            # num_flights that fits analysis, grouped by carrier
                avg_delay = mean(dep_delay)) %>%              # average delay (by carrier) = mean(departure delay)
      arrange(desc(avg_delay))                                # arrange (by carrier) by biggest delay
    denver_xmas_delay                                         # print results

    ## # A tibble: 5 x 3
    ##   carrier num_flights avg_delay
    ##   <chr>         <int>     <dbl>
    ## 1 UA                6     14.0 
    ## 2 WN                4     10.8 
    ## 3 DL                3    - 1.00
    ## 4 F9                2    - 4.00
    ## 5 B6                1    - 5.00

All of these primary functions can be strung together using the %&gt;%
'then' pipe, and any combination of the forementioned secondary
commands. Build up the chain one command at a time, don't try to write
it all then run it all at once. Possible to sort through millions of
elements with relative ease, create new elements, focus your data
analysis, extract meaning from enormous and complex datasets. dplyr is
truely the bread and butter of data science with R, it may frusterate at
times but it's an extremely powerful tool.

Read the chapter on it if you'd like practice, again this is just a
quick reference if you forget the important core components of dplyr or
how to use them.

If you found this summary helpful, stay tuned for part four of the R4DS
summary series, Tidy Data with tidyr.

Until next time, <br  /> - Fisher
