# Wrap everything in an anymous function to avoid polluting the Global Environment
# If you need more debugging capability, remove the anonymous function

# Hint for speed: Use data.tables `set` and also `:=` to avoid copying the full table every time you do something


featureTable <- (function(tokenTransferTable, featureTable) {
  print("Calculating mean, median, max and min time gap between transfers")
  
  # Set up progress bar by number of groups
  numberOfGroups = uniqueN(tokenTransfers$address)
  progressBar <- txtProgressBar(min = 0, max = numberOfGroups, style = 3)
  
  daysec <- 60*60*24
  
  # Compute the feature
  feature <- tokenTransfers[, {setTxtProgressBar(progressBar, .GRP);
    list(transfers_timegap_mean = mean(diff(sort(as.numeric(timestamp)))/daysec),
         transfers_timegap_median = median(diff(sort(as.numeric(timestamp)))/daysec),
         transfers_timegap_max = max(diff(sort(as.numeric(timestamp)))/daysec),
         transfers_timegap_min = min(diff(sort(as.numeric(timestamp)))/daysec))
  }, by=address]
  close(progressBar)
  
  # Join the result with the featureTable
  featureTable <- featureTable[feature, on="address"]
  
  return(featureTable)
  
})(tokenTransfers, featureTable)