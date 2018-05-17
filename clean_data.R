print("Cleaning data")
# TBD

appliedFilters <- data.table("Filter" = character(0),
                             "Contracts removed" = numeric(0),
                             "(%)" = numeric(0),
                             "Contracts remaining" = numeric(0),
                             "Transfers removed" = numeric(0),
                             "(%)" = numeric(0),
                             "Transfers remaining" = numeric(0)
                             )

appliedFilters <<- rbind(appliedFilters, list("None - Original dataset", 0, 0, length(unique(tokenTransfers$address)), 0, 0, nrow(tokenTransfers)))

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
    
    appliedFilters <<- rbind(appliedFilters, list(filterDescription,
                                                 tokenContractsRemoved, tokenContractsRemovedPerc, newTokenContractCount,
                                                 transfersRemoved, transfersRemovedPerc, newTotalTransferCount))
  }
  
  
  
  
  
  
  #################################################################################################
  ################################ here the actual filters start ##################################
  #################################################################################################
  
  # tokens which have  at least 1000 addresses involved 
  minAddressCount <- 1000
  filteredTokenTransfers <-
    tokenTransfers[address %in% tokenTransfers[, list(uniqueAddr = uniqueN(rbind(from, to))), by=address][
      uniqueAddr >= minAddressCount
      ]$address]
  
  compareTokenTransferTables(tokenTransfers, filteredTokenTransfers,
                             paste("Require address count >=", minAddressCount))
  
  
  
  # tokens which have at least 10000 transfers 
  minTransferCount <- 10000
  filteredTokenTransfers <-
    tokenTransfers[address %in% tokenTransfers[, list(count = .N), by=address][
      count >= minTransferCount
      ]$address]
  
  compareTokenTransferTables(tokenTransfers, filteredTokenTransfers,
                             paste("Require transfer count >=", minTransferCount))
  
  
  tokenTransfers <- filteredTokenTransfers

  
  
  return(filteredTokenTransfers)
})()

## potentially include the following checks: 

# 1. tokens which are in erc20contractstats (because then we have their name and symbol)
# 2. only include tokens which appear in more than one block (because then there is some action)