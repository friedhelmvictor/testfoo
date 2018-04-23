# Wrap everything in an anymous function to avoid polluting the Global Environment
# If you need more debugging capability, remove the anonymous function

# Hint for speed: Use data.tables `set` and also `:=` to avoid copying the full table every time you do something

featureTable <- (function(tokenTransferTable, featureTable) {
  print("Computing power law statistics of node degrees (coefficient and KS goodness-of-fit")
  
  # Set up progress bbar by number of groups
  numberOfGroups = uniqueN(tokenTransfers$address)
  progressBar <- txtProgressBar(min = 0, max = numberOfGroups, style = 3)
  
  degree_distribution_PLfit <- function(graph, mode="all") {
    degrees <- degree(graph, mode = mode)
    powerLawFit <- power.law.fit(degrees)
    return(powerLawFit)
  }
  
  # Compute the feature
  feature <- tokenTransfers[, {setTxtProgressBar(progressBar, .GRP);
    list(graph_indegree_power_law_alpha = degree_distribution_PLfit(graph_from_data_frame(.SD[, list(from, to)]), mode = "in")$alpha,
         graph_indegree_power_law_KS = degree_distribution_PLfit(graph_from_data_frame(.SD[, list(from, to)]), mode = "in")$KS.stat,
         graph_outdegree_power_law_alpha = degree_distribution_PLfit(graph_from_data_frame(.SD[, list(from, to)]), mode = "out")$alpha,
         graph_outdegree_power_law_KS = degree_distribution_PLfit(graph_from_data_frame(.SD[, list(from, to)]), mode = "out")$KS.stat)
  }, by=address]
  close(progressBar)
  
  # Join the result with the featureTable
  featureTable <- featureTable[feature, on="address"]
  
  return(featureTable)
  
})(tokenTransfers, featureTable)



# plot_degree_distribution <- function(graph, mode="all") {
#   degrees <- degree(g, mode = mode)
#   powerLawFit <- power.law.fit(degrees)
#   print(paste("α:", powerLawFit$alpha, "D:", powerLawFit$KS.stat))
#   
#   dd <- degree_distribution(graph, mode = mode, cumulative = T)
#   ddframe <- data.frame(degree = 0:(length(dd)-1), probability = dd)
#   ggplot(ddframe) + geom_point(aes(x=degree, y=probability), shape=4) + scale_x_log10() + scale_y_log10()
# }