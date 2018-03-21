library(data.table)


config <- list(tokenTransfersFile = '~/workspaces/data/ethereum/latest/tokenTransfers.csv',
               dbConfig = list(host = 'localhost', user = 'postgres',
                               password = 'postgres', dbname = 'postgres'),
               createPlots = FALSE,
               rows = 1000000) # -1 for all


# TODO: Create config file with filename, and database details as well as what this script will build
tokenTransfers <- fread(config$tokenTransfersFile,
                        colClasses = list("character"=c("address", "from", "to", "amount")),
                        nrows = config$rows)

if(exists("tokenTransfers") && is.data.table(get("tokenTransfers"))) {
  
  # Clean the data
  source("clean_data.R")
  
  # Build balances database
  source("build_database.R")
  
  # Create empty feature table
  featureTable <- data.table(address=unique(tokenTransfers$address))
  
  # Execute all files inside /features thereby building the featureTable
  fileSources <- list.files(pattern = "*.R", recursive = T)
  fileSources <- fileSources[grepl("features", fileSources)]
  ignoreOutput <- sapply(fileSources, source, .GlobalEnv)
  rm(ignoreOutput)
}



