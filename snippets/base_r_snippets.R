############################
##        How to R        ##
##    guide & snippets    ##
############################

# Fisher Ankney
# January 2018

install.packages('package_name')   # install packages
library('package_name')            # add package to working library
setwd()                            # set working directory  
getwd()                            # get working directory
dev.off()                          # clear old plot
class()                            # check data type
str()                              # display data structure
head()                             # display the first 10 lines
tail()                             # display the last 10 lines
View()                             # display the data


# data types 
numeric <- 1 
character <- "one"
logical <- TRUE 

# creating and accessing vectors
vector <- c(1,2,3)
vector[1]

# creating and accessing matrices
matrix_a <- matrix(1:9, byrow = TRUE, nrow = 3)
matrix_a[2,3]

# creating and accessing dataframes
#coming soon

# naming data
names(vector) <- c("one", "two", "three")
colnames(matrix_a) <- c("col_1", "col_2", "col_3")
rownames(matrix_a) <- c("row_1", "row_2", "row_3")

# binding
cbind()   # concat by column
rbind()   # concat by row

# ordered factors
speed_vector <- c("fast", "slow", "slow", "fast", "insane")
factor_speed_vector <- factor(speed_vector,
                              ordered=TRUE,
                              levels=c("slow", "fast", "insane")
                              )
factor_speed_vector



