This is the second of a six-part series summarizing the core concepts of
Hadley Wickham's textbook, R for Data Science <http://r4ds.had.co.nz/>.
In the previous [post](link) I've abridged the book’s chapters that
cover data visualization with ggplot2.

In this post, I’ll be focusing on readr, a core component of the
Hadley’s tidyverse packages. Importing, parsing, and exporting data may
sound trivial, but it is an integral part of the data science workflow;
developing good data handling habits is a worthy goal. Properly
utilizing readr can increase an analysis’ reproducibility and decreasing
data structuring errors, all while saving you precious time.

For more useful resources on readr and other data importing methods,
check out these links:

-   readr package documentation
    <https://cran.r-project.org/web/packages/readr/readr.pdf>
-   readr Github repository - <https://github.com/tidyverse/readr>
-   Non-readr import methods
    <https://www.r-bloggers.com/this-r-data-import-tutorial-is-everything-you-need/>

<br  />

#### Load Libraries

    library('tidyverse') # used for many amazing things, includes readr library
    library('readr')     # used to read in a variety of file types
    library('readxl')    # used for reading in Microsoft excel files

You may also be interested in the following libraries; however I won't
cover them in this blog post -

    library('haven')       # used for SPSS, SAS, and Strata input files
    library('DBl')         # used for database files, must combine with specific backend
    library('RMySQL')      # used for MySQL backend (with DBl)
    library('RSQLite')     # used for SQLLite backend (with DBl)
    library('RPostgreSQL') # used for PostgreSQL (with DBl)

<br  />

### Reading Data

The readr and readxl libraries gives a variety of functions that turn
flat files into data frames. These are the functions that I most often
find useful.

    read_file()     # catch all, useful for .txt files
    read_csv()      # comma seperative files
    read_tsv()      # tab seperated files
    read_xls()      # excel files (from readxl)

readr functions can be used on a variety of paths, some of these you
might not have otherwise known about.

    # example paths 
    read_csv("mtcars.csv")
    read_csv("mtcars.csv.zip")
    read_csv("~/local/path/to/my/file/mtcars.csv")
    read_csv("https://github.com/tidyverse/readr/raw/master/inst/extdata/mtcars.csv")

In the first line of the above example code, readr simply processes a
.csv file found in the current working directory. You can find your
current working directory using the base R *getwd( )* function. Next,
exhibits a file that has a .zip extension. readr can unpack compressed
files with .zip, .bz2, and other similar extensions. The third line is
an example of readr following a local path to a folder in which R isn't
currently working in. Set your current working directory in RStudio
using the setwd( ) function or the navigation within the files panel.
The fourth and final example is following an online path to a described
dataset. Go ahead and follow the path and have a look at where it's
pointing if you wish.

<https://github.com/tidyverse/readr/raw/master/inst/extdata/mtcars.csv>

readr functions can be expanded to include arguments that make your
imported data more suitable for analysis. Here are the arguments I use
the most commonly. Type ?read\_csv to the R console for a full
description of possible arguments.

    read_csv("file_name.csv",            # file path and name always comes first
             delim=",",                  # single character field separator
             quote = "\"",               # single character to quote strings
             comment = "#",              # single character to signal comments
             col_names = c("add", "names", "or", "T/F"), # custom name columns on import
             na = ".",                   # string to signify missing values
             skip = 0,                   # number of lines to skip before reading data
             progress = show_progress()  # display a progress bar
             )

<br  />

### Data Parsing

Rarely can you read in files that have correctly structured data. The
readr library has a family of parsing functions built in to turn
character string into your desired data structure. Parsing can be used
to format data into any structure, but I most often use it to clean up
number and date-time values.

Numeric entries can be surrounded by unwanted characters, such as “$100”
or “60%”. There's also the issue of grouping characters, e.g. 1,000,000
instead of 10000000. Finally, you may work with foreign data sources
that use the comma as a decimal point instead of the period, e.g. 1,00
instead of 1.00. Let's go through how to correct these common issues
using simple parsing.

<br  />

##### Unwanted Characters

    a <- "The price is $1993"
    str(a)

    ##  chr "The price is $1993"

    a <- parse_number(a)
    str(a)

    ##  num 1993

<br  />

##### Decimal Points

    a <- "1,99"
    str(a)

    ##  chr "1,99"

    a <- parse_double(a, locale = locale(decimal_mark = ","))
    str(a)

    ##  num 1.99

<br  />

##### Group Markers

    a <- "$100.000.000"
    str(a)

    ##  chr "$100.000.000"

    a <- parse_number(a, locale = locale(grouping_mark = "."))
    str(a)

    ##  num 1e+08

<br  />

Dates and times can become confusing since there are so many ways to
write them. ISO8601 is an international date-time standard in which the
components are ordered largest to smallest - year, month, day and
optionally a T followed by hour, minute, second. If no time is
specified, the parsing function sets the time to midnight. Here’s an
example of parsing out ISO8601 date-time.

<br  />

#### ISO8601 Date - Time

    a <- "20180228"
    parse_datetime(a)

    ## [1] "2018-02-28 UTC"

    b <- "2018-02-28T20:10:59"
    parse_datetime(b)

    ## [1] "2018-02-28 20:10:59 UTC"

<br  />

Parsing only dates or only times is even more straight forward. The
dates function expects a four digit year with a “-“ or “/” followed by
the month with a “-“ or “/” followed by the day. The times function
expects the hour value followed by a “:” followed by the minutes value
with another “:” and finally then the seconds value.

<br  />

#### Dates or Times

    a <- "2018/02/28"
    parse_date(a)

    ## [1] "2018-02-28"

    b <- "11:11:11"
    parse_time(b)

    ## 11:11:11

<br  />

Say you've got a date-time to parse that isn't in the ISO8601 format,
perhaps the months are spelled out properly or there’s an AM/PM
indicator. For these and similar situations you can create your own
date-time parsers using these building blocks indicators.

<br  />

##### Year <br  />

%Y - 4 digit year number <br  /> %y - last 2 digit year number; 00-69 =
2000 - 2069, 70-99 = 1970 - 1999 <br  />

##### Month <br  />

%m - 2 digit month number <br  /> %b - abbreviated month name, e.g.
"Jan" <br  /> %B - full month name, e.g. "January" <br  />

##### Day <br  />

%d - 2 digit day number <br  /> %e - option leading space <br  />

##### Time <br  />

%H - 0 to 23 hour <br  /> %I - 0 to 12 hour, must be used with %p
<br  /> %p - AM / PM indicator <br  /> %M - minutes <br  /> %S - integer
seconds <br  /> %OS - real seconds <br  /> %Z - time zone, e.g.
America/Chicago <br  /> %z - time zone, offset from UTC, e.g. +0800
<br  />

##### Other <br  />

%. - skips one non-digit character <br  /> %\* - skips any number of
non-digits <br  />

<br  />

#### Custom Date - Times

    a <- "Jan 7 2018"
    parse_date(a, "%b %d %Y")

    ## [1] "2018-01-07"

    b <- "12:45 am"
    parse_time(b, "%I:%M %p")

    ## 00:45:00

<br  />

### Writing Data

When your analysis is complete and you’re ready to save the altered .csv
files or newly created figures, readr can come back into action. It’s
important to explicitly save files from within the R script to properly
keep track of figures data sources and increase an analysis’
reproducibility. You never want to answer the question, “where did this
plot come from?” with “I don’t know”. readr can help with that.

<br  />

#### .csv Files

    write_csv(
      dataframe,                    #
      "path/to/file/filename.csv",  #
      delim = " ",                  #
      na = "NA",                    #
      append = FALSE                # 
    )

A straight forward function, *write\_csv( )* saves your defined data as
a .csv file to the destination and name you specify as the second
argument. write\_csv( ) allows you to specify delimiters, missing values
and more. Type ?write\_csv into the R console for more arguments.

<br  />

#### Image Files

    library(‘ggplot2’)

    ggsave(
      filename = "path/to/file/filename.png",  #
      plot = last_plot(),          #
      scale = 1,                   #
      width = NA,                  # 
      height = NA                  #
    )

This one comes from the ggplot2 package, so make sure you’ve loaded it
into your library before attempting to call it. ggsave( ) swaps the
order of the arguments, putting the filename and path before the
specified plot, otherwise it’s a very similar function to write\_csv( ).
Type ?ggsave into the R console for more information on arguments used
with the ggsave function.

That covers the ins and outs of the readr package as taught in the R for
Data Science book by Hadley Wickham. These basic functions are essential
to getting your data science project up and running. For more tips and
tricks on properly maintaining a data science project, check out my post
[Data Science Project Management](link).

If you found this summary helpful, stay tuned for part three of the R4DS
summary series, data wrangling with dplyr.

Until next time, <br  /> - Fisher