
# This script is to illustrate data wrangling in the tidyverse. Much of this
# is adapted from R for Data Science, by Hadley Wickham.

library(tidyverse)

# The tidyverse works with special data frames called "tibbles".
# Let's look at a data frame built into R, then convert it to a tibble
# and look at it again.

iris

# We can convert with the as_tibble() function.

iris <- as_tibble(iris)

iris

# R tibbles don't convert the type of data. For example, it doesn't read
# strings as factors. The "Species" variable is a factor in this tibble
# because it was a factor in the data frame.

# You can create a tibble from scratch from individual vectors with the
# tibble() function. Note that tibbles will automatically make all vectors
# the same length by recycling.

my.tibble <- tibble(
  x = 1:5,
  y = 1,
  z = x^2 + y
)

my.tibble

# You can use backticks to create column names that would otherwise not be
# valid R names.

strange.tibble <- tibble(
  `:-)` = "happy",
  `   ` = "three spaces",
  `2values` = c(1, 2)
)

strange.tibble

# You can create a tibble with the tribble() function. This is short for
# "transposed tibble". You define column headings with a tilde. The purpose
# of tribble() is to make it easy to set up inline data entry in column form.

student.data <- tribble(
  ~first.name, ~last.name, ~score,
  "John",      "Ringer",     52,
  "Martha",    "Teadrow",    71,
  "Gary",      "Greeley",    68,
  "Marcia",    "Gonzalez",   64
)

student.data

# Hadley Wickham suggests a nice little tweak to separate the header from the
# data.

student.data <- tribble(
  ~first.name, ~last.name, ~score,
#-------------/-----------/-------  
  "John",      "Ringer",     52,
  "Martha",    "Teadrow",    71,
  "Gary",      "Greeley",    68,
  "Marcia",    "Gonzalez",   64
)

student.data

# Tibbles are designed to provide header information that can print easily
# in the console. You'll see 10 rows and only as many columns that fit.

# First let's look at a data frame in the usual fashion. This is a
# correlation matrix of 24 psychological tests given to 145 7th and 8th
# graders in a Chicago suburb.

Harman74.cor$cov

# Now let's make it a tibble and look at it.

har.tib <- as.tibble(Harman74.cor$cov)
har.tib

# We can ask for different numbers of rows and a different print width from
# the tibble.

print(har.tib, n = 15, width = 40)

# To extract from a tibble you can use name or position.

student.data$first.name
student.data[["first.name"]]
student.data[[1]]

# If you run into an old R function that doesn't work with the tibble,
# just use the as.data.frame() function.

as.data.frame(student.data)

# Most of the time we will import data, so let's look at that now.
# The read_ functions are used for importing different types of flat
# files into R. The most common of these is read_csv().

flights <- read_csv("NYC Flights 2013.csv")

flights

# For small amounts of data, it might be easier to read the data inline.
# We can also use the read_csv() function for these data. Note the absence
# of a comma at the end of each line of data.

student.data <- read_csv("first.name, last.name, score
                         John, Ringer, 52
                         Martha, Teadrow, 71
                         Gary, Greeley, 68
                         Marcia, Gonzalez, 64")

student.data

# Sometimes our csv files may include information at the top of the file,
# such as a title or name of the person who entered the data. We can skip
# lines when we read in data.

student.data <- read_csv("These data were entered by Mike Seaman
                         Date of entry: 1 April 2019
                         first.name, last.name, score
                         John, Ringer, 52
                         Martha, Teadrow, 71
                         Gary, Greeley, 68
                         Marcia, Gonzalez, 64", skip = 2)

student.data

# Another way to skip data is to identify a character that you use to
# indicate that the data should be skipped. This can be useful if you have
# sections of data, each with a title. Note that the character must be
# at the beginning of the line, without spaces in front of it.

student.data <- read_csv("* Data from Ms. Jones's class
                         first.name, last.name, score
                         John, Ringer, 52
*                        Data from Mr. Wilson's class
                         Martha, Teadrow, 71
                         Gary, Greeley, 68
                         Marcia, Gonzalez, 64", comment = "*")

student.data

# You can use \n to indicate a new line.

student.data <- read_csv("first.name, last.name, score
                         John, Ringer, 52\nMartha, Teadrow, 71
                         Gary, Greeley, 68\nMarcia, Gonzalez, 64")

student.data

# If you don't have column names in your data, you can indicate this to
# the read_csv() function.

student.data <- read_csv("John, Ringer, 52
                         Martha, Teadrow, 71
                         Gary, Greeley, 68
                         Marcia, Gonzalez, 64", col_names = FALSE)

student.data

# You can also provide column names.

student.data <- read_csv("John, Ringer, 52
                         Martha, Teadrow, 71
                         Gary, Greeley, 68
                         Marcia, Gonzalez, 64",
                         col_names = c("first.name", "last.name", "score"))

student.data

# You can tell read_csv() what is being used to indicate missing data in
# the file.

student.data <- read_csv("first.name, last.name, score
                         John, Ringer, 52
                         Martha, Teadrow, 71
                         Gary, Greeley, 68
                         Marcia, Gonzalez, 64
                         Laura, Hiller, -99", na = "-99")

student.data

# To be able to work with any type of data file, we need to understand
# something about the process of importing data. All data in flat files are
# characters, so reading a flat file into a tibble requires functions that
# analyze this text and separate it into parts of correct types. The process
# of separating text into parts is known as "parsing".

my.nums <- c("10", "23", "41")

# Note the type of vector. Now let's parse it into integers.

my.nums <- parse_integer(my.nums)

# Here are a couple more parsing examples.

my.logicals <- parse_logical(c("TRUE", "FALSE", "FALSE", "NA", "TRUE"))

my.dates <- parse_date(c("2019-04-02", "2019-04-09"))

# We can tell the parse function what is missing data.

my.nums <- parse_integer(c("10", "23", ".", "41"), na = ".")

# Parsing will fail if the type of parse doesn't align with the text.

my.nums <- parse_integer(c("10", "23", ".", "41", "Bob", "72.9"), na = ".")

# Note that when there are problems, instead of just creating a vector,
# the vector will be part of a tibble that also has a problems attribute.

my.nums

# You can capture this tibble with the problems() function. This is especially
# useful if you want to investigate many problems.

my.nums.problems <- problems(my.nums)
my.nums.problems

# You may need to analyze data from various parts of the world. In this case,
# parsing numbers is not straightforward. This looks good to us.

my.nums <- parse_double(c("3.14", "2.72"))

# What about this? This could have come from Europe.

my.nums <- parse_double(c("3,14", "2,72"))

# The parsing functions can handle this with an argument.

my.nums <- parse_double(c("3,14", "2,72"), locale = locale(decimal_mark = ","))

# The parse_number function will ignore non-numeric characters.

my.nums <- parse_number(c("$5.24", "30%", "1,249"))

# Here's a real tricky one. This is the same as above, except that the
# period is a grouping character from Europe, rather than a decimal point.

my.nums <- parse_number(c("$5.24", "30%", "1.249"))

# The result is wrong! We can fix it with the locale argument.

my.nums <- parse_number(c("$5.24", "30%", "1.249"),
                        locale = locale(grouping_mark = "."))

# Since everything is stored in a file as a sequence of characters, parsing
# characters is simple, right? Wrong! Look at how the computer interprets
# characters.

my.name <- charToRaw("Mike Seaman")

my.name

# These are hexadecimal codes. We can see the interpretation of a code by
# using \x.

"\x4d"

my.name <- "\x4d\x69\x6b\x65\x20\x53\x65\x61\x6d\x61\x6e"
my.name

# Everything is fine if the file uses the UTF-8 standard, but you may run into
# files where that's not the case. Here's an example using Latin1 encoding.

weather.statement <- "\x45\x6c\x20\x4e\x69\xf1\x6f\x20\x77\x61\x73\x20\x70\x61\x72\x74\x69\x63\x75\x6c\x61\x72\x6c\x79\x20\x62\x61\x64\x20\x74\x68\x69\x73\x20\x79\x65\x61\x72"

parse_character(weather.statement, locale = locale(encoding = "Latin1"))

# If you work with dates and times, the parse function for dates and times
# expects you to use the ISO8601 international standard. This lists dates
# and times from biggest to smallest: year, month, day, hour, minute, second.
# This is all based on the coordinated universal time. Our time zones are
# an offest from UTC (also known as Greenwich Mean Time, or GMT).

parse_datetime("2010-10-01T2010")

# This all is straightforward, but remember that the read_csv function is
# going to have to guess at how to parse a line of characters. We can see
# above examples of functions that it will use, but we won't be explicitly
# telling it to use those functions like we did above. When unknown
# characters are being read, the tidyverse uses a function called
# guess_parser().

guess_parser(c("TRUE", "FALSE"))

guess_parser(c("11", "14", "19"))

guess_parser("13:01")

# This function tries all the possiblities for every column for the first
# 1000 rows. If it can't find a match, then it keeps it as a vector of strings
# (i.e. characters). This can be a concern for larger files. For example
# what if the first 1000 rows for a column contain integers, but in general
# it is a column of doubles? Or what if a column is missing data for the
# first 1000 rows? In both cases, we will need to help the read_ function.

# There's a nice example built into the tidyverse.

challenge <- read_csv(readr_example("challenge.csv"))

# Let's look at the tibble created to show us the problems.

problems(challenge)

# Let's see if the first column should have been read as double. The col_
# functions do the same as the parse functions, but with a column of
# data that hasn't been read yet. The parse are for vectors that are already
# in R.

challenge <- read_csv(readr_example("challenge.csv"),
                      col_types = cols(x = col_double(),
                      y = col_character()))

# Let's look at the heads and tails.

challenge

tail(challenge)

# Those are clearly dates.

challenge <- read_csv(readr_example("challenge.csv"),
                      col_types = cols(x = col_double(),
                                       y = col_date()))

challenge

tail(challenge)

# We're all good now! Unless you are confident about the nature of your date,
# using col_ functions is a good idea. 

# We can write back to a csv file with with write_csv.

write_csv(challenge, "challenge.csv")

# If we have saved the read_csv with formatting, we can read right back in
# whenever we need.

challenge <- read_csv(readr_example("challenge.csv"),
                      col_types = cols(x = col_double(),
                                       y = col_date()))

# Other types of data can be read with other packages. See the Data Import
# cheat sheet for more information.

# Now let's look at tools for creating tidy data. First, let's practice
# using a pipe.

# Let's go back to a simple graph using the hsb2 data.

hsb2 <- read_csv("hsb2.csv")

# Here's the way we did it before.

ggplot(data = hsb2, aes(x = read, y = math)) +
  geom_point()

# Now we are going to do the same thing with a pipe. We are piping
# the data into ggplot.

hsb2 %>%
  ggplot(aes(x = read, y = math)) +
  geom_point()

# This doesn't seem all that useful at this point, but we start to see how
# it helps make our scripts easier to read when we are performing a sequence
# of functions.

hsb2 %>%
  group_by(ses) %>%
  summarize(math_mean = mean(math),
            math_sd = sd(math))

# Now let's begin to tidy data.

# Here are some repeated measures data in wide format.

sprint <- read_csv("Sprint Data (wide).csv")

sprint

# According to the rules of tidy data, we need to put this in the long format
# in order for it to be tidy. Note that "trials" is actually a variable.

# The gather() function will gather columns into new variables. We need
# to know the set of columns, the name of the variable that is currently
# in column headings, and the name of the values.

tidy.sprint <- sprint %>%
  gather(`Trial1`, `Trial2`, `Trial3`, `Trial4`, `Trial5`, `Trial6`,
         key = "Trial",
         value = "Time")

# This is now tidy. Traditional analysts state that this is repeated measures
# in long format.

tidy.sprint

# The spread() function does the opposite of gathering, so we can use this
# function to put a long format into a wide format.

sprint.wide <- tidy.sprint %>%
  spread(key = Trial, value = Time)

sprint.wide

# Now let's look at how to pull apart two variables that are in a single
# column.

student.data <- read_csv("Student Attempts.csv")

student.data

# The third column includes both score and number of attempts. We can use
# the separate() function to pull these apart.

new.data <- student.data %>%
  separate(score, into = c("score", "attempts"), sep = " of ")

new.data

# If the separator is a single non-alphanumeric character, we don't need
# to specify the "sep" argument. In this case, we needed it. Note that
# since the values in the original variable were characters, the separate
# function left them as characters. We can change them now. Alternatively,
# we can ask the separate function to make a guess at what they should
# be and change them.

new.data <- student.data %>%
  separate(score, into = c("score", "attempts"), sep = " of ", convert = TRUE)

new.data

# You can also use integers to indicate the number of characters to separate.
# Positive values are for the left side of the string and negative for the
# right side of the string. This isn't the best option here.

student.data %>%
  separate(score, into = c("score", "attempts"), sep = -2, convert = TRUE)

# The unite() function is the opposite of the separate() function.

new.data %>%
  unite(score.attempts, score, attempts)

# The underscore character is the default separator, but we can change it.

new.data %>%
  unite(score.attempts, score, attempts, sep = " of ")

# Missing data can be explicitly missing or implicitly missing. Here's an
# example from Hadley Wickham that illustrates the difference. Note that
# the return for the fourth quarter of 2015 is explicitly missing and the
# return for the first quarter of 2016 is implicitly missing.

stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)

# If we put years in columns, this will make the missing data explicit.

stocks %>% 
  spread(year, return)

# If we want to leave our data tidy but make missing values explicit, as
# we usually should, we can take advantage of the spread() and gather()
# functions.

stocks %>% 
  spread(year, return) %>% 
  gather(`2015`:`2016`, key = year, value = return)

# If we want to make every missing value implicit, we can do it like this.

stocks %>% 
  spread(year, return) %>% 
  gather(`2015`:`2016`, key = year, value = return, na.rm = TRUE)

# The complete function will look for all unique combinations of columns
# and then make sure all of these are contained in the dataset, using
# explicit missing values, when necessary.

stocks

stocks %>%
  complete(year, qtr)

# Keep in mind that for some patterns of implied missing values, this
# won't work. For example, consider if our implied missing data was always
# in the first quarter.

new.stocks <- tibble(
  year   = c(2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(2,    3,    4,    2,    3,    4),
  return = c(0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)

new.stocks

# Now the complete function doesn't know that the first quarter should even
# be in the pattern. Of course we could deal with this for even a large data
# set by making just one of these values explicit.

new.stocks %>%
  complete(year, qtr)

# Let's load the Rushmore Data containing study results and take a look.
# I'll let you figure out whether these data are real or fake.

rushmore <- read_csv("Rushmore Data.csv")

View(rushmore)

# We have many missing values simply because it was easier to enter the data
# this way. We can use the fill() function to tidy this up.

rushmore <- rushmore %>%
  fill(Name)

View(rushmore)

# Even when our data are tidy, we still might need to wrangle it in order
# to answer our research questions. This could include subsetting the data,
# creating new variables, renaming variables, reordering observations,
# or collapsing to a statistical summary.

# Let's take a look at the flights out of New York City in 2013.

flights <- read_csv("NYC Flights 2013.csv")

# Let's obtain the flights from the Fourth of July. We can use the filter()
# function to obtain these data.

July.4.flights <- filter(flights, month == 7, day == 4)

# A nice feature of the tidyverse is that if we want to save our data
# but also look at the first part of it, we can do that all in one step
# by enclosing everything in parentheses.

(July.4.flights <- filter(flights, month == 7, day == 4))

# Saving separate datasets becomes less important in the tidyverse due to
# our ability to pipe. For example, let's suppose I want to see if there
# is a relationship between the distance of a flight and delays in the flight
# for flights on July 4.

flights %>%
  filter(month == 7, day == 4) %>%
  ggplot(aes(x = distance, y = dep_delay)) +
  geom_point() +
  labs(title = "Data from 4 July 2013 Flights out of NYC",
       x = "Distance of Flight (in miles)",
       y = "Flight Delay (in minutes)")

# We can use logical operators for many possibilities. Here we obtain
# January and February flights.

flights %>%
  filter(month %in% c(1, 2))

# Here we obtain all flights delayed more than 8 hours on either arrival or
# departure.

flights %>%
  filter(dep_delay > 480 | arr_delay > 480)

# I'm curious whether this is associated with certain destinations.

flights %>%
  filter(dep_delay > 480 | arr_delay > 480) %>%
  ggplot(aes(x = dest)) +
  geom_bar()

# Let's make that easier to read.

flights %>%
  filter(dep_delay > 480 | arr_delay > 480) %>%
  ggplot(aes(x = dest)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# Note that filter excludes both FALSE and missing (NA) observations.
# If you want to include missing observations, you need to explicitly
# ask for them. Let's see how many flights are in the dataset where
# the flight tail number is unknown.

flights %>%
  filter(is.na(tailnum))

# We can rearrange data with the arrange() function. Suppose we want our
# data arranged by departure delays.

flights %>%
  arrange(dep_delay)

# We might want to focus on the worst delay problems, so in this case we
# can arrange in descending order.

flights %>%
  arrange(desc(dep_delay))

# Note that if there are any missing values for the variable we are sorting
# on, those cases will be put at the end of the dataset. If we want to sort
# on multiple variables, we can do so. For example, this command will
# sort by month, but for equal values of month it will then sort on departure
# delays, in descending order.

flights %>%
  arrange(month, desc(dep_delay))

# We often want to focus on just a few variables rather than all of them. We
# can do that with the select() function.

flights %>%
  select(month, day, dest, distance, dep_delay)

# Let's put this together with some of what we did above. We'll filter
# based on long delays, arrange based on delay, but look at just these
# variables. I think I'll save this one to a new data set.

(delay.issues <- flights %>%
  filter(dep_delay > 480) %>%
  arrange(desc(dep_delay)) %>%
  select(month, day, dest, distance, dep_delay))

View(delay.issues)

# You can select columns in a range.

flights %>%
  select(month, day, carrier:tailnum)

# You can select all columns except certain columns.

flights %>%
  select(-(hour:time_hour))

# There are helper functions you can use with select. We won't look at all of
# them here, but you can look at the help for the select() function to see
# more. Here's one that selects variables starting with "dep".

flights %>%
  select(month, day, starts_with("dep"))

# If you want to make sure a few variables are at the beginning of your
# columns, but don't want to have to write a complete list, you can use
# the everything() function. This will put "everything else" after the
# listed variables.

flights %>%
  select(year, month, day, dest, everything())

# You can rename variables with the rename() function.

flights %>%
  rename(depart_time = dep_time, depart_delay = dep_delay)

# Of course if you really mean it, renaming won't do anything unless you
# save it!

revised.flights <- flights %>%
  rename(depart_time = dep_time, depart_delay = dep_delay)

flights
revised.flights

# We can use the mutate() function to create new variables that are functions
# of existing variables. Let's calculate two new variables for the NYC
# flights data. The first will be how much time that planes were able to
# "make up" (i.e. gain) during the flight when they were delayed. The
# second will be the average speed in mph.

new.flights <- flights %>%
  mutate(gain = dep_delay - arr_delay,
         speed = distance/(air_time / 60))

# Let's take a look. Negative numbers means that the flight lost
# additional time. Positive numbers refer to time made up in flight.

new.flights %>%
  select(carrier, flight, dest, gain, speed)

# The mutate function will add the new variables to the dataset. The
# function transmute() works just like mutate, except it only keeps the new
# variables.

small.flight.info <- flights %>%
  transmute(gain = dep_delay - arr_delay,
            speed = distance/(air_time / 60))

small.flight.info

# The summarize() function can be used to calculate statistics on select
# variables.

flights %>%
  summarize(mean(dep_delay, na.rm = TRUE))

# This becomes more useful when we use the group_by() function. Let's see
# if departure delays vary by month.

flights %>%
  group_by(month) %>%
  summarize(mean(dep_delay, na.rm = TRUE))

# If we want to continue to do various analysis grouped by month, we can
# save file that is grouped into another tibble.

flights.by.month <- flights %>%
  group_by(month)

flights.by.month %>%
  summarize(mean(dep_delay, na.rm = TRUE))

# If you have a tibble that is grouped by some variable, you can reverse
# this with the ungroup() function.

flights.by.month %>%
  ungroup() %>%
  summarize(mean(dep_delay, na.rm = TRUE))

# Let's practice and illustrate some of the possibilities. I'm interested
# in knowing if arrival delays are related to the distance of travel.

flights %>%
  group_by(dest) %>%
  summarize(count = n(),
            dist = mean(distance, na.rm = TRUE),
            delay = mean(arr_delay, na.rm = TRUE)) %>%
  filter(count > 20) %>%
  ggplot(aes(x = dist, y = delay)) +
    geom_point(aes(size = count)) +
    geom_smooth(se = FALSE)

# There is one distance outlier that is heavily influencing the results.
# Let's see what that destination is so that we can eliminate it.

flights %>%
  group_by(dest) %>%
  filter(distance > 4000) %>%
  select(dest)

# Let's rerun the plot and remove this destination.

flights %>%
  group_by(dest) %>%
  summarize(count = n(),
            dist = mean(distance, na.rm = TRUE),
            delay = mean(arr_delay, na.rm = TRUE)) %>%
  filter(count > 20, dest != "HNL") %>%
  ggplot(aes(x = dist, y = delay)) +
    geom_point(aes(size = count)) +
    geom_smooth(se = FALSE)

# This data set must be only domestic flights. Some of the destination
# counts amaze me! I want to create a dataset that includes flights to the
# most popular destinations from NYC.

pop.dests <- flights %>%
  group_by(dest) %>%
  summarize(count = n()) %>%
  filter(count > 10000)

# If I want to capture all the flight information for these popular
# destinations, I can do it.

pop.dest.flights <- flights %>%
  filter(dest %in% pop.dests$dest)

# When working with data, we often have to use data from multiple sources
# that are related to each other. We make these relational connections with
# keys.

# A primary key for the planes data is the tail number. It's always a good
# idea to make sure that we have a clean primary key. We can do that by
# counting.

planes <- read_csv("Planes Data.csv")

check.tailnum <- planes %>%
  count(tailnum)

check.tailnum %>%
  filter(n > 1)

# There doesn't appear to be a single variable that will work as a primary
# key for weather. Let's see if we can find a combination of variables that
# will work.

weather <- read_csv("Weather Data.csv")

check.weather <- weather %>%
  count(origin, year, month, day, hour)

check.weather %>%
  filter(n > 1)

# Let's take a look at these in the full data set to see if they are
# accidental duplicates.

weather %>%
  filter((origin == "EWR" | origin == "JFK" | origin == "LGA"),
         year == 2013, month == 11, day == 3, hour == 1)

# It looks like perhaps combining origin and time_hour would work.

check.weather <- weather %>%
  count(origin, time_hour)

check.weather %>%
  filter(n > 1)

# OK, this will work, but now I'm a bit confused about the relation of hour
# and time_hour.

weather %>%
  select(origin, year, month, day, hour, time_hour)

# It appears as though the hour is supposed to be based on consecutive
# readings. Let's look further to verify.

check.weather <- weather %>%
  select(origin, year, month, day, hour, time_hour)

View(check.weather)

check.weather %>%
  filter((origin == "EWR" | origin == "JFK" | origin == "LGA"),
          year == 2013, month == 11, day == 3,
         (hour == 0 | hour == 1 | hour == 2))

# It's a data entry error! The first of those "1" hours should be "0."
# Let's change it. I always want to preserve my original data, so I'm going
# to create a new data set. Note that times are given in UTC but shown
# in local time, so I have to adjust. There are tools for doing this in the
# tidyverse, but we don't have time to look at all those.

weather.rev <- weather

weather.rev$hour[weather.rev$origin == "EWR" &
                 weather.rev$time_hour == "2013-11-03 01:00:00 UTC"] <- 0
 
weather.rev$hour[weather.rev$origin == "JFK" &
                 weather.rev$time_hour == "2013-11-03 01:00:00 UTC"] <- 0

weather.rev$hour[weather.rev$origin == "LGA" &
                 weather.rev$time_hour == "2013-11-03 01:00:00 UTC"] <- 0

# Now let's check.

weather.rev %>%
  filter((origin == "EWR" | origin == "JFK" | origin == "LGA"),
          year == 2013, month == 11, day == 3,
         (hour == 0 | hour == 1 | hour == 2))

check.weather <- weather.rev %>%
  count(origin, year, month, day, hour)

check.weather %>%
  filter(n > 1)

# We're good!

# Let's go back to the flights data. You will recall that in your group
# project that you had to figure out what airlines were represented by the
# airline codes. We now have that information in the airlines data.
# Let's get that data, check to make sure we have a valid key, then use
# that to put the full airlines name in the flights data.

airlines <- read_csv("Airlines Data.csv")

# Let's see if carrier is a legitimate key. Notes that this file is so small
# we could have just looked at it!

check.airlines <- airlines %>%
  count(carrier)

check.airlines %>%
  filter(n > 1)

airlines

# Let's create a narrower version of the flights data to work with in the
# following examples of joining two data sets.

flights <- read_csv("NYC Flights 2013.csv")

flights2 <- flights %>%
  select(year:day, hour, origin, dest, tailnum, carrier)

flights2

# The carrier key is unique in the airlines data, so it is a primary key.
# It is available in the flights data, though not unique in these data, so
# it is not a primary key. You only need a primary key in one data set in
# order to do some merging.

flights2 %>%
  left_join(airlines, by = "carrier")

# What we just did is called a "mutating join" because it added a new variable
# to the dataset. Let's learn more about joins before looking at more
# examples.

# Here's a natural join. The join is based on matching all the variables that
# appear in both data sets. Let's take time_hour out of the weather data.
# This is a special type of date variable and there is more to learn before
# using it in a match.

weather <- weather %>%
  select(-time_hour)

flights2 %>%
  left_join(weather)

# In the next example, we'll put the information about planes with the
# flight information. Note that a natural join would match on both tailnum
# and year, but we don't want that. The year in the flights information is for
# the year of the flight, but the year in the planes information is the year
# of manufacture. We'll declare that we only want to match on tailnum.

flights2 %>%
  left_join(planes, by = "tailnum")

# Note that a suffix was added to each year variable to distinguish them.
# If we were keeping this in a dataset, we would want to rename to make
# clear what each year variable represents.

# Let's load the airports data to illustrate joining when the variables we
# want to match don't have the same name.

airports <- read_csv("Airports Data.csv")
airports

# The airports code is listed as faa code in the airports data, but it is
# listed as a destination (dest) in the flights data. We can handle that
# like this.

flights2 %>%
  left_join(airports, c("dest" = "faa"))

# Filtering joins affect observations, rather than variables. Here's a
# script that will find the ten most popular destinations from NYC.

top.ten.dest <- flights2 %>%
  count(dest, sort = TRUE) %>%
  head(10)

top.ten.dest

# We can now find all flights to these destinations. The semi_join() will
# keep the observations that have a match in top.ten.dest.

flights2 %>%
  semi_join(top.ten.dest)

# An anti-join keeps the rows that don't have a match. This anti-join provides
# us the information that there are many flights in our data that cannot
# be matched to the planes in the planes data. This can be useful for
# seeing what data are missing in our data tables.

flights2 %>%
  anti_join(planes, by = "tailnum") %>%
  count(tailnum, sort = TRUE)

# Set operations are used to compare files that have the same variables.

history <- read_csv("American History Roster.csv")
composition <- read_csv("Freshman Composition Roster.csv")

# Let's find students who are in both courses.

intersect(history, composition)

# Let's get a list of students from both courses, without duplicating names.

union(history, composition)

# Let's get a list of students in history, but not in composition.

setdiff(history, composition)

# Let's get a list of students in composition, but not in history.

setdiff(composition, history)
