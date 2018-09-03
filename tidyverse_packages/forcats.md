<br>

### Introduction

This is the seventh of eight installments in my *Unpacking the
Tidyverse* series. Each installment focuses on one of the eight core
packages in Hadley Wickham's tidyverse. Instructions given in each post
are mainly derived from Hadley's textbook, [R for Data
Science](http://r4ds.had.co.nz/), and CRAN package documentation. This
installment of *Unpacking the Tidyverse* focuses on the categorical data
manipulation package, forcats. The previous installment focuses on the
stringr package, and can be found
[here](%7B%7B%20site.baseurl%20%7D%7D/r4ds/stringr). The next
installment focuses on the purrr package, and can be found
[here](%7B%7B%20site.baseurl%20%7D%7D/r4ds/purr).

Categorical data can be tricky to understand and work with. Often,
categorical data has factors, or levels; Factors are a way to organize
categorical variables logically. For example, if you attempt to sort a
list of months, they'll be sorted alphabetically (April, August,
December, ...). But wouldn't it make more sense if they were sorted
chronologically? Forcats aims to help you solve problems like this
quickly and efficiently.

<br>

### Load Library

Forcats is included in the 8 core tidyverse packages, so we can simply
load the tidyverse library.

    library('tidyverse')

<br>

### Load Data

Let's get some categorical data to work with. After a quick search, I've
found a satesfactory dataset from the University of California, Irvine's
department of Information and Computer Science website. The dataset
we'll be working with in this post can be found
[here](https://archive.ics.uci.edu/ml/datasets/Adult).

    # load data as dataframe from the url in its .csv form, insure data isn't used as column names
    income_predict_data <- as_data_frame(read_csv(url("https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data"), col_names = F))

    # name columns as described in the dataset's information page
    colnames(income_predict_data) <- c("age", "workclass", "fnlwgt", "education", "education_num", "marital_status", "occupation", "relationship", "race", "sex", "capital_gains", "capital_loss", "hours_per_week", "native_country", "income_prediction")

    # save the dataset just incase you go offline, or the source is removed
    write_csv(income_predict_data, "r4ds_tidyverse/tidyverse_packages/forcats_data.csv")

    ## Parsed with column specification:
    ## cols(
    ##   age = col_integer(),
    ##   workclass = col_character(),
    ##   fnlwgt = col_integer(),
    ##   education = col_character(),
    ##   education_num = col_integer(),
    ##   marital_status = col_character(),
    ##   occupation = col_character(),
    ##   relationship = col_character(),
    ##   race = col_character(),
    ##   sex = col_character(),
    ##   capital_gains = col_integer(),
    ##   capital_loss = col_integer(),
    ##   hours_per_week = col_integer(),
    ##   native_country = col_character(),
    ##   income_prediction = col_character()
    ## )

<br>

    # view dataset
    income_predict_data

    ## # A tibble: 32,561 x 15
    ##      age workc… fnlwgt educa… educa… marita… occu… rela… race  sex   capi…
    ##    <int> <chr>   <int> <chr>   <int> <chr>   <chr> <chr> <chr> <chr> <int>
    ##  1    39 State…  77516 Bache…     13 Never-… Adm-… Not-… White Male   2174
    ##  2    50 Self-…  83311 Bache…     13 Marrie… Exec… Husb… White Male      0
    ##  3    38 Priva… 215646 HS-gr…      9 Divorc… Hand… Not-… White Male      0
    ##  4    53 Priva… 234721 11th        7 Marrie… Hand… Husb… Black Male      0
    ##  5    28 Priva… 338409 Bache…     13 Marrie… Prof… Wife  Black Fema…     0
    ##  6    37 Priva… 284582 Maste…     14 Marrie… Exec… Wife  White Fema…     0
    ##  7    49 Priva… 160187 9th         5 Marrie… Othe… Not-… Black Fema…     0
    ##  8    52 Self-… 209642 HS-gr…      9 Marrie… Exec… Husb… White Male      0
    ##  9    31 Priva…  45781 Maste…     14 Never-… Prof… Not-… White Fema… 14084
    ## 10    42 Priva… 159449 Bache…     13 Marrie… Exec… Husb… White Male   5178
    ## # ... with 32,551 more rows, and 4 more variables: capital_loss <int>,
    ## #   hours_per_week <int>, native_country <chr>, income_prediction <chr>

<br>

The dataset is a collection of over 32,000 observations and 15
variables. It contains census data from the 1990's and is apart of a
study that attempts to guess an individual's income (&gt;$50,000 or
&lt;$50,000) based on the census data. We're only going to use a few
variables (education, race, hours worked per week) to demonstrate the
capabilities of various forcat functions.

<br>

### Forcats

Now that we've loaded forcats and the dataset, let's have a closer look
at the dataset. It's hard to get a grip on variables and their possible
values just by calling the entire dataset, so let's do a count of a
specific variable. The function `count()` is from the dplyr package,
which is automatically loaded as a part of the tidyverse. My post on
dplyr can be found [here](%7B%7Bsite.baseurl%7D%7D/r4ds/dplyr).

    # call the dataset 'then'
    income_predict_data %>%
    # count number of occurrences of each element in the race variable
      count(race)

    ## # A tibble: 5 x 2
    ##   race                   n
    ##   <chr>              <int>
    ## 1 Amer-Indian-Eskimo   311
    ## 2 Asian-Pac-Islander  1039
    ## 3 Black               3124
    ## 4 Other                271
    ## 5 White              27816

<br>

The dataset shows 5 categories of possible values for the race variable.
Let's visualize a different variable's categories using ggplot2, which
is another core tidyverse package. (tutorial
[here](%7B%7Bsite.baseurl%7D%7D/r4ds/ggplot2))

    # call the dataset
    income_predict_data %>%
    # plot the dataset's variable 'education'
      ggplot(aes(education)) + 
    # use a bar chart
      geom_bar() +
    # adjust the theme and labels
      theme_minimal() + 
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
      xlab("Highest Level of Education") + 
      ylab("Number of Entries") + 
      ggtitle("Education Variable Breakdown")

![](forcats_files/figure-markdown_strict/unnamed-chunk-6-1.png)

<br>

There are 16 different categories in this dataset's education variable.
Because the categories in this variable can be ordered logically, it's a
great candidate to test out our forcat functions on.

First, I'll show you how to turn this character variable into a factor
variable using base R. It's important to some forcat functions that your
variable is a factor and not a list of strings.

    # view possible categories for education
    unique(income_predict_data$education)

    ##  [1] "Bachelors"    "HS-grad"      "11th"         "Masters"     
    ##  [5] "9th"          "Some-college" "Assoc-acdm"   "Assoc-voc"   
    ##  [9] "7th-8th"      "Doctorate"    "Prof-school"  "5th-6th"     
    ## [13] "10th"         "1st-4th"      "Preschool"    "12th"

    # order categories logically by hand
    education_levels <- c("Preschool", "1st-4th", "5th-6th", "7th-8th", "9th", "10th", "11th", "12th", "HS-grad", "Some-college", "Assoc-acdm", "Assoc-voc", "Bachelors", "Masters", "Prof-school", "Doctorate")

    # use base R factor function with defined levels to overwrite education variable
    income_predict_data$education <- factor(income_predict_data$education, levels=education_levels)

    # plot new education variable with ordered factors
    income_predict_data %>%
      ggplot(aes(education)) + 
      geom_bar() + 
      theme_minimal() + 
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
      xlab("Highest Level of Education") + 
      ylab("Number of Entries") + 
      ggtitle("Ordered Education Variable Breakdown")

![](forcats_files/figure-markdown_strict/unnamed-chunk-7-1.png)

<br>

That makes more sense.

Now let's put the factors to use by visualizing the the average hours
worked per week, as broken down by our factor variable, education.

    # copy original dataset into new dataset, 'then'
    education_hours_summary <- income_predict_data %>%
    # group new dataset by education factored variable, 'then'
      group_by(education) %>%
    # use dplyr's summarize function to...
      summarize(
    # calculate the average hours worked (grouped by education factor)
        avg_hours_worked = mean(hours_per_week, na.rm = TRUE)
      )

    # plot average hours worked per week as grouped by education
    ggplot(education_hours_summary) + 
      geom_point(aes(avg_hours_worked, education)) + 
      theme_minimal() + 
      xlab("Average Hours Worked Per Week") + 
      ylab("Highest Level of Education") + 
      ggtitle("Average Hours Worked per Week by Ordered Education")

![](forcats_files/figure-markdown_strict/unnamed-chunk-8-1.png)

<br>

Interesting plot, but let's start using forcats functions to manipulate
the data. Say I want to re-order the education factor according to the
newly calculated average hours worked per week. I'll use the forcat
function `fct_reorder` to accomplish this.

    # take the previously created education_hours_summary dataset, 'then'
    education_hours_summary %>%
    # reorder the factor, education, by avg_hours_worked, 'then'
      mutate(education = fct_reorder(education, avg_hours_worked)) %>%
    # plot the newly ordered factor and avg_hours_worked
      ggplot(aes(avg_hours_worked, education)) + 
      geom_point() + 
      theme_minimal() + 
      xlab("Average Hours Worked Per Week") + 
      ylab("Highest Level of Education") + 
      ggtitle("Ordered Average Hours Worked per Week by Education")

![](forcats_files/figure-markdown_strict/unnamed-chunk-9-1.png)

Well that was easy. Now we can clearly see that those who have only
completed schooling until the 11th grade work the least number of hours
each week, and professional school graduates work the most hours per
week, on average.

<br>

Let's use another forcats function `fct_infreq` to reorder the education
factors according to their frequency of occurrence in the dataset. We'll
also throw in the forcats function `fct_rev` to reverse the levels so
they're in ascending order of occurrence.

    # take the original dataset, 'then'
    income_predict_data %>%
    # change the education variable so that it's ordered by reverse frequency, 'then'
      mutate(education = education %>% fct_infreq() %>% fct_rev()) %>%
    # plot the new education variable
      ggplot(aes(education)) + 
      geom_bar() + 
      theme_minimal() + 
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
      xlab("Highest Level of Education") + 
      ylab("Number of Entries") + 
      ggtitle("Ordered Education Variable Breakdown")

![](forcats_files/figure-markdown_strict/unnamed-chunk-10-1.png)

<br>

The most common level of completed education is clearly the high school
graduate, and the least common level of completed education is the those
who've never attended grade school.

<br>

But what if I dislike the names of my factors? Do I have to go in and
change them by hand? No. Forcats has a function for that: `fct_recode`.

    # take the initial dataset, 'then'
    income_predict_data %>%
    # change the education variable, by recoding the education variable
      mutate(education = fct_recode(education, 
    # the new category "Associates" is made up of what used to be "Assoc-acdm"
             "Associates" = "Assoc-acdm",
    # the new category "Vocational" is made up of what used to be "Assoc-voc"
             "Vocational" = "Assoc-voc",
    # the new category "Professional" is made up of what used to be "Prof-school"
             "Professional" = "Prof-school"
    # complete this function, 'then'
             )) %>%
    # count the newly altered variable
      count(education)

    ## # A tibble: 16 x 2
    ##    education        n
    ##    <fctr>       <int>
    ##  1 Preschool       51
    ##  2 1st-4th        168
    ##  3 5th-6th        333
    ##  4 7th-8th        646
    ##  5 9th            514
    ##  6 10th           933
    ##  7 11th          1175
    ##  8 12th           433
    ##  9 HS-grad      10501
    ## 10 Some-college  7291
    ## 11 Associates    1067
    ## 12 Vocational    1382
    ## 13 Bachelors     5355
    ## 14 Masters       1723
    ## 15 Professional   576
    ## 16 Doctorate      413

<br>

What if these categories are too descriptive, and I want to lump some of
them together? The function `fct_lump` (forcats) has you covered.

    # lump the smallest groups together to other, num big groups = 5

    # take the original dataset, 'then'
    income_predict_data %>%
    # change the education variable by lumping the education variable into 5 largest categories + 'other', 'then'
      mutate(education = fct_lump(education, n = 5)) %>%
    # count the new variable
      count(education)

    ## # A tibble: 6 x 2
    ##   education        n
    ##   <fctr>       <int>
    ## 1 HS-grad      10501
    ## 2 Some-college  7291
    ## 3 Assoc-voc     1382
    ## 4 Bachelors     5355
    ## 5 Masters       1723
    ## 6 Other         6309

<br>

"But lumping the factor doesn't give me enough control!" - You.

"How about `fct_collapse` then?" - Me.

    # take the initial dataset, 'then'
    income_predict_data %>%
    # change the education variable using factor collapse on the education variable
      mutate(education = fct_collapse(education,
    # create a new factor, advanced_degree, made up of five old factors collapsed together
            advanced_degree = c("Assoc-acdm","Bachelors", "Masters",
                                "Doctorate", "Prof-school")
    # 'then'
      )) %>%
    # plot the new education variable 
      ggplot(aes(education)) + 
      geom_bar() + 
      theme_minimal() + 
      theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
      xlab("Highest Level of Education") + 
      ylab("Number of Entries") + 
      ggtitle("Lumped Education Variable Breakdown")

![](forcats_files/figure-markdown_strict/unnamed-chunk-13-1.png)

<br>

Now you might be saying, "But Fisher, that was too easy! I want a
harder, more verbose way to lump factors together!" To that, I present
you again with `fct_recode`.

    # take the intitial dataset, 'then'
    income_predict_data %>%
    # change the education variable by recoding the factors of the education variable
      mutate(education = fct_recode(education,
    # make a new factor, "drop_out", populate it with the old "Preeschool" factor
          "drop_out" = "Preschool",
    # repeat ad nauseam
          "drop_out" = "1st-4th",
          "drop_out" = "5th-6th",
          "drop_out" = "7th-8th", 
          "drop_out" = "9th",
          "drop_out" = "10th", 
          "drop_out" = "11th",
          "drop_out" = "12th")
    # THEN
          ) %>%
    # plot the new education variable
      ggplot(aes(education)) + 
      geom_bar() + 
        theme_minimal() + 
        theme(axis.text.x = element_text(angle = 90, hjust = 1)) + 
        xlab("Highest Level of Education") + 
        ylab("Number of Entries") + 
        ggtitle("Lumped Education Variable Breakdown")

![](forcats_files/figure-markdown_strict/unnamed-chunk-14-1.png)

<br>

And that does it for the fun and friendly forcats package. See,
categorical data analysis can be fun! Next time I'll be finishing up my
Unpacking the Tidyverse series with the purrr package. It should be a
good one!

Here's some additional resources on Forcats: <br> - [Forcats Github
Repo](https://github.com/tidyverse/forcats) <br> - [Forcats
Documentation](https://cran.r-project.org/web/packages/forcats/forcats.pdf)
<br> - [Factor Chapter of R4DS](http://r4ds.had.co.nz/factors.html) <br>
- [Random Forcats Tutorial](http://stat545.com/block029_factors.html)
<br>

Until next time, <br> - Fisher
