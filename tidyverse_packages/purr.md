<br>

This is the final installments in my *Unpacking the Tidyverse* series.
It has been a pretty fun, and extremely rewarding journey,
systematically work through the tidyverse. I've pored over the R4DS
book, vignettes, GitHub repositories, blog posts, CRAN Documentation,
and RStudio cheat sheets in order to better understand these eight very
important packages.

This final installment of *Unpacking the Tidyverse* focuses on
iteration. I cover why we need iteration, what for loops are, and how
the purrr package can help us simplify these tasks. The previous
installment of *Unpacking the Tidyverse* focuses on the categorical data
manipulation package,
[forcats](%7B%7B%20site.baseurl%20%7D%7D/r4ds-forcats).

To use purrr, we must first download the tidyverse.

<br>

### Library

    library('tidyverse')

<br>

### Iteration by Hand

Iteration allows you to conduct the same operation on multiple inputs
without tediously copying-and-pasting code. To illustrate the need for
iteration, I'll set up a repetitive task and complete it by hand. Once
we have a baseline of tediousness, I'll complete the same task using a
for loop. After that, we'll move to the purrr package's `map` functions
for maximum-awesome.

To illustrate the need for iteration, let's compute a simple summary
statistic on a dataset. First we'll create a dataframe with 4 variables:
a, b, c, and d. Each of these variables will contain 10 randomly
generated numbers from the normal distribution using the function
`rnorm`.

    df <- tibble(
    a = rnorm(10),
    b = rnorm(10), 
    c = rnorm(10),
    d = rnorm(10)
    )

    df

    ## # A tibble: 10 x 4
    ##          a      b      c      d
    ##      <dbl>  <dbl>  <dbl>  <dbl>
    ##  1 -1.70    1.70   0.128 -0.914
    ##  2  1.38    1.45  -1.21   1.24 
    ##  3 -1.15   -0.193 -0.413 -2.30 
    ##  4  2.47    1.15   0.994  0.131
    ##  5 -0.937   0.437 -0.780 -1.39 
    ##  6 -0.293   0.174  1.39  -0.492
    ##  7  0.232  -0.194  0.464  0.625
    ##  8 -0.0948 -0.844  1.37  -1.32 
    ##  9 -0.828  -0.206 -0.312 -1.97 
    ## 10  4.09   -0.745 -0.919 -0.360

<br>

As you can see the numbers range from around negative 3 to positive 3,
but are mostly populating -1 to 1. This is typical of the normal
distribution, to see this distribution in action, check out my previous
blog post [A Roll of the
Dice](%7B%7B%20site.baseurl%20%7D%7D/a-roll-of-the-dice).

Now to compute the mean of each of the variables a-d:

    mean(df)

    ## Warning in mean.default(df): argument is not numeric or logical: returning
    ## NA

    ## [1] NA

<br>

Well that doesn't work...

I guess we'll have to specify each variable.

<br>

    mean(df$a)

    ## [1] 0.3159849

    mean(df$b)

    ## [1] 0.2733573

    mean(df$c)

    ## [1] 0.07141916

    mean(df$d)

    ## [1] -0.6751293

<br>

That's better. But imagine if we have 100 variables that we want to
calculate the mean of... That would be awful! Good thing we have for
loops to rescue us from all of this *work*.

<br>

### For Loops

Let's make a for loop, and use it to calculate the mean of each of these
variables.

    # Step 1 
    output_vector <- vector("double", ncol(df))

    # Step 2 
    for (i in seq_along((df))) {

    # Step 3 
      output_vector[[i]] <- mean(df[[i]])

    # close for loop
    }

    # display results
    output_vector

    ## [1]  0.31598487  0.27335728  0.07141916 -0.67512933

<br>

We've successfully created a for loop to iterate through the variables!
It may seem like more work at first, and maybe it is for such a simple
task as calculating the mean of 4 variables. But for loops are an
integral programming technique and can be extremely useful. Even if
you're a master at purrr.

Each for loop is broken down into three steps.

The first step, you must create an output vector to store your results.
It's easy to create an empty vector of the correct size using the
`vector()` function. In the first argument of `vector()` you specify
what kind of vector to create. This could be specified as any of the
data structures i.e. integer, logical, character, etc. The second
argument of `vector()` is the length of the vector. Clever use of
`ncol()`, `nrow()`, or `length()` will give you the proper length for
your output vector.

The second step of a for loop is to define the sequence. Here we
determine what to loop over using base R's `seq_along()` function.
Create the variable `i` as a counter variable.

The third and most complicated step of creating a for loop is in the
body of the sequence. Here we describe to R exactly what we want to do
as we loop through our defined dataframe. Sometimes we simply want to
take the mean of each variable, and store that number into our output
vector. Other times we may want to insert a series of if then
statements, of generate graphics of the data we're looping over. The
possibilities are endless.

Great, so we've covered a iteration and a simple for loop. Now let's get
to the good stuff. The reason you came here. The purrr package!

<br>

### Purrr Map Function

In our quest to find the mean of each of the four variables in `df`, we
can use the most basic purrr function `map()`.

    df %>% 
      map(mean)

    ## $a
    ## [1] 0.3159849
    ## 
    ## $b
    ## [1] 0.2733573
    ## 
    ## $c
    ## [1] 0.07141916
    ## 
    ## $d
    ## [1] -0.6751293

<br>

The function `map` takes two main arguments, a target to iterate over,
and a function to apply during that iteration. `map` Returns a list of
values, but if you don't want a generic list you can the variants of the
`map` function.

-   `map_lgl()` returns a logical vector.
-   `map_int()` returns an integer vector.
-   `map_dbl()` returns a double vector.
-   `map_chr()` returns a character vector.

<br>

Here's what `map_dbl()` looks like when applied to our favorite
iteration-situation.

    df %>%
      map_dbl(mean)

    ##           a           b           c           d 
    ##  0.31598487  0.27335728  0.07141916 -0.67512933

<br>

That's smooooth.

So let's make it more complex! How about we create our own function and
test out the `map_chr` function. I want to run through a dataframe of
arbitrary size, and return the words "positive", "negative", or "zero",
if the elements are as such. I want this to function to be done to every

First things first, let's make the custom function!

    # name the function 'classify_chr' with input = 'input'
    classify_chr <- function(input) {

    # set a counter equal to 1 
    i <- 1

    # create a save vector of input length
    save_vect <- vector("character", length(input))

    # main while loop, while counter is less than or equal
    # to input length, classify the elements and put that
    # character classification into the save vector. 
    # Then, add one to the counter to move on to the next 
    # element. 
    while (i <= length(input))
      {
        if (input[[i]] > 0) {
          save_vect[[i]] = "positive"
        }
        if (input[[i]] < 0) {
          save_vect[[i]] = "negative"
        }
        if (input[[i]] == 0) {
          save_vect[[i]] = "zero"
        }
      i <- i + 1
      }

    # When the save vector is full of output, collapse the
    # results and separate them by a space. Finally, print
    # the resulting output vector.
    output <- str_c(save_vect, collapse=" ")
    print(output)
    }

<br>

Alright. That function was relatively easy to create! Let's test it out.

<br>

    # test classify_chr function
    classify_chr(-1)

    ## [1] "negative"

    classify_chr(0)

    ## [1] "zero"

    classify_chr(1)

    ## [1] "positive"

<br>

Single entries are working as expected. Let's give the custom function a
concatenated list of numbers and see what it does.

<br>

    # test classify_chr on a numeric vector
    a <- c(-1,0,1)

    classify_chr(a)

    ## [1] "negative zero positive"

<br>

Looking good, how about we step it up to the final level of complexity!
Running through a tibble that has lists of numbers as it's variables.

<br>

    # test classify_chr on a tibble
    test_tib <- tibble(
      a = sample(-10:10,10, replace = T),
      b = sample(1:10,10, replace = T),
      c = 0
    )

    test_tib

    ## # A tibble: 10 x 3
    ##        a     b     c
    ##    <int> <int> <dbl>
    ##  1    -3     2     0
    ##  2     0    10     0
    ##  3     2     2     0
    ##  4    -9     8     0
    ##  5    -8     7     0
    ##  6     5     9     0
    ##  7    -7     8     0
    ##  8    -2     5     0
    ##  9     4     6     0
    ## 10     4     8     0

    classify(test_tib)

    ## Error in classify(test_tib): could not find function "classify"

<br>

An Error! Oh no! Wait, that's exactly why we went through all of this.
That’s where purrr comes in! Let's give it a shot.

<br>

    # use map_chr to apply custom function to a tibble
    test_tib %>%
      map_chr(classify_chr)

    ## [1] "negative zero positive negative negative positive negative negative positive positive"
    ## [1] "positive positive positive positive positive positive positive positive positive positive"
    ## [1] "zero zero zero zero zero zero zero zero zero zero"

    ##                                                                                           a 
    ##     "negative zero positive negative negative positive negative negative positive positive" 
    ##                                                                                           b 
    ## "positive positive positive positive positive positive positive positive positive positive" 
    ##                                                                                           c 
    ##                                         "zero zero zero zero zero zero zero zero zero zero"

<br>

Alright! Not the prettiest of outputs, but it does what it's designed to
do. And it's a great illustration of when we need to use the map
function.

<br>

### Purrr map2 & pmap Function

When we want to map over two arguments in our function, we can use the
map2 function. Say you want to generate a random number from the normal
distribution with a specific mean and standard deviation.

Using the `rnorm` function, you could do something like this.

    rnorm(10, 5, n = 1)

    ## [1] 5.6115

<br>

There we've taken number from the normal curve with mean (mu) 10, and
standard deviation (sigma) 5. now say we want to do this 5 times each
with 10 different inputs. Instead of writing 50 `rnorm` statements,
`Map2` can help us out.

<br>

    # create a variety of mean inputs 
    mu <- rep(20:24, 2)

    # create a variety of standard devation inputs
    sigma <- sample(1:5, size = 10, replace = T)

    # check the inputs
    mu

    ##  [1] 20 21 22 23 24 20 21 22 23 24

    sigma

    ##  [1] 3 1 4 5 5 5 3 3 1 1

    # apply mu and sigma inputs to the rnorm function,
    # produce 5 outputs for each pair of input arguments
    map2(mu, sigma, rnorm, n=5)

    ## [[1]]
    ## [1] 21.53999 17.56498 20.51461 21.33053 23.10560
    ## 
    ## [[2]]
    ## [1] 22.27693 22.37035 21.94622 19.99413 21.58025
    ## 
    ## [[3]]
    ## [1] 25.32388 16.29446 26.22162 25.57290 25.30858
    ## 
    ## [[4]]
    ## [1] 28.06854 24.89601 20.26738 12.82952 15.36899
    ## 
    ## [[5]]
    ## [1] 22.97124 19.20604 24.11797 30.39977 19.57324
    ## 
    ## [[6]]
    ## [1] 17.08383 17.58678 25.70097 17.99357 15.77185
    ## 
    ## [[7]]
    ## [1] 23.67349 18.59755 17.86730 20.66431 19.27813
    ## 
    ## [[8]]
    ## [1] 21.20146 23.47705 23.66124 20.79747 30.07640
    ## 
    ## [[9]]
    ## [1] 21.31325 24.24021 21.94589 24.05448 22.96714
    ## 
    ## [[10]]
    ## [1] 24.31588 23.48889 24.17011 24.02622 22.85655

<br>

It's easy to see how you could want 3 arguments, or 4 or 5. For the
generalized case, of **p** inputs, we use the `pmap` function in much
the same way we would use map2.

As a final example, we want to again use the `rnorm` function to choose
a number from the normal distribution with a set mean and standard
deviation. this time, we also want to vary the number of outputs the
function returns by changing the `n =` argument in `rnorm`. 3 varied
arguements is the job for `pmap`.

    outs <- c(10,15,20)
    mu <- c(5,6,7)
    sigma <- c(1,2,3)


    arguments <- list(outs, mu, sigma)

    arguments %>%
      pmap(rnorm)

    ## [[1]]
    ##  [1] 4.540726 4.869262 6.246657 5.978836 5.069496 6.259922 2.198821
    ##  [8] 7.259019 6.214939 5.459615
    ## 
    ## [[2]]
    ##  [1] 6.479564 4.180825 6.279556 7.857192 8.099295 6.147618 5.221495
    ##  [8] 3.063784 8.878741 3.143356 6.202642 7.877734 5.981061 6.332001
    ## [15] 6.034218
    ## 
    ## [[3]]
    ##  [1]  6.139977  6.192168  5.741708  9.824213  6.234980 10.994446  7.211726
    ##  [8] 12.693423  8.885927  9.237533 10.624023  9.593312  2.601244  7.284100
    ## [15]  7.251205  9.907291  8.281177  5.798103  1.877389  6.749708

<br>

### Conclusions

And that does it! That's my run down of the most important purrr
concepts and functions. That also completes my eight-part series on the
core tidyverse packages.

I highly suggest you read the book [r4ds](http://r4ds.had.co.nz/)
written by Hadley Wickham and Garrett Grolemund. It'll change your life!
Maybe.

Anyways, as always,

<br>

Until next time, <br> - Fisher
