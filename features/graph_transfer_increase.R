# Wrap everything in an anymous function to avoid polluting the Global Environment
# If you need more debugging capability, remove the anonymous function

# Hint for speed: Use data.tables `set` and also `:=` to avoid copying the full table every time you do something

# This function counts the transfers per day (or per week), performs a linear regression (thus identifies a linear trend if there is one) and returns the slope   
# Author: Bianca, added 11.4.2018


featureTable <- (function(tokenTransferTable, featureTable) {
  print("Computing the daily increase in token transfers")
  
  # Set up progress bbar by number of groups
  numberOfGroups = uniqueN(tokenTransfers$address)
  progressBar <- txtProgressBar(min = 0, max = numberOfGroups, style = 3)
  
  # Compute the feature: 
  # 1. Define a helper function
  # Parameters: round_unit indicates whether the transfers should be aggregated by "day" or "week" - default is day
  transfer_increase <- function(sample_token_transfers, round_unit = "day"){
    # a. Simplify the timestamp, round to full day
    sample_token_transfers$timestamp <- lubridate::round_date(sample_token_transfers$timestamp, unit = round_unit)
    # b. Count the transfers per day 
    transfers_per_day <- plyr::count(sample_token_transfers, "timestamp")
    # ggplot(transfers_per_day, aes(x = timestamp, y = freq)) + geom_point() # might be a bit too coarse? 
    # c. Fit a linear regression 
    linear_fit <- lm(freq ~ timestamp, data = transfers_per_day)
    # ggplot(transfers_per_day, aes(x = timestamp, y = freq)) + geom_point() + geom_abline(intercept = linear_fit$coefficients[1], slope = linear_fit$coefficients[2])
    # d. Return the slope 
    return(as.numeric(linear_fit$coefficients[2]))
  }
  
  # 2. Use the helper function in the feature computation 
  feature <- tokenTransfers[, 
                            {setTxtProgressBar(progressBar, .GRP);
                              list(graph_transfer_increase = transfer_increase(.SD[, list(from, to, timestamp)]))
                            },
                            by = address]
  close(progressBar)
  
  
  # Join the result with the featureTable
  featureTable <- featureTable[feature, on="address"]
  
  return(featureTable)
  
})(tokenTransfers, featureTable)