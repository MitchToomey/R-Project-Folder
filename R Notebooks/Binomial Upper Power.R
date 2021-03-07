
# This function will calculate binomial power for an upper-tailed test.
# Alternatively, it will calculate sample size to reach a certain power.

# The arguments are a null hypothesized value, an alternative hypothesized
# value, sample size or power, an indicator of whether this is sample size
# or power, and a confidence level.

binom_up_pow <- function(null_value,
                         alt_value,
                         samp_pow,
                         samp_size = TRUE,
                         conf_lev = 0.95) {
  
  # Here is a function to calculate power from sample size_
  
  get_power <- function(nv,av,sp, cl){
    cv <- qbinom(1-cl, sp, nv, lower.tail = FALSE) + 1
    pow <- 1 - pbinom(cv - 1, sp, av)
  }
  
  # Here is a function to calculate sample size for desired power_
  
  get_samp_size <- function (nv, av, sp, cl){
    n <- 10
    temp_power <- 0
    
    while (temp_power < sp){
      temp_power <- get_power(nv, av, n, cl)
      n <- n+1
    }
    
    return(n-1)
  }
  
  if (samp_size)
    result <- get_power(null_value, alt_value, samp_pow, conf_lev)
  else
    result <- get_samp_size(null_value, alt_value, samp_pow, conf_lev)
  
  return(result)
}
