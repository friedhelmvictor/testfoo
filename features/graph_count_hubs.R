# Wrap everything in an anymous function to avoid polluting the Global Environment
# If you need more debugging capability, remove the anonymous function

# Hint for speed: Use data.tables `set` and also `:=` to avoid copying the full table every time you do something

# This function returns the number of hubs 
# Author: Bianca, added 11.4.2018


featureTable <- (function(tokenTransferTable, featureTable) {
  print("Computing the number of hubs")
  
  # Set up progress bbar by number of groups
  numberOfGroups = uniqueN(tokenTransfers$address)
  progressBar <- txtProgressBar(min = 0, max = numberOfGroups, style = 3)
  
  # Compute the feature: 
  # Here, it can't be done in a single line
  # 1. Define a function that accepts an igraph-object as input and returns the number of hubs 
  num_hubs <- function(tokengraph, parameter_mean_degree, parameter_share_of_max){
    temp <- data.frame(deg = degree(tokengraph))
    temp <- plyr::count(temp, "deg")
    hubs <- temp[temp$deg > parameter_mean_degree*mean(degree(tokengraph)), ] 
    if(nrow(hubs) == 0){ hubs <- temp[temp$deg > parameter_share_of_max*max(temp$deg), ] }
    num_hubs <- sum(hubs$freq)
    return(num_hubs)
  }
  
  # 2. Use this function in the common data.table feature computation, where the adjacency list for each tokengraph is generated on the go and the input for the function
  # still debatable whether we should simplify the graph here? 
  feature <- tokenTransfers[,
                            {setTxtProgressBar(progressBar, .GRP);
                            list(graph_count_hubs = num_hubs(graph_from_data_frame(.SD[, list(from, to)]), 15, 0.8))
                            },
                            by = address]
  close(progressBar)
  
  
  # Join the result with the featureTable
  featureTable <- featureTable[feature, on="address"]
  
  return(featureTable)
  
})(tokenTransfers, featureTable)