(function() {
  
  if(config$createPlots) {
    
    addressesAndTransfers <- tokenTransfers[, list(uniqueAddr = uniqueN(rbind(from, to)), transferCount = .N,
                                                   uniqueEdgeCount = ecount(simplify(graph_from_data_frame(.SD[, list(from, to)])))), by=address]
    
    # log-log ccdf of token contracts by transferCounts
    transferCount_ccdf <- ggplot(addressesAndTransfers) +
      geom_point(aes(x = transferCount, y = 1 - ..y..), stat='ecdf', shape=3) +
      scale_x_log10(breaks=1*10^(0:6), labels = comma) +
      scale_y_log10(breaks=1/10^(0:4)) +
      labs(x = "Transfers", y = "P(Transfers >= x)")
    
    ggsave("outputs/transferCount_ccdf.png", transferCount_ccdf, width = 14, height = 10, units = "cm")
    
    # log-log ccdf of token contracts by unique addresses
    uniqueAddr_ccdf <- ggplot(addressesAndTransfers) +
      geom_point(aes(x = uniqueAddr, y = 1 - ..y..), stat='ecdf', shape=3) +
      scale_x_log10(breaks=1*10^(0:6), labels = comma) +
      scale_y_log10(breaks=1/10^(0:4)) +
      labs(x = "Unique Addresses", y = "P(UniqueAddresses >= x)")
    
    ggsave("outputs/uniqueAddr_ccdf.png", uniqueAddr_ccdf, width = 14, height = 10, units = "cm")
    
    # log-log ccdf of token contracts by unique edges(from, to)
    uniqueEdges_ccdf <- ggplot(addressesAndTransfers) +
      geom_point(aes(x = uniqueEdgeCount, y = 1 - ..y..), stat='ecdf', shape=3) +
      scale_x_log10(breaks=1*10^(0:6), labels = comma) +
      scale_y_log10(breaks=1/10^(0:4)) +
      labs(x = "Unique Edges", y = "P(UniqueEdges >= x)")
    
    ggsave("outputs/uniqueEdges_ccdf.png", uniqueEdges_ccdf, width = 14, height = 10, units = "cm")
    
    
    # log-log scatterplot of transfers vs unique addresses
    addressVsTransferCount <- ggplot(addressesAndTransfers) +
      geom_point(aes(x=uniqueAddr, y=transferCount), shape=3) +
      scale_x_log10(breaks=1*10^(0:6), labels = comma) +
      scale_y_log10(breaks=1*10^(0:6), labels = comma) +
      labs(x = "Unique Addresses", y = "Transfers")
    
    ggsave("outputs/addressVsTransferCount.png", addressVsTransferCount, width = 14, height = 10, units = "cm")
    
    # log-log scatterplot - straight line - whats close is probably star pattern?
    addressVsUniqueEdgeCount <- ggplot(addressesAndTransfers) +
      geom_point(aes(x=uniqueAddr, y=uniqueEdgeCount), shape=3) +
      scale_x_log10(breaks=1*10^(0:6), labels = comma) +
      scale_y_log10(breaks=1*10^(0:6), labels = comma) +
      labs(x = "Unique Addresses", y = "Unique Edges")
    
    ggsave("outputs/addressVsUniqueEdgeCount.png", addressVsUniqueEdgeCount, width = 14, height = 10, units = "cm")
    
    addressesAndTransfers[, ratioEdgeAddr := uniqueEdgeCount / uniqueAddr]
    
    # log-log ccdf of token contracts by ratio uniqueEdges/uniqueAddresses
    edgeAddrRatio_ccdf <- ggplot(addressesAndTransfers) +
      geom_line(aes(x = ratioEdgeAddr, y = 1 - ..y..), stat='ecdf') +
      scale_x_continuous(breaks=c(0:10)) +
      #scale_x_log10(breaks=1*10^(0:6), labels = comma) +
      #scale_y_log10(breaks=1/10^(0:4)) +
      labs(x = "Edge/Addr ratio", y = "P(Ratio >= x)")
    
    ggsave("outputs/edgeAddrRatio_ccdf.png", edgeAddrRatio_ccdf, width = 14, height = 10, units = "cm")
    
  }
})()


# g <- graph_from_data_frame(head(tokenTransfers[address == "0x111111f7e9b1fe072ade438f77e1ce861c7ee4e3",
#                                           list(from, to, amount=as.numeric(amount))], 10000))
# 
# l <- layout_with_graphopt(g)
# plot(g,
#      vertex.label = NA,
#      vertex.size = 2,
#      edge.arrow.size = 0.3)
# 
# plot(intergraph::asNetwork(g), vertex.cex = 0.4)
