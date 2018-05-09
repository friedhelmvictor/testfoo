
### Script to add token creation transfers to the original tokenTransfers file 

tokenTransfers <- fread(config$tokenTransfersFile,
                        colClasses = list("character"=c("address", "from", "to", "amount")),
                        nrows = config$rows)
tokenTransfers[, timestamp := as.POSIXct(timestamp, origin="1970-01-01")]




# for each token address, e.g. 
head(plyr::count(tokenTransfers, "address"), n = 200)
sample_token <- "0x0d8775f648430679a709e98d2b0cb6250d2887ef"
sample_transfers <- subset(tokenTransfers, address == sample_token)
g <- graph_from_data_frame(sample_transfers[, c("from", "to", "timestamp")])
component_information <- components(g, mode = "weak") # has 92 components

# for each component, we need to induce a subgraph: 
subg <- induced_subgraph(g, component_information$membership == 14)
# extract the edges and their timestamp
subg_edgelist <- as.data.frame(as_edgelist(subg))
subg_edgelist$timestamp <- as.data.frame(edge_attr(subg))


edges(subg)
# now find the earliest of the edges - maybe not clear that it's always the first? 
edge_timestamps <- as.data.frame(edge_attr(subg))
edge_timestamps$timestamp <- as.POSIXct(edge_timestamps$timestamp, origin="1970-01-01")
# order the edges by timestamp 


# find the node from which the first edge (in the ordered edge list) leaves
first_node <- substr(as_ids(E(subg)[1]), start = 1, stop = 42)
# add an edge from the contract address to this node 
plot(subg)
subg <- subg %>% add.edges(c(sample_token, first_node), timestamp = 11111)
