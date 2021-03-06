### 2 

Write a function that has a single argument that is a data frame of raters (in columns) and their observation scores (in rows). The function should return a well-labeled data frame with all other raters (note that a single percent agreement is among two raters, so a separate percent agreement needs to be calculated for a rater with each other rater). These should be the mean of the percent agreement (PA) statistic, the SD of PA, and the minimum and maximum PA

```{r}

 rater_data <- function(data) 
   {
   N = nrow(data)
   R = ncol(data)
   
   counts <- NULL
   
   for(i in 1:(R-1)){
     for (j in (i+1):R){
           if (i != j) {  
             
             a <- data[, i]
             b <- data[, j]
             counts <- c(counts, sum(a == b))  
             percent <- (counts/length(a))*100  
                                               
      } else {NULL}
    }
  }
   
   PA <- matrix(percent, nrow= R, ncol= R)   
                                             
   Mean <- NULL
   SD <- NULL
   Min <- NULL
   Max <- NULL
   
   for (k in 1:ncol(PA)){                     
                                             
     Mean <- c(Mean, round(mean(PA[, k]), 2))
     SD <- c(SD, round(sd(PA[,k]),2))
     Min <- c(Min, round(min(PA[,k]),2))
     Max <- c(Max, round(max(PA[,k]),2))
  }
   df <- data.frame(rbind(Mean, SD, Min, Max)) 
   colnames(df) <- names(data)
   print(df)
 }
 
library(here)
raters <- read.csv(here("Data", "raters.csv"))
rater_data(raters[2:9])

```
### 3

My attempt at the function for this.

I metacoded a bit, got lost, and am using Dr. Seaman's function

Write a function that takes two arguments. The first is a data frame of raters (in columns) and their observation scores (in rows). The second is a matrix with two columns in which each row specifies the lowest and highest scores that should be collapsed to form a new category. The function should return a data frame of raters and their scores based on the newly formed categories

```{r}

# Write function with two arguments

# argument 1: Create a data frame
# raters in columns
# observation scores  in rows

# argument 2: Create a matrix with two columns
# column 1: lowest scores collapsed into --> category 1
# column 2: highest scores collapsed into --> category 2

# return a data frame
# raters in columns
# new observation scores recoded into 2 categories


num_raters <- ncol(my_dataframe)
num_observations <- nrow(my_dataframe)


collapse_matrix <- matrix(c(1, 2, 4, 4, 5, 6),  
                          ncol = 2,
                          byrow = TRUE)

# I have accepted my limitations and will use Dr. Seaman's functions for these problems

```
### 4: I actually tackled most of this one before collaborating with others!

# creating data frame of raters
# summing total rater scores
# ranking sums in terms of 1st place, 2nd place, etc

# create a data frame of ratings
# basically there are scores for raters on each row

# columns = raters
# rows = observations

df_raters <- function(my_df){
  
  rater_1 <- c(3, 4, 5)
  rater_2 <- c(4, 5, 2)
  rater_3 <- c(2, 3, 4)
  rater_4 <- c(5, 4, 3)
  
  my_matrix <- cbind(rater_1, rater_2, rater_3, rater_4)
  
  rownames(my_matrix) <- c("school_1", "school_2", "school_3")
  
  my_df <- as.data.frame(my_matrix)
}
# we want to sum the scores on each row

df_rater_sum <- function(my_df){
  
  df_sums <- rowSums(my_df)
  
  my_df <- cbind(my_df, df_sums)
  
}      

# then return an ordered integer vector
# ranking summed scores in order from 1st, 2nd, 3rd

rank_rater_sums <- function(rate_vector){   
  
  u <- unique(sort(df_sums, decreasing = TRUE))
  n <- 1
  rate_vector <- (1:length(df_sums))
  names(rate_vector) <- c("school 1", "school 2", "school 3")
  
  for (i in 1:length(u)) {
    for (j in 1:length(df_sums)) {
      if(df_sums[j] == u[n]) rate_vector[j] <- n
      
    } 
    n <- n+1 
    
  }
  
  rate_vector <- sort(rate_vector, decreasing = FALSE)
}