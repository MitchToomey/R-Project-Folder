
# The ggplot2 package in the tidyverse is an implementation of the grammar
# of graphics. The grammar of graphics was created by Leland Wilkinson.
# The ggplot2 implementation is by Hadley Wickham. I will demonstrate some
# of that grammar in this script.

library(tidyverse)

# We will use the mpg dataset that is in the tidyverse as an example. We
# can learn about this dataset just as we can learn about anything in R
# or R packages.

?mpg

# We can also learn about the characteristics of this tibble.

mpg

# A graph consists of layers. Layers are used to create the objects on a
# plot.

# The first layer is data. Every plot needs data. We typically will use
# the data for every layer, so we can make this global by putting it
# within ggplot().

ggplot(mpg)

# Aesthetics (aes) define how variables are applied to the plot. We can map
# aesthetics, which are graphical properties applied to the data.

# Here's an example of mapping engine displacement to the x axis and highway
# mileage to the y axis.

ggplot(mpg, aes(x = displ, y = hwy))

# The geometric object layers (geoms) control the actual graphical elements.
# These can have 0 dimensions (a point or text), 1 dimension (a path or line),
# or 2 dimensions (a polygon or interval).

# Here's a point geom layered on our previous layers.

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point()

# Let's add a color aesthetic to the mapping.

ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point()

# Note that we could have added it locally to the geom with the same results.

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class))

# The next layer is a statistical transformation (or stat) layer. This
# transforms the data, usually by summarizing the information.

# Here's a statistical transformation that's using the mean function for
# the y dimension (highway mileage) at each value of x (displacement) and
# putting in a double-size red point.

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  stat_summary(fun.y = "mean", color = "red", size = 2, geom = "point")

# We can use a position argument to adjust the position of elements
# on a graph. Remember this graph?

# When I saw the mean for subcompact automobiles with an engine displacement
# near 2, I assumed there must be two points on top of one another in order
# to end up with that mean. To check my hypothesis, I added a geom that
# will "jitter" the points. Notice that jittering is a position geom.

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_jitter() +
  stat_summary(fun.y = "mean", color = "red", size = 2, geom = "point")

# There are default position layers with some geoms. A stacked bar plot
# with geom_bar is an example. The bars must be positioned to be on top of
# each other so as to not overlap.

ggplot(mpg, aes(x = class, fill = drv)) +
  geom_bar(position = "stack")

ggplot(mpg, aes(x = class, fill = drv)) +
  geom_bar()

# Here we can normalize the height to make all bars the same height.
# This is based on proportions for a bar graph, but we'll need to change
# the y axis label. We'll see how to do that soon!

ggplot(mpg, aes(x = class, fill = drv)) +
  geom_bar(position = "fill")

# With a different type of position layer (dodge), we can create side-by-side
# bar graphs.

ggplot(mpg, aes(x = class, fill = drv)) +
  geom_bar(position = "dodge")

# Some geoms have a statistical transformation built in so that you don't
# need a separate line. These are transformations that make sense. For example,
# if we are using geom_bar, we are going to want a statistical transformation
# that uses the count of points rather than individual points.

ggplot(mpg, aes(x = class)) +
  geom_bar()

# When we want to use statistics based on individual points, without doing
# any transformation, this is referred to as the identity transformation.
# Notice in the functions below that the identity is the default.

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  stat_smooth()

# You might be wondering if there is a statistics function for a linear model.
# Of course!

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  stat_smooth(method = "lm")

# Next we'll consider the scales layer that let's us consider possible scale
# adjustments. Scales control how a plot maps data values to visual values
# of an aesthetic. Here's a scale function to reverse order on the x axis.

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  scale_x_reverse()

# Here's a simple bar graph.

ggplot(mpg, aes(x = class, fill = class)) +
  geom_bar()

# Now let's suppose we want to put in our own colors. We can do that with
# a scale layer.

ggplot(mpg, aes(x = class, fill = class)) +
  geom_bar() +
  scale_fill_manual(values = c("blue", "red", "green", "yellow",
                               "violet", "orange", "pink"))

# Here it is again using a pre-defined color palette (other than the default).

ggplot(mpg, aes(x = class, fill = class)) +
  geom_bar() +
  scale_fill_brewer(palette = "Set1")

# Scale can be used to control size, shape, and fill color.

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(size = 3, shape = 23, fill = "red")

# We are using geom_point, so the default scale is continuous for both
# x and y. Even so, we may want to explicitly use the scale continuous
# function for one or both dimensions if we want to override any of the
# scale defaults. In this example, I'm overriding the limits of the y axis.

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(size = 3, shape = 23, fill = "red") +
  scale_y_continuous(limits = c(0, 80))

# Another layer is the coordinate system (coord). The cartesian system is the
# default for all of the geoms we have been using and so you typically don't
# have to worry about this. You may occasionally want to do something like
# flip x and y.

ggplot(mpg, aes(x = class, fill = class)) +
  geom_bar() +
  scale_fill_brewer(palette = "Set1") +
  coord_flip()

# There is a label layer (labs) to help us put user-defined labels on the
# plots.

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  labs(x = "Engine Displacement",
       y = "Highway Gas Mileage",
       title = "Relationship of Gas Mileage to Engine Displacement",
       subtitle = "Models from 1999 to 2008",
       caption = "Sample ggplot Scatterplot using labels")

# A facet layer can be used to divide a plot into subplots.

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_grid(rows = vars(class))

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_wrap(vars(class))
  
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_grid(rows = vars(class), cols = vars(year))

# A theme layer can be used to help keep a uniform appearance.

ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  theme_classic()

ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  theme_dark()

ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  theme_minimal()

# Legend arguments can be added to a theme layer to fine-tune the legend.

ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  theme_minimal() +
  theme(legend.position = "top")

# Now that we have looked at the main elements of the grammar of graphics,
# let's see how to do some fine tuning by looking at a number of the specific
# tweaks we can make. Note that we'll not be able to look at every possible
# tweak, so I recommend that the "cheat sheet" become a frequent companion.

# Let's start with smoothing in the stat layer.

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  stat_smooth()

# You may encounter situations where you just want to show the curve, not
# the points. The geom_point and stat_smooth layers are separate, so you
# can do this.

ggplot(mpg, aes(x = displ, y = hwy)) +
  stat_smooth()

# Here it is as a linear model.

ggplot(mpg, aes(x = displ, y = hwy)) +
  stat_smooth(method = "lm")

# The shaded area is the confidence interval for predictions. By default, it
# is set at 95%. If we do repeated sampling, we expect 95% of our intervals
# to be in the shaded region. We can change the level of confidence.

ggplot(mpg, aes(x = displ, y = hwy)) +
  stat_smooth(method = "lm", level = 0.70)

# We can also eliminate the confidence interval all together.

ggplot(mpg, aes(x = displ, y = hwy)) +
  stat_smooth(method = "lm", se = FALSE)

# Here's our original graph again.

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  stat_smooth()

# For those who have had an experimental design class and learned about
# trend analysis, let's look at a quadratic trend.

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  stat_smooth(method = "lm", formula = y ~ poly(x, 2))

# I found a post online by someone who had created a user-defined function
# using ggplot. Check it out.

ggplotRegression <- function (fit) {
  
  require(ggplot2)
  
  ggplot(fit$model, aes_string(x = names(fit$model)[2],
                               y = names(fit$model)[1])) + 
    geom_point() +
    stat_smooth(method = "lm", col = "red") +
    labs(title = paste("Adj R2 = ",signif(summary(fit)$adj.r.squared, 5),
                       "Intercept =",signif(fit$coef[[1]],5 ),
                       " Slope =",signif(fit$coef[[2]], 5),
                       " P =",signif(summary(fit)$coef[2,4], 5)))
}

# Now let's call this function.

ggplotRegression(lm(hwy ~ displ, data = mpg))

# I'll leave it to you to start dreaming about the possibilities!

# Let's spend a moment talking about inheritance. I mentioned that the only
# global inheritance is from the ggplot function. Let's see how that
# knowledge can influence our plots.

# Back to the original, but without a confidence region.

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  stat_smooth(se = FALSE)

# Now let's move the color aesthetic to become global.

ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  stat_smooth(se = FALSE)

# We can use this feature to check for interaction in regression plots.

ggplot(subset(mpg, class == "pickup" | class == "minivan" | class == "suv"),
       aes(x = hwy, y = cty, color = class)) +
  geom_point() +
  stat_smooth(method = "lm", se = FALSE)

# Let's switch to looking at the relationship of a categorical and
# quantitative variable. A boxplot is certainly an option.

ggplot(mpg, aes(x = class, y = hwy)) +
  geom_boxplot()

# One possible replacement for a boxplot is just to plot raw data. We just
# change the geom back to geom_point().

ggplot(mpg, aes(x = class, y = hwy)) +
  geom_point()

# Often points can be on top of one another. Let's add jitter.

ggplot(mpg, aes(x = class, y = hwy)) +
  geom_point() +
  geom_jitter()

# Rather than use the jitter geom, we can use it as a positioning argument.

ggplot(mpg, aes(x = class, y = hwy)) +
  geom_point(position = "jitter")

# Here's another option. This should prove that geoms are worth exploring!

ggplot(mpg, aes(x = class, y = hwy)) +
  geom_violin() +
  geom_dotplot(binaxis = "y", stackdir = "center", binwidth = .3)

# Keep in mind we could add a layer to put in a statistic.

ggplot(mpg, aes(x = class, y = hwy)) +
  geom_violin() +
  geom_dotplot(binaxis = "y", stackdir = "center", binwidth = .3) +
  stat_summary(fun.y = "mean", color = "red", size = 1.5, geom = "point")

# Let's add confidence intervals for the mean.

ggplot(mpg, aes(x = class, y = hwy)) +
  geom_violin() +
  geom_dotplot(binaxis = "y", stackdir = "center", binwidth = .3) +
  stat_summary(fun.y = "mean", color = "red", size = 1.5, geom = "point") +
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", color = "red")

# Better yet, let's use nonparametric bootstrap intervals.

ggplot(mpg, aes(x = class, y = hwy)) +
  geom_violin() +
  geom_dotplot(binaxis = "y", stackdir = "center", binwidth = .3) +
  stat_summary(fun.y = "mean", color = "red", size = 1.5, geom = "point") +
  stat_summary(fun.data = mean_cl_boot, geom = "errorbar", color = "red")

# Let's go back to one of our first graphs and talk about "mapping" aesthetics
# versus "setting" aesthetics. Here's the graph.

ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point()

# Here we mapped color onto the class data. Let's try something else.

ggplot(mpg, aes(x = displ, y = hwy, color = "red")) +
  geom_point()

# Well, they are kind of red, but there's also a legend that I don't want.
# Here's another one.

ggplot(mpg, aes(x = displ, y = hwy, color = "blue")) +
  geom_point()

# OK, now that's REALLY not what I want. What's going on? The problem is
# that we're mapping color onto a new category that we create. The color
# being chosen has nothing to do with our category. If we really want
# to set all the points to being red (or blue) we need to set instead of
# map. Notice that I pulled the color out of the aesthetic. Aesthetics
# map to data. I just want to set the color.

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(color = "red")

# Now it is red and the leged is gone!

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(color = "blue")

# OK, but what if we want to map AND have the colors our own way. We can do
# that with a scale. Remember that a scale controls how a plot maps data values
# to visual values of an aesthetic. We are still going to map an aesthetic,
# but now we're using a scale to fine-tune how that mapping looks.

ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point() +
  scale_color_manual(values = c("Red", "Blue", "Pink", "Brown",
                                "Green", "Violet", "Black"))

# We looked earlier at two categorical variables, but we still needed to clean
# the graph up a bit. Here's what we did.

ggplot(mpg, aes(x = class, fill = drv)) +
  geom_bar(position = "fill")

# A reminder that the "fill" position will normalize the heights, which for
# bar graphs provide us proportion on the vertical axis. We just need to
# name it that!

ggplot(mpg, aes(x = class, fill = drv)) +
  geom_bar(position = "fill") +
  labs(x = "Vehicle Class", y = "Proportion")








