# Wrap everything in an anymous function to avoid polluting the Global Environment
# If you need more debugging capability, remove the anonymous function

# Hint for speed: Use data.tables `set` and also `:=` to avoid copying the full table every time you do something

# This function returns the number of different degrees in a graph - here without "simplify"! 
# Author: Bianca, added 11.4.2018


featureTable <- (function(tokenTransferTable, featureTable) {
  print("Computing the number of different in/out degrees and largest of each")
  
  # Set up progress bbar by number of groups
  numberOfGroups = uniqueN(tokenTransfers$address)
  progressBar <- txtProgressBar(min = 0, max = numberOfGroups, style = 3)
  
  # Compute the feature: 
  feature <- tokenTransfers[, 
                            {setTxtProgressBar(progressBar, .GRP);
                              graph <- simplify(graph_from_data_frame(.SD[, list(from, to)]));
                              indegrees <- degree(graph, mode = "in", loops = FALSE);
                              outdegrees <- degree(graph, mode = "out", loops = FALSE);
                              list(graph_unique_indegrees = length(unique(indegrees)),
                                   graph_largest_indegree = max(indegrees),
                                   graph_unique_outdegrees = length(unique(outdegrees)),
                                   graph_largest_outdegree = max(outdegrees))
                              
                            }
                            , by = address]
  close(progressBar)
  
  
  # Join the result with the featureTable
  featureTable <- featureTable[feature, on="address"]
  
  return(featureTable)
  
})(tokenTransfers, featureTable)