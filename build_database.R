library(RPostgreSQL)

con <- dbConnect(PostgreSQL(), host=config$dbConfig$host,
                 user= config$dbConfig$user, password=config$dbConfig$password,
                 dbname=config$dbConfig$dbname)

(function() {
  # Check if the tokenTransfers database may already exist with same number of rows
  dbExists <- dbExistsTable(con, 'tokenTransfers')
  hasSameRowCount <- tryCatch({
    dbGetQuery(con, 'SELECT COUNT(*) AS count FROM "tokenTransfers"')$count == nrow(tokenTransfers)
  }, error = function(e) { return(FALSE) }, warning = function(e) { return(FALSE) })
  if(dbExists & hasSameRowCount) {
    print('Same number of rows in database.')
    print('Skipping database creation.')
  } else {
    # Otherwise delete remains and create the database anew
    print(paste(Sys.time(), 'Creating database...'))
    
    dbRemoveTable(con, 'tokenTransfers')
    dbWriteTable(con, 'tokenTransfers', tokenTransfers, row.names=F,
                 field.types = list(address='VARCHAR(42)',
                                    blockNumber='INT',
                                    from='VARCHAR(42)',
                                    to='VARCHAR(42)',
                                    amount='DECIMAL(100,0)',
                                    timestamp='INT'))
    print(paste(Sys.time(), 'Creating indices...'))
    dbExecute(con, 'CREATE INDEX address_idx ON "tokenTransfers"(address);')
    print(paste(Sys.time(), 'Finished.'))
  }
})()


# TODO:
# Extract to own file
# Perform index creation
# Create balances
# Create indexes on balances
# Introduce checks whether its really necessary to rebuild the database
dbDisconnect(con)
# dbGetQuery(mydb, 'PRAGMA table_info(mtcars);') # Get data types