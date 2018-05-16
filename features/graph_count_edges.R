# Wrap everything in an anymous function to avoid polluting the Global Environment
# If you need more debugging capability, remove the anonymous function

# Hint for speed: Use data.tables `set` and also `:=` to avoid copying the full table every time you do something


# This function returns the number of edges  

featureTable <- (function(tokenTransferTable, featureTable) {
  print("Counting number of edges")
  
  # Set up progress bbar by number of groups
  numberOfGroups = uniqueN(tokenTransfers$address)
  progressBar <- txtProgressBar(min = 0, max = numberOfGroups, style = 3)
  
  # Compute the feature
  feature <- tokenTransfers[,
                            {setTxtProgressBar(progressBar, .GRP);
                              list(graph_count_edges = igraph::ecount(igraph::graph_from_data_frame(.SD[, list(from, to)])))
                            },
                            by = address]
  close(progressBar)
  
  # Join the result with the featureTable
  featureTable <- featureTable[feature, on="address"]
  
  return(featureTable)
  
})(tokenTransfers, featureTable)
