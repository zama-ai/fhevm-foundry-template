# fhevm-foundry-template

This repo is a POC showing how to use fhevmjs functions inside Solidity Foundry scripts. There are two scripts that you can run on Sepolia test network, after setting up your `.env` file (please reuse same keys but different values than the ones given inside `.env.example` and install all npm packages):
The fist one shows how NOT to use reencrypt in a script:

```
forge script script/MyConfidentialERC20Reencrypt.s.sol --rpc-url $SEPOLIA_RPC_URL --ffi --broadcast
```

This script will run but it won't work "as expected" and will log a `0` for the minted balance by Alice instead of the correct value of `1000` which corresponds to the minted amount. This is unavoidable, since in Foundry FFI calls (and console logs) are always happening during the first simulation step, and will never happen during the real transaction broadcasting phase, so getting a 0 value is unavoidable, since the reencrypt function from fhevmjs depends on the real onchain state of Sepolia, after the mint transaction has been validated (see foundry team explanation [here](https://github.com/foundry-rs/foundry/issues/5776#issuecomment-1867287499)). You can still get the correct reencrypted value after the script is done by running:

```
ts-node --transpile-only utils/reencrypt.ts [HANDLE] [PRIVATE_KEY] [CONTRACT_ADDRESS]
```

All of the [HANDLE], [PRIVATE_KEY] and [CONTRACT_ADDRESS] values will be correctly logged by the previously run script.

On the other hand, we have a second script doing user input encryption (using fhevmjs via FFI) + mint + transfer of a confidential erc20, this script runs successfully as expected, because for encryption, contrarily to reencryption/decryption, data does NOT depend on the onchain Sepolia state. You can run it via:

```
forge script script/MyConfidentialERC20Encrypt.s.sol --rpc-url $SEPOLIA_RPC_URL --ffi --broadcast
```

And you can still check that Alice's and Bob's balances are correct after Alice transferred 42 encrypted tokens to Bob via:

```
ts-node --transpile-only utils/reencrypt.ts [HANDLE] [PRIVATE_KEY] [CONTRACT_ADDRESS]
```
