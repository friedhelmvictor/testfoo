# Wrap everything in an anymous function to avoid polluting the Global Environment
# If you need more debugging capability, remove the anonymous function

# Hint for speed: Use data.tables `set` and also `:=` to avoid copying the full table every time you do something

# This function returns the radius, diameter, mean and median eccentricity


featureTable <- (function(tokenTransferTable, featureTable) {
  print("Computing radius, diameter, mean and median eccentricity")

  # Set up progress bbar by number of groups
  numberOfGroups = uniqueN(tokenTransfers$address)
  progressBar <- txtProgressBar(min = 0, max = numberOfGroups, style = 3)

  feature <- tokenTransfers[,
                            { setTxtProgressBar(progressBar, .GRP);
                              ecc <- igraph::eccentricity(
                                igraph::simplify(
                                  igraph::graph_from_data_frame(.SD[, list(from, to)])
                                  ), mode = "out")
                              #ecc <- setdiff(ecc, 0) # 0 eccentricity shouldn't be possible?!
                              list(graph_radius=min(ecc),
                                   graph_diameter=max(ecc),
                                   graph_mean_eccentricity=mean(ecc),
                                   graph_median_eccentricity=median(ecc))
                            }
                            , by = address]
  close(progressBar)

  featureTable <- featureTable[feature, on="address"]
  return(featureTable)

})(tokenTransfers, featureTable)