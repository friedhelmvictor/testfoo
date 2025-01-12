# Wrap everything in an anymous function to avoid polluting the Global Environment
# If you need more debugging capability, remove the anonymous function

# Hint for speed: Use data.tables `set` and also `:=` to avoid copying the full table every time you do something

# This function returns the global clustering coefficient - we need to define two different possible ways (either by triangles or by taking the average of the local clustering coefficients) - currently, it is computed via triangles
# Author: Bianca, added 07.05.2018


featureTable <- (function(tokenTransferTable, featureTable) {
  print("Computing the global clustering coefficient")
  
  # Set up progress bbar by number of groups
  numberOfGroups = uniqueN(tokenTransfers$address)
  progressBar <- txtProgressBar(min = 0, max = numberOfGroups, style = 3)
  
  # Compute the feature: 
  feature <- tokenTransfers[, 
                            {setTxtProgressBar(progressBar, .GRP);
                              list(graph_global_clustering_coefficient = igraph::transitivity(igraph::graph_from_data_frame(.SD[, list(from, to)]), type = "global"))
                            },
                            by = address]
  close(progressBar)
  
  
  # Join the result with the featureTable
  featureTable <- featureTable[feature, on="address"]
  
  return(featureTable)
  
})(tokenTransfers, featureTable)