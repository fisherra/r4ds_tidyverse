This is the fourth installment of a six-part series summarizing the
concepts of Hadley Wickham's textbook, [R for Data
Science](http://r4ds.had.co.nz/). In the previous blog [post](link) I
abridged the book’s chapter that covers data wrangling with dplyr.

In this post, I’ll be focusing on chapter five which covers data
transformation primarily with the dplyr package. dplyr shares tidyverse
center stage with ggplot2; unfortunately, dplyr has a steeper learning
curve than its co-star, ggplot2. I've written a post on data
visualization with ggplot2 [here](post). When it comes to dplyr and data
wrangling, it is a topic best learned through hours of practice and
experience rather than careful explanation. As such, I hope to offer an
easily understood reference guide in this post, rather than a detailed
tutorial.

For more in-depth resources on tidyr, reference these links:

-   -   -   -   

<br  />

#### Libraries

    library('tidyverse')      # includes tidyr
    library('tidyr')          # tidyr specifically

<br  />

What is tidy data?

dataframe variable\_1 variable\_2 variable\_3
=============================================

observe\_1 value value value
============================

observe\_2 value value value
============================

observe\_3 value value value
============================

observe\_4 value value value
============================

observe\_5 value value value
============================

###################################################################### 

Functions
---------

###################################################################### 

gather() \# takes multiple clumns and collapsesinto key-value pairs

spread() \# spreads a key-value pair across multiple columns

separate() \# single column into multiple columns, defined seperator

unite() \# multiple columns into single column, defined seperator

left\_join() \# combine a table

fill() \# fills missing values using the previous entry

###################################################################### 

Examples
--------

###################################################################### 

Gather
------

table4a table4a %&gt;% gather(`1999`, `2000`, key = "year", value =
"cases")

'gather' columns titled `1999`, and `2000`, as these are values,
================================================================

not variables.
==============

'key' a new column called 'year' to put 1999 and 2000 into.
===========================================================

values associated with the new column 'year' need a new home
============================================================

we now call them 'cases'. they still match with the intended years
==================================================================

Spread
------

table2 table2 %&gt;% spread(key = type, value = count)

table 2's type column contains two different variables, cases and pop
=====================================================================

we need to spread these into two new column heads, so spread(key = type,
========================================================================

and the associated data is column count, or value = count). thats it!
=====================================================================

Seperate
--------

table3 table3 %&gt;% seperate(rate, into = c("cases", "population", sep
= "/"))

pulls one column apart into multiple columns, default is by a
=============================================================

non alphanumeric chr, but put in the sep variable if you want
=============================================================

dealing with missing values
---------------------------

tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %&gt;% separate(x, c("one",
"two", "three"), extra="drop") \# drops that extra value completely

tibble(x = c("a,b,c", "d,e", "f,g,i")) %&gt;% separate(x, c("one",
"two", "three"), fill ="right") \# fills the row by putting an NA on the
right

Unite
-----

table5 table5 %&gt;% unite(full\_year, century, year, sep = "")

declare a new column name, and unite two defined old variables by
=================================================================

the indicated seperator.
========================

Join
----

tidy4a &lt;- table4a %&gt;% gather(`1999`, `2000`, key = "year", value =
"cases") tidy4b &lt;- table4b %&gt;% gather(`1999`, `2000`, key =
"year", value = "population") left\_join(tidy4a, tidy4b)

after gathering the datasets into similiar, tidy dataframes, left\_join()
=========================================================================

combines them into a signle frame.
==================================

Fill
----

treatment &lt;- tribble(  
person, ~ treatment, ~response, "Derrick Whitmore", 1, 7, NA, 2, 10, NA,
3, 9, "Katherine Burke", 1, 4 ) treatment %&gt;% fill(person)

fill() will carry forward the last value for that column
========================================================
