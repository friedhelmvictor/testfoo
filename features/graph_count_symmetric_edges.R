# Wrap everything in an anymous function to avoid polluting the Global Environment
# If you need more debugging capability, remove the anonymous function

# Hint for speed: Use data.tables `set` and also `:=` to avoid copying the full table every time you do something

# This function returns the number of unique sink recipients, i.e., the number of nodes that have only incoming, but no outgoing edges.
# First, create a graph from the "from" and "to", then determine all nodes that have zero out-degree, and count their number.
# Author: Friedhelm, added 20.5.2018

featureTable <- (function(tokenTransferTable, featureTable) {
  print("Counting number of symmetric edges")
  
  # Set up progress bbar by number of groups
  numberOfGroups = uniqueN(tokenTransfers$address)
  progressBar <- txtProgressBar(min = 0, max = numberOfGroups, style = 3)
  
  getSymmetricEdgeCount <- function(transfers) {
    
  }
  
  # Compute the feature
  feature <- tokenTransfers[,
                            {setTxtProgressBar(progressBar, .GRP);
                              list(graph_count_symmetric_edges = 
                                     nrow(merge(unique(.SD[from != to, list(from, midpoint = to)]),
                                                unique(.SD[from != to, list(midpoint = from, to)]), by= "midpoint", allow.cartesian=TRUE)[
                                                  from == to]))
                            },
                            by = address]
  close(progressBar)
  
  # Join the result with the featureTable
  featureTable <- featureTable[feature, on="address"]
  
  return(featureTable)
  
})(tokenTransfers, featureTable)
