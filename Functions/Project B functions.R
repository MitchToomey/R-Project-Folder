These are the functions that worked that I got from a classmate. 
My attempts at 2 and 3 are in the file "Project B functions_attempt"

#### 2. 

rate_my_data<- function (data) 
{
  N = nrow(data) 
  R = ncol(data) 
  column_names <- colnames(data)
  row_names <- c("Means", "SDs", "Min Scores", "Max Scores") 
  PA <- matrix (nrow=R, ncol=R) 
  
  for (i in 1:(R-1)) #R-1 excludes the last rater
  {
    for (j in (i+1):R) 
    {
      dec<- NULL
      
      for(h in 1:N)
      {
        if (data[h, i] == data[h, j]) 
        {
          dec[h] = 1                 
        }
        else
        { 
          dec[h] = 0                   
        }
        
      } 
      PA[i, j] <- (sum(dec == 1)/N)*100 #calculate and stores the decisions
      PA[j, i] <- (sum(dec == 1)/N)*100 
    }
    
    
  }
  PAs<- matrix(nrow=4, ncol=ncol(PA), byrow= TRUE) #empty matrix for storage
  
  for (n in 1:R)
    
  {
    
    # these 4 lines calculate statistics
    
    PAs [1, n] <- round(apply(PA [n, , drop=F], 1, FUN= mean, na.rm = TRUE), digit = 2)
    PAs [2, n] <- round(apply(PA [n, , drop=F], 1, FUN=sd, na.rm = TRUE), digit = 2)
    PAs [3, n] <- round(apply(PA [n, , drop=F], 1, FUN=min, na.rm = TRUE), digit = 2)
    PAs [4, n] <- round(apply(PA [n, , drop=F], 1, FUN= max, na.rm = TRUE), digit = 2)
    
  }
  
  results<-data.frame(PAs, row.names = row_names) #change to data frame
  names(results)<- column_names #give column names
  
  return(results) 
}

#### 3. 

collapsed <- function (x, y) #x=data frame y=matrix; 2 arguments
  
{
  N = nrow(x) 
  R = ncol(x)
  G = nrow(y) #how many category we will have
  column_names<-colnames(x) #keep the raters in the columns
  
  for (i in 1:R) 
  {
    for (j in 1:N) 
    {
      for (k in 1:G)
      {
        if (x[j, i] >= y[k,1] & x[j,i] <= y[k,2]) #deciding
        {
          x[j,i]= k #collapsing
        }
      }
    } 
    
  }
  
  return (x)
}

#### 4. 

final_decision <- function (x) #this function sums the rows and sorts the column
{
  
  scores <- rowSums(x)
  new_data <- cbind(x, scores)
  sorted <- new_data[order(new_data$scores, decreasing = TRUE), ]
  row_numb <- as.vector(nrow(x))
  col_numb <- as.vector(ncol(x))
  result <- 1
  ranked_result <- 1
  
  for (i in 1:(row_numb-1))
  {
    if (sorted[i+1, col_numb+1] < sorted[i, col_numb+1])
    {
      result <- result + 1
      ranked_result <- c(ranked_result, result)
    }
    else if (sorted[i+1, col_numb+1] == sorted[i, col_numb+1])
    {
      result <- result
      ranked_result <- c(ranked_result, result)
    }
    
  }
  
  final <- cbind(ranked_result, sorted)
  return(final)
  
}




