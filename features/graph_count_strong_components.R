# Wrap everything in an anymous function to avoid polluting the Global Environment
# If you need more debugging capability, remove the anonymous function

# Hint for speed: Use data.tables `set` and also `:=` to avoid copying the full table every time you do something


featureTable <- (function(tokenTransferTable, featureTable) {
  print("Counting number of strongly connected components")
  
  # Set up progress bbar by number of groups
  numberOfGroups = uniqueN(tokenTransfers$address)
  progressBar <- txtProgressBar(min = 0, max = numberOfGroups, style = 3)
  
  # Compute the feature
  feature <- tokenTransfers[, {setTxtProgressBar(progressBar, .GRP);
    list(graph_count_strong_components = components(graph_from_data_frame(.SD[, list(from, to)]), mode = "strong")$no)
  }, by=address]
  close(progressBar)
  
  # Join the result with the featureTable
  featureTable <- featureTable[feature, on="address"]
  
  return(featureTable)
  
})(tokenTransfers, featureTable)