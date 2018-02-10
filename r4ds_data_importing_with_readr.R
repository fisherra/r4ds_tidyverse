#####################################
##       R For Data Science        ##
#####################################

# readr Data Importing Summary 

# Synthesizing information from chapter 11



######################################################################
## Install Packages  #################################################
######################################################################

library('tidyverse') # all tidyverse packages
library('readr') # dplyr specifically
library('readxl') # read excel spreadsheets


######################################################################
## Reading Data ######################################################
######################################################################

# useful functions

read_csv()      # comma seperative file

read_xls()      # excel file

read_tsv()      # tab seperated file

read_fwf()      # fixed width file

read_delim()    # delimited file

# example paths 
read_csv("mtcars.csv")
read_csv("mtcars.csv.zip")
read_csv("mtcars.csv.bz2")
read_csv("https://github.com/tidyverse/readr/raw/master/inst/extdata/mtcars.csv")
read_csv("x,y\n1,2\n3,4")

# expanded options
read_csv("file.csv",
         delim=",", quote = "\"", comment = "#",
         col_names = c("add", "names", "or", "T/F"), 
         na = ".", skip = 0,
         progress = show_progress())

######################################################################
## Parsing Data ######################################################
######################################################################

parse_logical()

parse_integer()

parse_double()

parse_number()

parse_character()

parse_factor()

parse_datetime()

parse_date()

parse_time()


# parsing examples
parse_logical(c("TRUE", "FALSE", "NA"))
parse_integer(c("1", "2", "3"))
parse_date(c("2010-01-01", "1979-10-14"))

parse_double("1.23")
parse_double("1,23", locale = locale(decimal_mark = ","))

parse_number("$100")
parse_number("20%")
parse_number("It cost $123.45")

parse_number("$123,456,789")
parse_number("123.456.789", locale = locale(grouping_mark = "."))
parse_number("123'456'789", locale = locale(grouping_mark = "'"))

parse_datetime("2010-10-01T2010")
parse_datetime("20101010")

parse_date("01/02/15", "%m/%d/%y")
parse_date("01/02/15", "%d/%m/%y")
parse_date("01/02/15", "%y/%m/%d")

######################################################################
## Writing Data ######################################################
######################################################################

write_csv(dataframe, "file.csv")

write_excel_csv(dataframe, "excel.xls")

ggsave("graph.pdf")
















