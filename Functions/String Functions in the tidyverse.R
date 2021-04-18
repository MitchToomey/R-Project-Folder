
# Strings are sequences of characters. The tidyverse includes functions for
# working with strings. Often you will want to use these functions while
# you are tidying data and data wrangling, but they are useful for other
# situations, as well.

library(tidyverse)

# You can create a string with single or double quotes. There is no difference
# as far as R is concerned. Note, though, that R converts to double quotes,
# so I recommend using these.

string.1 <- "This is with double quotes."
string.2 <- 'This is with single quotes.'
string.1
string.2

# Use double quotes within single quotes to include a quote in a string.

string.3 <- 'Then I heard him shout, "Hey!" to get my attention.'
string.3

# Note that the downhill slash (\) is use to indicate a quote mark within
# a string. When we view these strings we see the slash. To see that content
# use the writeLines() function.

writeLines(string.3)

# Here I'm putting one quote mark within a string.

string.4 <- "We may want to use a \" mark in a string."
string.4
writeLines(string.4)

# Since the downhill slash is used to indicate special characters, we need
# two of them to indicate a slash in a string.

string.5 <- "The downhill slash (\\) is a special character."
string.5
writeLines(string.5)

# We use \n to indicate a new line.

string.6 <- "I want to leave class.\nI want to leave now.\nPlease let me leave."
string.6
writeLines(string.6)

# We use \t to indicate a tab.

string.7 <- "Here is item #1:\tShoes\nHere is item #2:\tSocks"
string.7
writeLines(string.7)

# All the tidyverse string functions begin with str_ to keep them consistent.

# Here's to check string length.

str_length(string.7)

# Here's how we combine strings.

str_c("a", "b", "c")

# You can combine strings and separate them with a character of your choice.

str_c("a", "b", "c", sep = ",")
str_c("a", "b", "c", sep = " ")

writeLines(str_c(string.5, string.6, string.7, sep ="\n"))

# Let's try this again with a character vector.

my.vector <- c("a", "b", "c")
my.vector

str_c(my.vector)

# This happens because str_c is vectorized, so the str_c() function is
# operating on each individual element of the vector. We can override this
# by pulling out each element of the vector.

str_c(my.vector[1], my.vector[2], my.vector[3])

# Alternatively, we can collapse a vector of strings into a single string.

str_c(my.vector, collapse = "")

# We can use different separators.

str_c(my.vector, collapse = ",")

# We can use the vectorization aspect of str_c to do some interesting things.

str_c(my.vector, "1")
str_c("|", my.vector, "|")

# Here's what happens when you have missing data.

my.vector.2 <- c("a", NA, "b")

str_c("|", my.vector.2, "|")

# If you want to treat NA as the string "NA" you can do it.

str_c("|", str_replace_na(my.vector.2), "|")

# If a string has no length, it is dropped.

str_length("")

str_c("My name is ", "", "Mike.")

# This feature is especially useful with the if() function.

my.name <- "Mike"
time.of.day <- "afternoon"
birthday <- FALSE

str_c(
  "Good ",
  time.of.day,
  " ",
  my.name,

    if (birthday) " and Happy Birthday",

  "."
)

# You can extract parts of a string with str_sub(). Let's get rid of "room"
# and just extract the number portion for these room numbers.

school.rooms <- c("Room 521", "Room 413", "Room 799", "Room 608")
str_sub(school.rooms, 6, 8)

# Alternatively, we can count from the end of the string.

str_sub(school.rooms, -3, -1)

# You can also use this with the assignment operator.

str_sub(school.rooms, -1, -1) <- "0"
school.rooms

# There are functions for changing to lower case, upper case, and title case.

first.prez <- "George Washington"

str_to_upper(first.prez)
str_to_lower(first.prez)
str_to_title(first.prez)

# You can sort and order.

student.names <- c("Edward", "Alice", "Manuel", "Carl", "Richard", "Felicia")

str_sort(student.names)
str_order(student.names)
student.names[str_order(student.names)]

# Some functions are dependent on locale. You can specify this using the
# ISO 639 language code.

str_to_upper("i", locale = "tr")

str_sort(student.names, locale = "haw")

# The tidyverse string functions take advantage of "regular expressions"
# (also known as regexps). These are sequences of characters that define a
# search pattern.

# We can use the str_view() function to see how some regexps work. A string
# of characters simply looks for an exact match.

str_view(student.names, "ic")

# The period matches any character.

str_view(student.names, ".l")

# To match a period, we need to use \\. That's because the downhill slash
# is for special behaviors in a spring, so we need to add a second one
# when we are using it as a regexp. Note also that a search for a match
# within a string stops at the first instance.

str_view("This is a test. Only a test.", ".\\.")

# To find a literal backslash in a string, you'll need four of them in
# the regexp!

my.sentence <- "We use \\ for special characters."
my.sentence
writeLines(my.sentence)

str_view(my.sentence, "\\\\")

# You can indicate whether you want to match at the start or end of a
# string.

courses <- c("math", "stats", "history", "chemistry", "sociology")

str_view(courses, "^s")
str_view(courses, "s$")

# You can force a match of a complete string by using both of these.

bubba.gump <- c("shrimp", "shrimp gumbo", "boiled shrimp", "baked shrimp")

str_view(bubba.gump, "shrimp")
str_view(bubba.gump, "^shrimp")
str_view(bubba.gump, "shrimp$")
str_view(bubba.gump, "^shrimp$")

# You can match any digit with \\d.

July.4 <- c("July 4", "4 July", "Fourth of July")

str_view(July.4, "\\d")
str_view(July.4, "^\\d")

# You can find whitespace with \\s.

str_view(July.4, "\\s")

# You can find matches for any character in a set using [ ].

str_view(July.4, "[Fuz]")

# You can find match for any character not in a set using [^ ].

str_view(July.4, "[^JF]")

# Repetition refers to how many times a pattern matches. The operators for
# repetition are ? (0 or 1 matches), + (1 or more matches), and * (0 or more
# matches).

our.numbers <- "011111222244444444"

str_view(our.numbers, "00?")
str_view(our.numbers, "11?")
str_view(our.numbers, "22222+")
str_view(our.numbers, "22222*")

# Here's an example of using one of these operators to check for British
# or American spelling.

color.spells <- c("color", "colour", "coler")

str_view(color.spells, "colou?r")

# We can use parantheses to help define our pattern.

str_view(c("orange", "apple", "banana"), "ba(na)+")

# You can specify the exact number of matches. Use {n} for exactly n matches,
# use {n,} for n or more matches, and use {n,m} for between n and m matches.

str_view(our.numbers, "2{3}")
str_view(our.numbers, "2{4}")
str_view(our.numbers, "2{5}")
str_view(our.numbers, "2{3,4}")
str_view(our.numbers, "2{4,5}")
str_view(our.numbers, "2{5,6}")

# Knowing regexps is a foundation for using string tools in the tidyverse.
# There are many more, and they can be powerful, so keep this in mind if you
# need to detect a pattern that we haven't covered. You can always search
# for more regexps.

# Now it's time to learn about the string tools that we can use with these
# regexps to do useful things. We use str_detect() to see if we can find
# a pattern match in a character vector.

student.names

str_detect(student.names, "ic")
str_detect(student.names, "^R")
str_detect(student.names, "[ei]")
str_detect(student.names, "[^Carl]")
str_detect(student.names, ".e")
str_detect(student.names, "ar|ic")

# Sometimes regexps can be made easier by just using R functions.
# Here's a regexp for finding words with no vowels.

some.words <- c("cat", "bird", "shy", "crayon", "myths")

str_detect(some.words, "^[^aeiou]+$")

# Here it is again in simpler form just using R operators.

!str_detect(some.words, "[aeiou]")

# We can use str_detect as an index to pull out words.

some.words[!str_detect(some.words, "[aeiou]")]

# There is also a str_subset function to do this.

str_subset(some.words, "^[^aeiou]+$")

# That example makes the str_subset function seem difficult because the
# regexprs is a bit difficult. Here's an easier to see example. I want
# all the names that end with "l".

student.names[str_detect(student.names, "l$")]
str_subset(student.names, "l$")

# Most of the time we'll be working with a column in a data frame, so
# we'll combine the str_detect with the filter command.

students <- read_csv("Riverside Elementary Data.csv")
students

# Let's get all the students from Paul Rich's class.

students %>%
  filter(str_detect(Teacher, "Rich"))

# If we want to replace all the variations of Paul Rich with a single
# representation (a good idea), we can do it.

students$Teacher[str_detect(students$Teacher, "Rich")] <- "Paul Rich"

students %>%
  filter(str_detect(Teacher, "Rich"))

# We can use str_replace() and str_replace_all() to replace a character with a
# different character. Using str_replace() will replace the first matched
# pattern while str_replace_all() will replace all matched patterns.

id.numbers <- c("#254", "#331", "#712")

str_replace(id.numbers, "#", "")

# I'm trying to replace the "." with a "-". Can you explain what happened
# here? Do you know how to correct the problem?

phone.numbers <- c("803.555.3498", "294.555.7821", "447.555.9192")

str_replace_all(phone.numbers, ".", "-")

# We can split strings with str_split(). In this example I want to separate
# first and last names. Notice that the result is a list.

student.names <- c("Edward Cornish",
                   "Alice Johnson",
                   "Manuel Rodriguez",
                   "Carl Hines",
                   "Richard Stiller",
                   "Felicia Moore")

names.list <- str_split(student.names, " ")
names.list

class(names.list)

first.names <- sapply(names.list, function(x) x[1])
first.names

last.names <- sapply(names.list, function(x) x[2])
last.names

# Sometimes you might have extra whitespace after a word that you don't want.
# You can use str_trim(). It can trim whitespace from the left side, the
# right side, or both sides.

id.nums <- c("A1523  ", "B2234", "C1824    ", "D9238")
str_trim(id.nums, side = "right")
