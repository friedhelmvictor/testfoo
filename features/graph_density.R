# Wrap everything in an anymous function to avoid polluting the Global Environment
# If you need more debugging capability, remove the anonymous function

# Hint for speed: Use data.tables `set` and also `:=` to avoid copying the full table every time you do something

# This function returns the density of the token distribution graph

# Author: Bianca, added 10.4.2018


featureTable <- (function(tokenTransferTable, featureTable) {
  print("Computing the graph density")
  
  # Set up progress bbar by number of groups
  numberOfGroups = uniqueN(tokenTransfers$address)
  progressBar <- txtProgressBar(min = 0, max = numberOfGroups, style = 3)
  
  # Compute the feature: 
  # we start with the entire data table - "by = address" subsets for each token - then a graph is built from only the "from" and "to" - and the amount of strongly connected components computed 
  # Find the token transfers associated with this token , Build the graph and simplify it, compute density for simplified graph (is not defined for multiedges)
  # evtl. simplify rausnehmen? 
  feature <- tokenTransfers[, 
                            {setTxtProgressBar(progressBar, .GRP);
                              list(graph_density = edge_density(simplify(graph_from_data_frame(.SD[, list(from, to)])), loops = FALSE))
                            }
                            , by = address]
  close(progressBar)

  
  # Join the result with the featureTable
  featureTable <- featureTable[feature, on="address"]
  
  return(featureTable)
  
})(tokenTransfers, featureTable)