# Introduction
Contain smart contract files for 82-games on Tron. There are 2 contracts:
1. `Game82Token.sol`: Contract of 82games vouchers (token), handle voucher balances, minting and burning
2. `Game82.sol`: The 'Frontend' side of the two contracts, handle the logic stuffs, including predictions management

# Initial Steps
1. Deploy smart contracts
2. Init the `tokenContract` variable using the function `setTokenContract` on the deployed `Game82` contract by setting it to the address of the deployed `Game82Token` contract
2. Init the `logicContractAddress` variable using the function `setLogicContract` on the deployed `Game82Token` contract by setting it to the address of the deployed `Game82` contract.
3. Optionally, init the `addrFinance` variable using the function `setFinanceAddress` on the deployed `Game82` contract by setting it to the address of the `TRX` wallet address designated to hold the funds. By default, the `addrFinance` is set to the address which deployed the contract

# Client-side Usages
1. `buyVoucher`: Call this method to initiate voucher purchasing
2. `submitPrediction`: Call this method to submit a user prediction (and consume 1 voucher in the process)
