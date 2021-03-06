### Introduction

This is the second of eight installments in my *Unpacking the Tidyverse*
series. Each installment focuses on one of the eight core packages in
Hadley Wickham's tidyverse. Instructions given in each post are mainly
derived from Hadley's textbook, [R for Data
Science](http://r4ds.had.co.nz/), and CRAN package documentation. This
installment of *Unpacking the Tidyverse* focuses on the data-importing
package, readr. The previous installment focuses on the ggplot2 package,
and can be found [here](link). The next installment focuses on the dplyr
package, and can be found [here](link).

Spending a small amount of time to properly import, parse, and export
data will save countless hours of frustration later in your analysis.
The Tidyverse tool built to tackle these tasks is none other than the
readr package. Understanding how to properly utilize readr to increase
an analysis' reproducibility and decrease data structuring errors is a
worthy goal, and the main topic of this post.

<br>

    library('tidyverse')

<br>

### Important Package Functions

    read_delim()    # Importing .csv and .tsv files
    read_file()     # Importing text files
    read_xls()      # Importing excel files (from readxl)
    parse_*()       # Family of parsing functions
    write_delim()   # Explicitly export .csv and .tsv files
    write_file()    # Explicitly export text files
    ggsave()        # Explicitly save plots (from ggplot2)

<br>

### `read_delim()`

The two special cases of `read_delim()` are `read_csv()` and
`read_tsv()`. These two commands are useful for the most common type of
flat data files, comma separated files and tab separated files. If
you're using European .csv data with `;` as separators instead of
commas, use `read_csv2()`.

readr functions can be used on a variety of paths, some you might not
otherwise have known about:

    read_csv("mtcars.csv")
    read_tsv("mtcars.tsv.zip")
    read_tsv("~/local/path/to/my/file/mtcars.tsv")
    read_csv("https://github.com/tidyverse/readr/raw/master/inst/extdata/mtcars.csv")

As you can see, readr `read_` functions can access files within the
working directory, compressed files, files in other directories, or
files from the internet.

There are over a dozen arguments that can be included in a read
function, here are the ones that I find most useful. Type `?read_delim`
into the R console for the complete list of arguments.

    read_csv(
      "file_name.csv",            # file path and name always comes first
      delim=",",                  # single character field separator
      quote = "\"",               # single character to quote strings
      comment = "#",              # single character to signal comments
      col_names = c("add", "names", "or", "T/F"), # custom name columns on import
      na = ".",                   # string to signify missing values
      skip = 0,                   # number of lines to skip before reading data
      progress = show_progress()  # display a progress bar
      )

<br>

### `read_file()`

Typically used with text files, `read_file()` can also be used as a
backup read function to nearly any file type. `read_file()` reads a
complete file into a single object: either a character vector of length
one, or a raw vector (`read_file_raw()`). I use this function with the
single file path argument, It lacks the customization present in
`read_delim()` and should be used as a last resort for uncooperative
files that aren't `.txt`.

When working with text files, I suggest looking into the *tidytext*
library's `unnest_tokens()` function. Read more about tidytext
[here](https://www.tidytextmining.com/).

<br>

### `read_excel()`

I'm cheating a little bit with including `read_excel()`, as it is
actually from the readxl library. The package must be loaded separately
from the tidyverse.

    library('readxl')

`read_excel()` does just what you think it does! It auto detects the
format, `.xls` or `.xlsx` from the file extension. The function also
comes with a variety of customizable arguments, similar to
`read_delim()`.

    read_excel(
      "path/file_name.xlsx",   # path to excel file
      sheet = c("sheet1","sheet3"),  # name or integer position of sheets, defaults to first sheet
      range = "A1:D10",       # range of cells to be read, takes precedence over skip, n_max, sheet
      col_names = TRUE,       # true to use first row as col names
      col_types = NULL,       # NULL to have readr guess from spreadsheet 
      trim_ws = TRUE,         # should leading and trailing white space be trimmed?
      skip = 100,             # number of columns to skip before reading
      n_max = 1000            # maximum number of rows to read in
    )

<br>

### `parse_*()`

When the data you read in isn't structured properly, it's time to parse.
The readr library has a family of parsing functions built in to help
format your data. There are several parsing functions, including
`parse_logical`, `parse_factor`, `parse_atomic`, `parse_number`,
`parse_datetime` and more. Typically I use the last two, `parse_number`
and `parse_datetime`, so I'll cover those in detail.

Numeric entries can be surrounded by unwanted characters, such as “$100”
or “60%”. There's also the issue of grouping characters, e.g. 1,000,000
instead of 10000000. Finally, you may work with foreign data sources
that use the comma as a decimal point instead of the period, e.g. 1,00
instead of 1.00. Correcting these issues is simple with the parse
function.

    a <- "The price is $1993"
    str(a)

    ##  chr "The price is $1993"

    a <- parse_number(a)
    str(a)

    ##  num 1993

<br  />

    a <- "1,99"
    str(a)

    ##  chr "1,99"

    a <- parse_double(a, locale = locale(decimal_mark = ","))
    str(a)

    ##  num 1.99

<br  />

    a <- "$100.000.000"
    str(a)

    ##  chr "$100.000.000"

    a <- parse_number(a, locale = locale(grouping_mark = "."))
    str(a)

    ##  num 1e+08

<br>

Parsing numbers is easy, but dates can be a little trickier. There are
so many ways to denote a date-time, but ISO8601 is an international
date-time standard that is often used. ISO8601 orders the components
from largest to smallest - year, month, day and optionally a T followed
by hour, minute, second. If your date-time is in this format, parsing it
is a breeze.

    a <- "20180228"
    parse_datetime(a)

    ## [1] "2018-02-28 UTC"

    b <- "2018-02-28T20:10:59"
    parse_datetime(b)

    ## [1] "2018-02-28 20:10:59 UTC"

<br  />

If you're only working with dates or only times, use `parse_date` or
`parse_time`. The dates function expects a four digit year with a “-“ or
“/” followed by the month with a “-“ or “/” followed by the day. The
times function expects the hour value followed by a “:” followed by the
minutes value with another “:” and finally then the seconds value.

    a <- "2018/02/28"
    parse_date(a)

    ## [1] "2018-02-28"

    b <- "11:11:11"
    parse_time(b)

    ## 11:11:11

<br  />

Sometimes your data doesn't follow any of these formatting requirements,
readr gives you the ability to build your own parsing formulas using
these building blocks.

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

    a <- "Jan 7 2018"
    parse_date(a, "%b %d %Y")

    ## [1] "2018-01-07"

    b <- "12:45 am"
    parse_time(b, "%I:%M %p")

    ## 00:45:00

<br>

### `write_delim()`

When your analysis is complete and you’re ready to save a .csv or .tsv
file, readr comes back into action. It’s important to explicitly save
files from within R scripts to increase an analysis' reproducibility.

    write_csv(
      dataframe,                    # The R object you want to save 
      "path/to/file/filename.csv",  # The saved files name and path
      delim = " ",                  # Custom delimiter
      na = "NA",                    # Set NA values
      append = FALSE                # Concatenate to a file or overwrite, T/F
      )

A straight forward function, *write\_csv( )* saves your defined data as
a .csv file to the destination and name you specify as the second
argument. write\_csv( ) allows you to specify delimiters, missing values
and more. Type ?write\_csv into the R console for more arguments.

<br>

### `write_file()`

There isn't much explaining to be done about `write_file`, it only has
four arguments to worry about, just liek `read_file`. They're the same
arguments and the function does just what you would expect; it's
included in this post just so you know that it exists!

<br>

### `ggsave()`

From the ggplot2 library, which is also loaded with the tidyverse,
`ggsave` is the `write_file` equivalent to plots. A key difference is
the order of arguments in the function. With `ggsave` the filename is
defined before the plot is defined, as shown in this example.

    library(‘ggplot2’)

    ggsave(
      filename = "path/to/file/filename.png",  #
      plot = last_plot(),          #
      scale = 1,                   #
      width = NA,                  # 
      height = NA                  #
    )

<br>

That covers the ins and outs of the readr package as taught in the R for
Data Science book by Hadley Wickham. These basic functions are essential
to getting your data science project up and running. For more tips and
tricks on properly maintaining a data science project, check out my post
[Data Science Project Management](link).

If you found this summary helpful, check out the other posts on
*Unpacking the Tidyverse*.

Additional Resources: <br> - [CRAN
Documentation](https://cran.r-project.org/web/packages/readr/readr.pdf)
<br> - [Github Repository](https://github.com/tidyverse/readr) <br> -
[Other Import
Methods](https://www.r-bloggers.com/this-r-data-import-tutorial-is-everything-you-need/)
<br>

Until next time, <br> - Fisher
