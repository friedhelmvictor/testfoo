library(data.table)
library(igraph)

if(!file.exists("config.R")) {
  stop("You must have a config.R file!")
} else {
  source("config.R")
}

tokenTransfers <- fread(config$tokenTransfersFile,
                        colClasses = list("character"=c("address", "from", "to", "amount")),
                        nrows = config$rows)
# verify data 
head(tokenTransfers)


if(exists("tokenTransfers") && is.data.table(get("tokenTransfers"))) {
  
  # Clean the data
  source("clean_data.R")
  
  # Build balances database
  source("build_database.R")
  
  tokenTransfers[, timestamp := as.POSIXct(timestamp, origin="1970-01-01")]
  
  # Create empty feature table
  featureTable <- data.table(address=unique(tokenTransfers$address))
  
  # Execute all files inside /features thereby building the featureTable
  fileSources <- list.files(pattern = "*.R", recursive = T)
  fileSources <- fileSources[grepl("features", fileSources)]
  ignoreOutput <- sapply(fileSources, source, .GlobalEnv)
  rm(ignoreOutput)
}


# Finish and disconnect from server
dbDisconnect(con)
