
# Let's enter the tidyverse.

library(tidyverse)

n# We'll start with the hsb2 data. We are already familiar with these data.

# There are quite a few tidyverse import functions. The one we want for
# CSV files is read_csv().

hsb2 <- read_csv("hsb2.csv")

# When we created the hsb2 object, the function didn't keep silent. It
# provides us the information that we have multiple columns and it tells
# us what type of data we have in each column.

# We can view hsb2 in the usual way.

View(hsb2)

# Yet look what happens when we view it by printing it.

hsb2

# We are told that this is a "tibble" and we get the first rows. A tibble
# is a special type of data.frame. It is the data object used in the
# tidyverse. We'll see some of the features as we go, but we just saw
# one feature. We get all the information about our data that we need
# just by printing the tibble. We didn't need to use "typeof" or header
# or footer functions.

# If you happen to read in your data with a routine R function, you can
# still create a tibble.

hsb2 <- read.csv("hsb2.csv")
hsb2 <- as_tibble(hsb2)
hsb2

# Let's plot the relationship of reading and math scores.

ggplot(data = hsb2) +
  geom_point(mapping = aes(x = read, y = math))

# For this to work, the "+" has to be at the end of a line. This next
# function won't work and the tidyverse guesses at what we did wrong.

ggplot(data = hsb2)
+ geom_point(mapping = aes(x = read, y = math, color = ses))

# Back to the right way!

ggplot(data = hsb2) +
  geom_point(mapping = aes(x = read, y = math))

# The ggplot function takes the data as an argument. It then adds a
# "layer". In this case, that's geom_point(). This allows for "aesthetic
# mappings". To see another mapping, let's turn SES into a factor so that
# we can see another aesthetic.

hsb2$ses <- factor(hsb2$ses,
                   labels = c("low", "middle", "high"),
                   ordered = TRUE)

ggplot(data = hsb2) +
  geom_point(mapping = aes(x = read, y = math, color = ses))

# Instead of using "color" we could have used "size" or "shape".
# Try it! I think color works best in this case.

# We could also splot the plot into multiple plots, called "facets."

ggplot(data = hsb2) +
  geom_point(mapping = aes(x = read, y = math)) +
  facet_wrap(~ ses)

# I might want these on rows instead.

ggplot(data = hsb2) +
  geom_point(mapping = aes(x = read, y = math)) +
  facet_wrap(~ ses, nrow = 3)

# Or maybe I want them smaller to fit on two rows.

ggplot(data = hsb2) +
  geom_point(mapping = aes(x = read, y = math)) +
  facet_wrap(~ ses, nrow = 2)

# Let's say that we want to facet by two variables, such as ses and school
# type. Instead of using facet_wrap we use facet_grid.

hsb2$schtyp <- factor(hsb2$schtyp,
                      labels = c("public", "private"))

ggplot(data = hsb2) +
  geom_point(mapping = aes(x = read, y = math)) +
  facet_grid(ses ~ schtyp)

# If we want to dispense with one of those dimensions, we can.

ggplot(data = hsb2) +
  geom_point(mapping = aes(x = read, y = math)) +
  facet_grid(. ~ schtyp)

# Let's go back to our original relationship of reading and math scores
# for everyone in one plot.

ggplot(data = hsb2) +
  geom_point(mapping = aes(x = read, y = math))

# The "geom_point" in this function is called a "geom". There are
# different geoms that are available.

ggplot(data = hsb2) +
  geom_smooth(mapping = aes(x = read, y = math))

# Let's add an aesthetic for SES.

ggplot(data = hsb2) +
  geom_smooth(mapping = aes(x = read, y = math, linetype = schtyp))

# We can add multiple geoms to the sample plot!

ggplot(data = hsb2) +
  geom_point(mapping = aes(x = read, y = math, color = schtyp)) +
  geom_smooth(mapping = aes(x = read, y = math, color = schtyp))

# We can set aesthetic mappings for an entire ggplot by putting them
# in the ggplot function instead of the geom. Notice that the aesthetic
# mappings are the same in both geoms above. We could have done this.
# Now each geom will take the mappings from ggplot.

ggplot(data = hsb2, mapping = aes(x = read, y = math, color = schtyp)) +
  geom_point() +
  geom_smooth()

# If we put an aesthetic in a geom, it overrides the global aesthetic
# that we set.

ggplot(data = hsb2, mapping = aes(x = read, y = math)) +
  geom_point() +
  geom_smooth()

ggplot(data = hsb2, mapping = aes(x = read, y = math)) +
  geom_point(mapping = aes(color = schtyp)) +
  geom_smooth()

# Let's apply a geom to only a factor.

ggplot(data = hsb2) +
  geom_bar(mapping = aes(x = ses))

# Did that take you by surprise, at least just a little? The idea of
# ggplot is that we aren't learning a bunch of different functions, but
# rather we are thinking of graphs as a language, so we just have to learn
# the words in our language. Here we just had to know there was a geom
# named "geom_bar". The rest of the language stayed consistent!

# Let's look at SES by School Type.

ggplot(data = hsb2) +
  geom_bar(mapping = aes(x = schtyp, fill = ses))

# Let's change the labels.

ggplot(data = hsb2) +
  geom_bar(mapping = aes(x = schtyp, fill = ses)) +
  labs(x = "School Type", y = "Count")

