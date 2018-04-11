## Requirements
- PostgreSQL (keep track of your ``username``, ``password`` and ``database name`` of a newly created, empty database)
- ``R``, ``RStudio`` and packages ``data.table``, ``RPostgreSQL``


## Implemented features

The following is a summary of the features that are to be included. A checkmark indicates that they are already implemented.

### Related to token balances per holder:
- [ ] Wealth distribution (do we include ex-holders?)
  - [ ] Gini coefficient
    - [ ] after last seen transaction
    - [ ] maximum
    - [ ] minimum
    - [ ] trend (slope?) fit
- [ ] Number of token holders
  - [ ] where balance > 0
  - [ ] total number of addresses seen
  - [ ] trend (change per week as a fit)
  - [ ] After initial distribution (how to measure?)
- [ ] Ratio of funds held in exchanges vs individuals
- [ ] Number of different tokens held by an address


### Related to token transfers
- [x] Total number of transfers ([transfers_count.R](/features/transfers_count.R))
- [x] Count of unique senders
- [x] Count of unique receivers
- [ ] Frequency
  - [ ] Per week
    - [ ] average
    - [ ] median
    - [ ] maximum
    - [ ] trend (slope?) fit
- [x] Lifetime in blocks ([transfers_lifespan_blocks.R](/features/transfers_lifespan_blocks.R))
- [x] Time gaps between transfers (mean, median, min, max) ([transfers_timegap.R](/features/transfers_timegap.R))
- [ ] Maximum number of tokens in a transaction
- [ ] How many addresses only receive and never send?
- [ ] Activity time of accounts (period between first and last tx, within cluster??)

#### Graph features
- [x] Number of different degrees (graph_number_of_different_degrees.R)
- [x] Density (graph_density.R)
- [x] Shortest path length (graph diameter) (at current status computed for the directed graph)
- [x] Count of strongly connected components
- [x] Count of weakly connected components
- [x] Fraction of nodes in the largest strongly connected component
- [x] Number of hubs (computation might be debatable, graph_count_hubs.R)
- [ ] Community structure (how to measure?)
- [ ] Connectedness of the transaction graph
- [ ] Graph randomness (Louvain community detection algorithm?)
- [ ] Community connectedness as defined by Miller et. al
- [ ] Degree distribution power law coefficient
- Time changing features (i.e. per month) (how does this feature look like?)
  - [ ] number of new vertices
  - [ ] number of new edges
  - [ ] average vertex degree (in / out) if out deg increases - densification?
  - [ ] density?
  - [ ] average path length
- [ ] number of edges vs number of nodes in log-log scales determine if the graph obeys the densification power law (how to convert to feature?)
- [ ] number of multi-edges
- [ ] number of loops
- [ ] log-log plot of cumulative degree distributions (how to feature?)
  - [ ] power-law fit and p-value analysis using Clauset/Shalizi/Newman; (how to feature?)



### Related to normal transactions
- [ ] Total number of transactions
- [ ] Lifetime until suicide / last transaction
- [ ] Contract interactions with other contracts (how?)
- [ ] Number of contract functions
- [ ] Contract code size
- [ ] Uniqueness of contract code


### External information
#### Related to token price
- [ ] Change in token price (how to measure?)

#### Labeled data
- [ ] utility token or not?
- [ ] fraudulent token?
- [ ] trust score from etherscan?

### Combinations of the above
- [ ] Account age of token holders (from first tx)
- [ ] ICO features (combine normal tx with token tx)
  - [ ] ICO participants
  - [ ] ICO value
  - [ ] ICO speed in ETH/hour
- [ ] Ratio of users that interacted with contract vs. number of users holding a token (at what time?)
- [ ] Average / maximum value of transactions in USD
- [ ] Trading volume (daily)? (How to measure?)
- [ ]


### Other ideas
- Market-cap inflation by token minting?
