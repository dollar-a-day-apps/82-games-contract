# Introduction
Contain smart contract files for 82-games on Tron. There are 2 contracts:
1. `Game82Token.sol`: contract of game tickets, one ticket is one token
2. `Game82.sol`: Handle actual voucher purchases (minting) using `TRX`, as well as make predictions for games

# Initial Steps
1. Deploy smart contracts
2. Init the `game82Token` variable using the function `setToken` on the deployed `Game82` contract by setting it to the address of the deployed `Game82Token` contract
3. Optionally, init the `addrFinance` variable using the function `setFinance` on the deployed `Game82` contract by setting it to the address of the `TRX` wallet address designated to hold the funds. By default, the `addrFinance` is set to the address which deployed the contract
