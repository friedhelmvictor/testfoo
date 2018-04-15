# Wrap everything in an anymous function to avoid polluting the Global Environment
# If you need more debugging capability, remove the anonymous function

# Hint for speed: Use data.tables `set` and also `:=` to avoid copying the full table every time you do something

# This function returns the lifetime of a token distribution (its lifespan period) in a human readable format 
# Author: Bianca, added 11.4.2018


featureTable <- (function(tokenTransferTable, featureTable) {
  print("Computing days since last seen transfer")
  
  # Set up progress bbar by number of groups
  numberOfGroups = uniqueN(tokenTransfers$address)
  progressBar <- txtProgressBar(min = 0, max = numberOfGroups, style = 3)
  
  daysec <- 60*60*24
  
  lastTransferTime <- as.numeric(max(tokenTransfers$timestamp))
  
  # Compute the feature
  feature <- tokenTransfers[, {setTxtProgressBar(progressBar, .GRP);
    list(transfers_days_since_last = (lastTransferTime - as.numeric(max(timestamp)))/daysec)
  }, by=address]
  close(progressBar)
  
  # Join the result with the featureTable
  featureTable <- featureTable[feature, on="address"]
  
  return(featureTable)
  
})(tokenTransfers, featureTable)