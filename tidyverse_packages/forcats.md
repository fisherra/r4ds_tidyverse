load forcats

    library('tidyverse')

    ## ── Attaching packages ─────────────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 2.2.1     ✔ purrr   0.2.4
    ## ✔ tibble  1.4.1     ✔ dplyr   0.7.4
    ## ✔ tidyr   0.7.2     ✔ stringr 1.2.0
    ## ✔ readr   1.1.1     ✔ forcats 0.2.0

    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

Now using their data -

    adult_data <- as_data_frame(read_csv(url("https://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data"), col_names = F))

    ## Parsed with column specification:
    ## cols(
    ##   X1 = col_integer(),
    ##   X2 = col_character(),
    ##   X3 = col_integer(),
    ##   X4 = col_character(),
    ##   X5 = col_integer(),
    ##   X6 = col_character(),
    ##   X7 = col_character(),
    ##   X8 = col_character(),
    ##   X9 = col_character(),
    ##   X10 = col_character(),
    ##   X11 = col_integer(),
    ##   X12 = col_integer(),
    ##   X13 = col_integer(),
    ##   X14 = col_character(),
    ##   X15 = col_character()
    ## )

    colnames(adult_data) <- c("age", "workclass", "fnlwgt", "education", "education_num", "marital_status", "occupation", "relationship", "race", "sex", "capital_gains", "capital_loss", "hours_per_week", "native_country", "unk")

    adult_data

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
    ## #   hours_per_week <int>, native_country <chr>, unk <chr>

relationship: Wife, Own-child, Husband, Not-in-family, Other-relative,
Unmarried. race: White, Asian-Pac-Islander, Amer-Indian-Eskimo, Other,
Black. sex: Female, Male. capital-gain: continuous. capital-loss:
continuous. hours-per-week: continuous. native-country:

now following the tutorial in R4DS -

    gss_cat %>% 
    count(race)

    ## # A tibble: 3 x 2
    ##   race       n
    ##   <fctr> <int>
    ## 1 Other   1959
    ## 2 Black   3129
    ## 3 White  16395

    ggplot(gss_cat, aes(race)) + 
      geom_bar()

![](forcats_files/figure-markdown_strict/unnamed-chunk-4-1.png)

Modify Factor order

    relig_summary <- gss_cat %>%
      group_by(relig) %>%
      summarise(
        age = mean(age, na.rm = TRUE),
        tvhours = mean(tvhours, na.rm = TRUE),
        n = n()
      )

    ggplot(relig_summary, aes(tvhours, relig)) + geom_point()

![](forcats_files/figure-markdown_strict/unnamed-chunk-5-1.png)

    ggplot(relig_summary, aes(tvhours, fct_reorder(relig, tvhours))) +
      geom_point()

![](forcats_files/figure-markdown_strict/unnamed-chunk-6-1.png)

if youre getting complicated, used mutate()

    relig_summary %>%
      mutate(relig = fct_reorder(relig, tvhours)) %>%
      ggplot(aes(tvhours, relig)) +
        geom_point()

![](forcats_files/figure-markdown_strict/unnamed-chunk-7-1.png)

    rincome_summary <- gss_cat %>%
      group_by(rincome) %>%
      summarise(
        age = mean(age, na.rm = TRUE),
        tvhours = mean(tvhours, na.rm = TRUE),
        n = n()
      )

    ggplot(rincome_summary, aes(age, fct_reorder(rincome, age))) + geom_point()

![](forcats_files/figure-markdown_strict/unnamed-chunk-8-1.png)

    ggplot(rincome_summary, aes(age, fct_relevel(rincome, "Not applicable"))) +
      geom_point()

![](forcats_files/figure-markdown_strict/unnamed-chunk-9-1.png)

    by_age <- gss_cat %>%
      filter(!is.na(age)) %>%
      count(age, marital) %>%
      group_by(age) %>%
      mutate(prop = n / sum(n))

    ggplot(by_age, aes(age, prop, colour = marital)) +
      geom_line(na.rm = TRUE)

![](forcats_files/figure-markdown_strict/unnamed-chunk-10-1.png)

    ggplot(by_age, aes(age, prop, colour = fct_reorder2(marital, age, prop))) +
      geom_line() +
      labs(colour = "marital")

![](forcats_files/figure-markdown_strict/unnamed-chunk-10-2.png)

    gss_cat %>%
      mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>%
      ggplot(aes(marital)) +
        geom_bar()

![](forcats_files/figure-markdown_strict/unnamed-chunk-11-1.png)
