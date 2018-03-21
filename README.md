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
  - [ ]


### Related to token transfers
- [x] Count of unique senders
- [x] Count of unique receivers
- [ ] Frequency
  - [ ] Per week
    - [ ] average
    - [ ] median
    - [ ] maximum
    - [ ] trend (slope?) fit
- [x] Lifetime in blocks
