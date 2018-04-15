print("Cleaning data")
# TBD


tokenTransfers <- (function() {
  
  # function to compare two tokenTransfers dataframes and output stats
  compareTokenTransferTables <- function(originalTransfers, filteredTransfers, filterDescription) {
    originalTokenContractCount <- length(unique(originalTransfers$address))
    originalTotalTransferCount <- nrow(originalTransfers)
    
    newTokenContractCount <- length(unique(filteredTransfers$address))
    newTotalTransferCount <- nrow(filteredTokenTransfers)
    
    tokenContractsRemoved <- originalTokenContractCount - newTokenContractCount
    tokenContractsRemovedPerc <- round((1 - (newTokenContractCount / originalTokenContractCount))*100, digits = 2)
    
    transfersRemoved <- originalTotalTransferCount - newTotalTransferCount
    transfersRemovedPerc <- round((1 - (newTotalTransferCount / originalTotalTransferCount))*100, digits = 2)
    
    print(paste("============ Applied filter:", filterDescription, "============"))
    print(paste0("Removed ", tokenContractsRemoved, " (",tokenContractsRemovedPerc,"%) Token Contracts. ",
                 "Remaining: ", newTokenContractCount))
    print(paste0("Thus, ", transfersRemoved, " (",transfersRemovedPerc,"%) ", "transfers are removed. ",
                 "Remaining: ", newTotalTransferCount))
  }
  
  #################################################################################################
  ################################ here the actual filters start ##################################
  #################################################################################################
  
  # tokens which have experienced at least 30 transfers 
  minTransferCount <- 30
  filteredTokenTransfers <-
    tokenTransfers[address %in% tokenTransfers[, list(count = .N), by=address][
      count > minTransferCount
      ]$address]
  
  compareTokenTransferTables(tokenTransfers, filteredTokenTransfers,
                             paste("require minimum transfer count of", minTransferCount))
  
  
  return(filteredTokenTransfers)
})()

## potentially include the following checks: 

# 1. tokens which are in erc20contractstats (because then we have their name and symbol)
# 2. only include tokens which appear in more than one block (because then there is some action)



# TODO:
# include some output how many transfers / tokenContracts we have excluded due to which step