library(data.table)

tokenFileLocation <- "~/workspaces/data/ethereum/latest/tokenTransfers.csv"
tokenTransfers <- fread(tokenFileLocation, colClasses = list("character"=c("address", "from", "to")))

if(exists("tokenTransfers") && is.data.table(get("tokenTransfers"))) {
  
  # Clean the data
  source("clean_data.R")
  
  # Create empty feature table
  featureTable <- data.table(address=unique(tokenTransfers$address))
  
  # Execute all files inside /features thereby building the featureTable
  fileSources <- list.files(pattern = "*.R", recursive = T)
  fileSources <- fileSources[grepl("features", fileSources)]
  ignoreOutput <- sapply(fileSources, source, .GlobalEnv)
  rm(ignoreOutput)
}



