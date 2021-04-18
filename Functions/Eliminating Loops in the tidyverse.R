
# The tidyverse has functions that enable us to eliminate loops.

# Here's a data frame with four variables with random normal variates.

our.data <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)

# We could calculate the medians of these columns separately.

median(our.data$a)
median(our.data$b)
median(our.data$c)
median(our.data$d)

# That's fine, but what if we had 100 or 200 columns? Then we could use a
# loop. We start by initiating a vector of type "double" and with the
# same number of items as the number of variables in our data. Note the
# use of the seq_along() function. This is a nice function for indicating
# that we want i to sequentially index across the variables in our data.

median.vec <- vector("double", ncol(our.data))

for (i in seq_along(our.data)) {
  median.vec[[i]] <- median(our.data[[i]])
}

median.vec

# That will work for any number of columns that we have in our dataframe.
# The map() functions in the tidyverse really makes this easy. These are
# functions (plural) because there are different functions for different
# types of data. The map_dbl is for double data.

map_dbl(our.data, median)

# We can pipe the data.

our.data %>%
  map_dbl(median)

# We could use map() if we want a list, instead of a vector, but that's
# probably not what we want here.

our.data %>%
  map(median)

# Look at how we can use the tidyverse split() function with mapping.
# The split function takes a single data frame and splits it into a list
# of data frames. Here we split the mtcars data on the basis of the number
# of cylinders.

car.list <- mtcars %>%
  split(mtcars$cyl)
  
car.list

# Now we are going to look at the relationship of gas mileage to weight of
# the car, but we're going to do it separately for each cylinder. Note
# that the lm() function expects us to use for data. The "." indicates
# to use the current list item. Remember that a list item here is a data
# frame.

car.list %>%
  map(~lm(mpg ~ wt, data = .))

# One of the really cool features of a map function is the ability to extract
# components of lists. Let's create another dataframe of normal variates,
# but this time use a different mean for each.

our.data <- tibble(
  a = rnorm(10, mean = 0, sd = 10),
  b = rnorm(10, mean = 5, sd = 10),
  c = rnorm(10, mean = 10, sd = 10),
  d = rnorm(10, mean = 15, sd = 10)
)

# Let's apply the t.test function to each column.

our.data %>%
  map(t.test)

# Let's do it again, but this time let's put all the p values in a vector.
# Notice the attributes for the t.test results.

check.t.test <- t.test(our.data$a)
attributes(check.t.test)

# The p-value results are in p.value.

our.data %>%
  map(t.test) %>%
  map_dbl("p.value")

# Let's pull out the confidence intervals. These are themselves vectors,
# so we need to put the results in a list.

our.data %>%
  map(t.test) %>%
  map("conf.int")

# We could have made that whole series of event even cleaner by using a map
# to generate our data in the first place! Remember that map works on lists,
# so we need to put our means in a list.

my.means <- list(0, 5, 10, 15)

our.data <- my.means %>%
  map(rnorm, n = 10, sd = 10)

our.data

# Now we have a list of vectors.

our.data %>%
  map(t.test) %>%
  map("conf.int")

# Let's look at the order in which we supply items to a map when we are
# iterating over a function. First, we send it any arguments that vary.
# Then the function and additonal arguments. So we could have done the
# above like this.

my.means <- list(0, 5, 10, 15)

our.data <- map(my.means, rnorm, n = 10, sd = 10)

our.data

# What if we wanted to vary the standard deviation as well? We can use
# the map2() function.

my.means <- list(0, 5, 10, 15)
my.sds <- list(10, 12, 14, 16)

our.data <- map2(my.means, my.sds, rnorm, n = 10)

our.data

# What if we had three arguments to vary. Is there a map3? No, but there
# is a pmap function that will allow you to vary any number of arguments
# by putting them in a list, but we're going to stop here.

