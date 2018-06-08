theme_Publication <- function(base_size=14, base_family="Times New Roman") {
  library(grid)
  library(ggthemes)
  library(extrafont)
  (theme_foundation(base_size=base_size, base_family=base_family)
    + theme(plot.title = element_text(#face = "bold",
                                      size = rel(1.2), hjust = 0.5),
            text = element_text(),
            panel.background = element_rect(colour = "black"),
            plot.background = element_rect(colour = NA),
            panel.border = element_rect(colour = NA),
            axis.title = element_text(size = rel(1)),
            axis.title.y = element_text(angle=90,vjust =2),
            axis.title.x = element_text(vjust = -0.2),
            axis.text = element_text(), 
            axis.line = element_line(colour="black"),
            axis.ticks = element_line(),
            panel.grid.major = element_line(colour="#f0f0f0"),
            panel.grid.minor = element_blank(),
            legend.key = element_rect(colour = NA),
            legend.position = "bottom",
            legend.direction = "horizontal",
            legend.key.size= unit(1, "cm"),
            legend.margin = unit(0, "cm"),
            legend.title = element_text(face="italic"),
            plot.margin=unit(c(10,5,5,5),"mm"),
            strip.background=element_rect(colour="#f0f0f0",fill="#f0f0f0"),
            strip.text = element_text(size = 14)#element_text(face="bold")
    ))
}


# analysis of the entire graph
# 
# wholeGraph <- graph_from_data_frame(tokenTransfers[, list(from, to)])
# outdframe <- as.data.frame(degree(wholeGraph, mode = "out"))
# names(outdframe) <- c("address", "outdegree")
# setDT(outdframe, keep.rownames = TRUE)
# setkey(outdframe, address)
# 
# indframe <- as.data.frame(degree(wholeGraph, mode = "in"))
# names(indframe) <- c("address", "indegree")
# setDT(indframe, keep.rownames = TRUE)
# setkey(indframe, address)
# 
# degreeFrame <- outdframe[indframe]

# showing the popularity of ERC20-based Tokens
tokenTransfersOverTime <- tokenTransfers[timestamp < "2018-05-01", list(count = .N), by=list(time=as.Date(cut(timestamp, "1 month")))]
tokenTransfersOverTimePlot <- ggplot(tokenTransfersOverTime) +
  geom_bar(aes(x=time, y=count), stat="identity") +
  scale_y_continuous(label=comma) +
  labs(x = "Month", y = "New ERC20 Transfers") +
  theme_Publication()
ggsave("outputs/tokenTransfersOverTime.pdf", tokenTransfersOverTimePlot, width = 14, height = 7.5, units = "cm")
rm(tokenTransfersOverTime)
rm(tokenTransfersOverTimePlot)

# txToContracts <- ggplot(monthlyStats[!is.na(isERC20)]) +
#   geom_bar(aes(x=month, y=count, fill=isERC20), color="black", stat="identity") +
#   scale_x_date(labels = date_format("%Y-%d")) +
#   scale_y_continuous(breaks=seq(0,10,2)*10^6, labels=comma) +
#   theme_Publication() +
#   theme(legend.position="right") +
#   labs(x="Month", y="Transactions")
# 
# ggsave("outputs/txToContracts.pdf", txToContracts, height = 7.5, width = 21, units="cm")

# show how many contracts have more than x transfers
contractsTransfersCdf <- featureTable[order(-rank(transfers_count))][, list(number = .I, cumTransfers = cumsum(transfers_count)/nrow(tokenTransfers))]
contractsTransfersCdfPlot <- ggplot(contractsTransfersCdf) +
  geom_line(aes(x=number, y=cumTransfers)) +
  scale_x_log10(breaks=1*10^(0:6)) +
  annotation_logticks(sides = "b") +
  scale_y_continuous(breaks=seq(0,1,0.25), limits = c(0, 1)) +
  labs(x = "Number of token contracts", y = "Fraction of all transfers") +
  theme_Publication()
ggsave("outputs/contractsTransfersCdf.pdf", contractsTransfersCdfPlot, width = 14, height = 7.5, units = "cm")
rm(contractsTransfersCdf)
rm(contractsTransfersCdfPlot)

# show how many contracts have more than x nodes
contractsNodesCcdfPlot <- ggplot(featureTable[order(-rank(graph_count_nodes))][, list(num = .I, graph_count_nodes)]) +
  geom_line(aes(x=num, y=graph_count_nodes)) +
  scale_y_log10(breaks=1*10^(0:6)) +
  scale_x_log10(breaks=1*10^(0:6)) +
  annotation_logticks(sides = "b") +
  labs(x = "Number of token contracts", y = "Number of addresses involved") +
  theme_Publication()
ggsave("outputs/contractsNodesCcdf.pdf", contractsNodesCcdfPlot, width = 14, height = 7.5, units = "cm")
rm(contractsNodesCcdfPlot)


# show how many nodes are responsible for 99% of edges
nodesResponsibleFor99PercEdges <- featureTable[, list(number_nodes_99_perc)][
  order(rank(number_nodes_99_perc))][
    , list(number_nodes_99_perc, numTokenNetworks = .I/.N)]
nodesResponsibleFor99PercEdges <- nodesResponsibleFor99PercEdges[order(rank(number_nodes_99_perc),
                     -rank(numTokenNetworks))][
                       !duplicated(nodesResponsibleFor99PercEdges$number_nodes_99_perc)]

nodesResponsibleFor99PercEdgesPlot <- ggplot(nodesResponsibleFor99PercEdges) +
  geom_point(aes(x=number_nodes_99_perc, y=numTokenNetworks), shape=4) +
  scale_x_log10(breaks=1*10^(0:5)) +
  scale_y_continuous(limits = c(0, 1),breaks=seq(0,1,0.1), labels=percent) +
  annotation_logticks(sides="b") +
  labs(x="Adresses", y="Token networks") +
  theme_Publication()
ggsave("outputs/nodesResponsibleFor99PercEdges.pdf", nodesResponsibleFor99PercEdgesPlot, width = 14, height = 7.5, units = "cm")


# example stats of 3 token contracts, EOS, Aragon and VIU
EOSaddr <- "0x86fa049857e0209aa7d9e616f7eb3b3b78ecfdb0"
Aragonaddr <- "0x960b236a07cf122663c4303350609a66a7b288c0"
VIUaddr <- "0x519475b31653e46d20cd09f9fdcf3b12bdacb4f5"
POGOaddr <- "0x47a16e51bcc89c0015622fe83eb482a4522f6c5c"
BeautyChainaddr <- "0x3495ffcee09012ab7d827abf3e3b3ae428a38443"

plot_degree_distribution <- function(graph, mymode="all") {
  degrees <- unname(degree(graph, mode = mymode))
  powerLawFit <- power.law.fit(degrees)
  print(paste("α:", powerLawFit$alpha, "D:", powerLawFit$KS.stat))

  dd <- degree_distribution(graph, mode = mymode, cumulative = T)
  ddframe <- data.frame(degree = 0:(length(dd)-1), probability = dd)
  ggplot(ddframe) + geom_point(aes(x=degree, y=probability), shape=4) +
    scale_x_log10() +
    scale_y_log10() +
    annotation_logticks()
}

plot_power_law_examples <- function(addresses, names) {
  ddframe <<- data.table(name=character(), degree=numeric(), cumcount=numeric(), probability=numeric(), analysisMode=character())
  
  for (analysisMode in c("out", "in")) {
    ylab <- ifelse(analysisMode == "out", "P(Outdegree >= x)", "P(Indegree >= x)")
    for (i in 1:length(addresses)) {
      tokenName <- names[i]
      tokenAddress <- addresses[i]
      graph <- simplify(graph_from_data_frame(tokenTransfers[address == tokenAddress, list(from, to)]))
      degrees <- unname(degree(graph, mode = analysisMode))
      powerLawFit <- power.law.fit(degrees, xmin = 1)
      print(paste(tokenName, analysisMode, "α:", powerLawFit$alpha, "D:", powerLawFit$KS.stat, "p:", powerLawFit$KS.p, "xmin:",powerLawFit$xmin ))
      
      dd <- data.table(degree=unname(degree(graph, mode = analysisMode)))[
        , list(count = .N), by=degree][
          order(rank(-degree))][
            ,list(degree, cumcount = cumsum(count))]
      dd[, probability := cumcount / max(cumcount)]
      dd[, name := tokenName]
      dd[, analysisMode := ylab]
      ddframe <- rbind(ddframe, dd)
    }
  }
  return(ggplot(ddframe) +
           geom_point(aes(x=degree, y=cumcount), shape=4) +
           facet_grid(analysisMode ~ name) +
           scale_x_log10(breaks = c(1, 100, 10000, 1000000), labels=comma)+
           scale_y_log10(breaks = c(1, 100, 10000, 1000000), labels=comma) +
           annotation_logticks() +
           theme_Publication() +
           labs(x="Degree", y="#Addresses (Outdegree >= x)               # Addresses (Indegree >= x)") +
           theme(strip.text.y = element_blank()) + # remove right side grey boxes
           theme(panel.spacing = unit(2, "lines")) # add some more spacing
  )
}

plExamples <- plot_power_law_examples(c(EOSaddr, Aragonaddr, VIUaddr), c("a) EOS", "b) ANT", "c) VIU"))
ggsave("outputs/powerLawExamples.png", plExamples, width = 23, height = 15, units = "cm")
ggsave("outputs/powerLawExamples.pdf", plExamples, width = 23, height = 15, units = "cm")



# plot powerlaw coefficient distribution
power_law_distribution <- rbind(featureTable[number_nodes_99_perc > 1, list(type="Indegree", alpha=graph_indegree_power_law_alpha, KS=graph_indegree_power_law_KS)],
                                featureTable[number_nodes_99_perc > 1, list(type="Outdegree", alpha=graph_outdegree_power_law_alpha, KS=graph_outdegree_power_law_KS)])

power_law_distribution_plot <- ggplot(power_law_distribution) +
  geom_histogram(aes(x=alpha, fill=KS<0.1), binwidth = 0.5, color="black") +
  scale_x_continuous(breaks=c(1:10)) +
  facet_grid(type ~ .) +
  labs(x="Power-law coefficient alpha", y="Token networks") +
  scale_fill_discrete(name = "KS D < 0.1") +
  theme_Publication() + theme(legend.position="right") +
  theme(panel.spacing = unit(2, "lines")) # add some more spacing
ggsave("outputs/powerLawAlphaDistribution.pdf", width=20, height=15, units = "cm")


# plot assortativity distribution
assortativity_distribution_plot <- ggplot(featureTable) +
  geom_histogram(aes(x=graph_degree_assortativity, y=(..count..)/sum(..count..)), color="white", binwidth = 0.1) +
  scale_y_continuous(breaks = c(0, 0.04, 0.08, 0.15, 0.25), labels=percent) +
  scale_x_continuous(breaks=seq(-1,1, 0.1)) +
  theme_Publication() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5)) +
  labs(x = "Assortativity coefficient", y = "Token networks")
ggsave("outputs/assortativity_distribution.pdf", assortativity_distribution_plot, width = 14, height = 7.5, units = "cm")
