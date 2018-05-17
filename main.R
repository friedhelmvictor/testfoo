library(data.table)
library(igraph)
library(ggplot2)
library(scales)

options(scipen = 99999999) # display numbers non-scientific


if(!file.exists("config.R")) {
  stop("You must have a config.R file!")
} else {
  source("config.R")
}

erc20ContractStats <- unique(fread(config$contractStatsFile,
                                   colClasses = list("character"=c("result.address"))))
names(erc20ContractStats)[names(erc20ContractStats) == 'result.address'] <- 'address'

tokenTransfers <- unique(fread(config$tokenTransfersFile,
                               colClasses = list("character"=c("address", "from", "to", "amount")),
                               nrows = config$rows))

tokenCreations <- unique(fread(config$tokenCreationsFile,
                               colClasses = list("character"=c("address", "from", "to", "amount"))))

# limit tokenTransfers to those that belong to valid ERC20 contracts
tokenTransfers <- tokenTransfers[address %in% erc20ContractStats$address]

# limit erc20ContractStats to those that have had at least one event
erc20ContractStats <- erc20ContractStats[address %in% unique(tokenTransfers$address)]

# check which tokenCreations already exists as transfers
setkey(tokenCreations, address, blockNumber, to, amount)
setkey(tokenTransfers, address, blockNumber, to, amount)
tokenCreations[, exists := FALSE][tokenTransfers, exists := TRUE]

# add tokenCreations that didn't exist in transfers to tokenTransfers
tokenTransfers <- rbind(tokenTransfers, tokenCreations[exists == FALSE, list(address, blockNumber, from, to, amount, timestamp)])
# remove tokenCreations
rm(tokenCreations)

# verify data 
head(tokenTransfers)


if(exists("tokenTransfers") && is.data.table(get("tokenTransfers"))) {
  
  # Generate plots on uncleaned data
  source("plot_beforefilter.R")
  
  # Clean the data
  source("clean_data.R")
  
  # Build balances database
  source("build_database.R")
  
  tokenTransfers[, timestamp := as.POSIXct(timestamp, origin="1970-01-01")]
  
  # Create empty feature table
  featureTable <- data.table(address=unique(tokenTransfers$address))
  
  # Add names from contractStats file
  featureTable <- featureTable[erc20ContractStats[,list(address, name)], on="address", nomatch=0]
  
  # Execute all files inside /features thereby building the featureTable
  fileSources <- list.files(pattern = "*.R", recursive = T)
  fileSources <- fileSources[grepl("features", fileSources)]
  ignoreOutput <- sapply(fileSources, source, .GlobalEnv)
  rm(ignoreOutput)
}

fwrite(featureTable, file = "featureTable2.csv")
