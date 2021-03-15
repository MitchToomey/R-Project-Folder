
# This function provides percent agreement based on two rater vectors.

percent_agreement <- function(rater_1, rater_2){
  
  r1_r2_agree <- 100 * (sum(rater_1 == rater_2) / length(rater_1))
  
  return(r1_r2_agree)
}


# This function provides statistics for percent agreement for raters.

rater_statistics <- function(ratings) {
  
  # Determine the number of raters
  
  num_raters <- ncol(ratings)
  
  # Set up PA data frame
  
  PA <- as.data.frame(matrix(nrow = num_raters - 1, ncol = num_raters))
  
  # Set up PA statistics data frame.
  
  PA_statistics <- as.data.frame(matrix(nrow = 4, ncol = num_raters))
  rownames(PA_statistics) <- c("Mean", "SD", "Min", "Max")
  colnames(PA_statistics) <- colnames(ratings)
  
  # Calculate PA for each rater and store in matrix
  
  for (i in 1:(num_raters - 1)){
    
    for (j in (i+1):num_raters){
      
      raters_PA <- percent_agreement(ratings[, i], ratings[, j])
      
      PA[j-1, i] <- raters_PA
      PA[i, j] <- raters_PA

    }
  }

  PA_statistics[1, ] <- sapply(PA, mean)
  PA_statistics[2, ] <- sapply(PA, sd)
  PA_statistics[3, ] <- sapply(PA, min)
  PA_statistics[4, ] <- sapply(PA, max)
  
  # Return data frame
  
  return(PA_statistics)

}


# This function can be used to collapse rating categories

rater_collapse <- function(ratings, collapse_cats){
  
  # Obtain the number of new categories.
  
  num_cats <- nrow(collapse_cats)
  
  # Replace old ratings with new ratings.
  
  for (i in 1:num_cats){
    
    ratings[ratings >= collapse_cats[i, 1] &
            ratings <= collapse_cats[i, 2]] <- i
    
  }
  
  return(ratings)
  
}
