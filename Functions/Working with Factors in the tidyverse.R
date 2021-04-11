
# This script provides an overview of some of the factor functions in the
# tidyverse. These all begin with fct.

library(tidyverse)

# We will use the World Data for these examples.

world.data <- read_csv("World Data.csv")
world.data

# The first two variables should be factors.

world.data$country <- as_factor(world.data$country)
world.data$continent <- as_factor(world.data$continent)
world.data

# We can use fct_count() to provide us a count of the number of units within
# each factor level.

fct_count(world.data$continent)

# We can sort these by size.

fct_count(world.data$continent, sort = TRUE)

# Let's select some countries.

our.countries <- c("Egypt", "Haiti", "Romania", "Thailand", "Venezuela")

five.data <- world.data %>%
  filter(country %in% our.countries)

# Look how many observations we have and then look at how many factor levels
# we have in our object.

levels(five.data$country)

# R doesn't drop the levels when we drop data. We can do that with fct_drop().

five.data$country %>%
  fct_drop() %>%
  levels()

# Let's use mutate() and fct_drop() to clean up our data set.

five.data <- five.data %>%
  mutate(country = fct_drop(country))

# Let's see what happened.

five.data
levels(five.data$country)

# Here's a graph of the frequency in the world data set for each continent.

world.data %>%
  ggplot(aes(x = continent)) +
  geom_bar()

# We can change the order of the factor to be based on frequency with
# fct_infreq().

world.data$continent <- fct_infreq(world.data$continent)

# Now let's look at the graph.

world.data %>%
  ggplot(aes(x = continent)) +
  geom_bar()

# We can turn this the other way around by reversing the factor.

world.data$continent <- fct_rev(world.data$continent)

world.data %>%
  ggplot(aes(x = continent)) +
  geom_bar()

# Let's order the countries in the world data in terms of life expectancy.

fct_reorder(world.data$country, world.data$lifeExp) %>%
  levels() %>%
  head()

# Remember that each country actually appeared multiple times due to multiple
# data.

world.data

# When we ask for a reordering based on a quantitative variable, the default
# is to use the median of the values for that factor. We can include a
# function in our reordering to change this. 

fct_reorder(world.data$country, world.data$lifeExp, min) %>%
  levels() %>%
  head()

# We can go from highest to lowest, instead of lowest to highest.

fct_reorder(world.data$country, world.data$lifeExp, min, .desc = TRUE) %>%
  levels() %>%
  head()

# Reordering can certainly help the readability of graphs.

asia.2007 <- world.data %>%
  filter(year == 2007, continent == "Asia")

asia.2007 %>%
  ggplot(aes(x = lifeExp, y = country)) +
  geom_point()

asia.2007 %>%
  ggplot(aes(x = lifeExp, y = fct_reorder(country, lifeExp))) +
  geom_point()

# Now let's use a sample of data from the General Social Survey that is
# included with the tidyverse package.

gss_cat

# Let's look at the levels of a factor are by counting.

gss_cat %>%
  count(race)

# We can also see it visually.

gss_cat %>%
  ggplot(aes(race)) +
  geom_bar()

# It is possible that there are other options for this survey item that no
# one checked, so they won't show up in the bar graph. We can force them
# to show up.

gss_cat %>%
  ggplot(aes(race)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)

# Let's calculate some statistics that we can use in further analysis.

relig_summary <- gss_cat %>%
  group_by(relig) %>%
  summarize(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

# Now let's look at mean number of hours spent watching TV per day, by
# religion.

relig_summary %>%
  ggplot(aes(tvhours, relig)) +
  geom_point()

# This graph can be improved by reordering the levels of religion based
# on tvhours. We've learned about the fct_reorder() function. Let's use it!

relig_summary %>%
  ggplot(aes(tvhours, fct_reorder(relig, tvhours))) +
  geom_point()

# Here we do the function reordering before creating the plot.

relig_summary %>%
  
   %>%
  ggplot(aes(tvhours, relig)) +
  geom_point()

# This survey also has income levels, so let's calculate some summary
# statistics to go along with those levels.

rincome_summary <- gss_cat %>%
  group_by(rincome) %>%
  summarize(
    age = mean(age, na.rm = TRUE),
    tvhours = mean(tvhours, na.rm = TRUE),
    n = n()
  )

# Now the graph.

rincome_summary %>%
  ggplot(aes(age, rincome)) +
  geom_point()

# We wouldn't want to reorder these based on age because the incomes are
# in order. Yet the "not applicable" at the top is out of place. We can
# use the fct_relevel() function to handle that problem. This function
# will move any levels we want to the front of the line (seen in this
# graph starting at the bottom).

rincome_summary %>%
  ggplot(aes(age, fct_relevel(rincome, "Not applicable"))) +
  geom_point()

# Notice that we can tweak the order further, if we wish.

special.answers <- c("No answer", "Not applicable", "Refused", "Don't know")

rincome_summary %>%
  ggplot(aes(age, fct_relevel(rincome, special.answers))) +
  geom_point()

# Now let's look at the political party affiliation question on the survey.

gss_cat %>%
  count(partyid)

# With fct_recode() we can change values of a factor. Let's change these
# factors to have more parallel form.

gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong" = "Strong republican",
                              "Republican, weak" = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak" = "Not str democrat",
                              "Democrat, strong" = "Strong democrat")) %>%
  count(partyid)

# Note that factors that are not mentioned are left alone. Note that we
# can also combine a few of these. This may not be a good idea in this
# situation because these categories really mean different things.

gss_cat %>%
  mutate(partyid = fct_recode(partyid,
                              "Republican, strong" = "Strong republican",
                              "Republican, weak" = "Not str republican",
                              "Independent, near rep" = "Ind,near rep",
                              "Independent, near dem" = "Ind,near dem",
                              "Democrat, weak" = "Not str democrat",
                              "Democrat, strong" = "Strong democrat",
                              "Other" = "No answer",
                              "Other" = "Don't know",
                              "Other" = "Other party")) %>%
  count(partyid)

# An easier way to handle collapsing categories is the fct_collapse()
# function.

gss_cat %>%
  mutate(partyid = fct_collapse(partyid,
    other = c("No answer", "Don't know", "Other party"),
    rep = c("Strong republican", "Not str republican"),
    ind = c("Ind,near rep", "Independent", "Ind,near dem"),
    dem = c("Not str democrat", "Strong democrat")
  )) %>%
  count(partyid)

# Look at the number of religions in the survey.

gss_cat %>%
  count(relig)

# We can lump categories together with fct_lump().

gss_cat %>%
  mutate(relig = fct_lump(relig)) %>%
  count(relig)

# That's probably a bit too simple for characterizing religions in the
# United States! We can do better by specifying how many groups we want.
# The smallest frequency groups will be grouped together. Looking at the
# list, I think 10 is about right.

gss_cat %>%
  mutate(relig = fct_lump(relig, n = 10)) %>%
  count(relig)




                                
