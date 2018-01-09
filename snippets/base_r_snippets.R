# R Snippets 

# Base Data Types 
numeric <- 1
character <- "one"
logical <- TRUE

# Checking Class 
class(numeric)
class(character)
class(logical)

# Vectors 
vector_alpha <- c(1,2,3)
names(vector_alpha) <- c("one", "two", "three")
sum_vector <- sum(vector_alpha)
sum_vector > 0 

alpha_middle <- vector_alpha[2]
alpha_middle

# Matrices
matrix(1:9, byrow=TRUE, nrow=3)
vector_beta <- c(4,5,6)
vector_charle <- c(7,8,9)
vector_delta <- c(vector_beta, vector_charle)
matrix_echo <- matrix(vector_delta, byrow=TRUE, nrow=2)
matrix_echo

columns <- c("col 1", "col 2", "col 3")
rows <- c("row 1", "row 2")

colnames(matrix_echo) <- columns
rownames(matrix_echo) <- rows

matrix_echo

rowSums(matrix_echo) 
colSums(matrix_echo)

# column / row bind
cbind()
rbind()


# Factors levels and summaries 
# Create speed_vector
speed_vector <- c("fast", "slow", "slow", "fast", "insane")

# Convert speed_vector to ordered factor vector
factor_speed_vector <- factor(speed_vector, ordered=TRUE, levels=c("slow", "fast", "insane"))

# Print factor_speed_vector
factor_speed_vector
summary


# data types
head(mtcars)
tail(mtcars)
str(mtcars) #structure


# Definition of vectors
name <- c("Mercury", "Venus", "Earth", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune")
type <- c("Terrestrial planet", "Terrestrial planet", "Terrestrial planet", 
          "Terrestrial planet", "Gas giant", "Gas giant", "Gas giant", "Gas giant")
diameter <- c(0.382, 0.949, 1, 0.532, 11.209, 9.449, 4.007, 3.883)
rotation <- c(58.64, -243.02, 1, 1.03, 0.41, 0.43, -0.72, 0.67)
rings <- c(FALSE, FALSE, FALSE, FALSE, TRUE, TRUE, TRUE, TRUE)

# Create a data frame from the vectors
planets_df <- data.frame(name, type, diameter, rotation, rings)

subset(planets_df, subset = diameter < 1)

# data frame best frame




# Vector with numerics from 1 up to 10
my_vector <- 1:10 

# Matrix with numerics from 1 up to 9
my_matrix <- matrix(1:9, ncol = 3)

# First 10 elements of the built-in data frame mtcars
my_df <- mtcars[1:10,]

# Construct list with these different elements:
my_list <- list(my_vector, my_matrix, my_df)
