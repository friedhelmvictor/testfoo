# Wrap everything in an anymous function to avoid polluting the Global Environment
# If you need more debugging capability, remove the anonymous function

# Hint for speed: Use data.tables `set` and also `:=` to avoid copying the full table every time you do something

# This function computes the fraction of edges that connect to the vertices with the highest degrees - so far, we consider the *total* degree here, meaning the sum of in-and out-degree 
# Author: Bianca, added 09.05.2018


featureTable <- (function(tokenTransferTable, featureTable) {
  print("Computing the fraction of edges that connect to the vertices with the highest degrees")
  
  # Set up progress bbar by number of groups
  numberOfGroups = uniqueN(tokenTransfers$address)
  progressBar <- txtProgressBar(min = 0, max = numberOfGroups, style = 3)
  
  # Compute the feature: 
  # Function Parameter: P - fraction of nodes with highest degrees to be considered, per default set to 0.01 
  fraction_edges <- function(adjacency_list, P = 0.01){
    ## 1. Transform to graph to get the n_p vertices with the highest degrees
    g <- graph_from_data_frame(adjacency_list[, c("from", "to")])
    # number of edges (multigraph): 
    num_edges <- ecount(g)
    # sort the vertices by highest [in]-degree? or total degree? stick to total degree first 
    degrees <- as.data.frame(degree(g))
    degrees$vertex <- row.names(degrees)
    degrees <- degrees[order(degrees$`degree(g)`, decreasing = TRUE),]
    # find the n_p nodes with highest degree (round the fraction up)
    highest_degree_nodes <- degrees[1:ceiling((nrow(degrees)*P)), ]
    ## 2. For these nodes, find all edges for which they are either starting or ending point 
    adjacency_list <- as.data.frame(t(apply(adjacency_list[, c("from", "to")], 1, function(x) sort(x))))
    names(adjacency_list) <- c("vertex1", "vertex2")
    imp_edges <- subset(adjacency_list, vertex1 %in% highest_degree_nodes$vertex | vertex2 %in% highest_degree_nodes)
    # delete duplicates 
    imp_edges <- unique(imp_edges)
    # return their fraction related to the total number of edges 
    return(nrow(imp_edges)/num_edges)
  } 
  
  
  # 2. Use the helper function in the feature computation 
  feature <- tokenTransfers[, 
                            {setTxtProgressBar(progressBar, .GRP);
                              list(graph_fraction_edges = fraction_edges(.SD[, list(from, to)]))
                            },
                            by = address]
  close(progressBar)
  
  
  # Join the result with the featureTable
  featureTable <- featureTable[feature, on="address"]
  
  return(featureTable)
  
})(tokenTransfers, featureTable)