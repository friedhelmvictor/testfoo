# Wrap everything in an anymous function to avoid polluting the Global Environment
# If you need more debugging capability, remove the anonymous function

# Hint for speed: Use data.tables `set` and also `:=` to avoid copying the full table every time you do something

# This function returns the fraction of nodes in the tokengraph which are in the largest strongly connected component  
# Author: Bianca, added 11.4.2018


featureTable <- (function(tokenTransferTable, featureTable) {
  print("Computing the fraction of nodes in the largest strongly connected component")
  
  # Set up progress bbar by number of groups
  numberOfGroups = uniqueN(tokenTransfers$address)
  progressBar <- txtProgressBar(min = 0, max = numberOfGroups, style = 3)
  
  # Compute the feature: 
  # 1. Define a function that accepts an igraph-object as input and returns the fraction of nodes in the largest SCC 
  fraction_nodes_in_scc <- function(tokengraph){
    return(max(components(tokengraph)$csize)/vcount(tokengraph))
  }
  
  # 2. Use this function in the common data.table feature computation, where the adjacency list for each tokengraph is generated on the go and the input for the function
  feature <- tokenTransfers[,
                            {setTxtProgressBar(progressBar, .GRP);
                              list(fraction_nodes_in_scc = fraction_nodes_in_scc(graph_from_data_frame(.SD[, list(from, to)])))
                            },
                            by = address]
  close(progressBar)
  
  
  # Join the result with the featureTable
  featureTable <- featureTable[feature, on="address"]
  
  return(featureTable)
  
})(tokenTransfers, featureTable)